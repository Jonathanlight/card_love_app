import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart' as iap;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/pack_constants.dart';
import '../services/purchase_service.dart';
import 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final PurchaseService _purchaseService;
  final SharedPreferences _prefs;
  StreamSubscription<List<iap.PurchaseDetails>>? _purchaseSubscription;

  static const String _purchasedPacksKey = 'purchased_packs';
  static const String _legacyUserKey = 'legacy_user';
  static const String _firstInstallVersionKey = 'first_install_version';
  static const String _currentVersion = '2.0.0'; // Version with IAP
  static const String _legacyVersion = '1.0.0'; // Version before IAP

  // TEST MODE: Set to true to bypass IAP and test UI locally
  static const bool _testMode = true;

  PurchaseCubit(this._purchaseService, this._prefs) : super(const PurchaseState());

  /// Initialize purchase system
  Future<void> initialize() async {
    emit(state.copyWith(status: AppPurchaseStatus.loading));

    try {
      // Check if user is legacy user
      final isLegacy = await _checkLegacyUser();

      // Load local purchases
      final localPurchases = await _loadLocalPurchases();

      // TEST MODE: Skip IAP initialization and use mock data
      if (_testMode) {
        emit(state.copyWith(
          status: AppPurchaseStatus.available,
          ownedPackIds: localPurchases,
          products: {}, // Empty map in test mode
          isLegacyUser: isLegacy,
        ));
        return;
      }

      // PRODUCTION MODE: Initialize real IAP
      // Initialize IAP store
      final storeAvailable = await _purchaseService.initialize();
      if (!storeAvailable) {
        emit(state.copyWith(
          status: AppPurchaseStatus.error,
          errorMessage: 'Store not available',
          isLegacyUser: isLegacy,
        ));
        return;
      }

      // Load products from store
      final products = await _purchaseService.loadProducts(PackConstants.allProductIds);

      // Listen to purchase stream
      _purchaseSubscription = _purchaseService.purchaseStream.listen(
        _handlePurchaseUpdates,
        onError: (error) {
          emit(state.copyWith(
            status: AppPurchaseStatus.error,
            errorMessage: error.toString(),
          ));
        },
      );

      // Silently restore purchases to validate local storage
      try {
        await _purchaseService.restorePurchases();
      } catch (e) {
        // Ignore restore errors during initialization
        print('Silent restore failed: $e');
      }

      emit(state.copyWith(
        status: AppPurchaseStatus.available,
        ownedPackIds: localPurchases,
        products: products,
        isLegacyUser: isLegacy,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AppPurchaseStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Purchase a pack
  Future<void> purchasePack(String packId) async {
    if (state.isPurchased(packId)) {
      emit(state.copyWith(
        errorMessage: 'Already owned',
      ));
      return;
    }

    try {
      emit(state.copyWith(
        status: AppPurchaseStatus.purchasing,
        purchasingPackId: packId,
      ));

      // TEST MODE: Simulate purchase locally
      if (_testMode) {
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 1));

        // Add pack to owned packs
        final updatedPacks = [...state.ownedPackIds, packId];
        await _saveLocalPurchases(updatedPacks);

        emit(state.copyWith(
          status: AppPurchaseStatus.available,
          ownedPackIds: updatedPacks,
          purchasingPackId: null,
          errorMessage: null,
        ));
        return;
      }

      // PRODUCTION MODE: Use real IAP
      final product = state.getProduct(packId);
      if (product == null) {
        emit(state.copyWith(
          status: AppPurchaseStatus.available,
          errorMessage: 'Product not found',
          purchasingPackId: null,
        ));
        return;
      }

      await _purchaseService.buyProduct(product);
    } catch (e) {
      emit(state.copyWith(
        status: AppPurchaseStatus.available,
        errorMessage: e.toString(),
        purchasingPackId: null,
      ));
    }
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    emit(state.copyWith(isRestoring: true));

    try {
      // TEST MODE: Just reload local purchases
      if (_testMode) {
        await Future.delayed(const Duration(milliseconds: 500));
        final localPurchases = await _loadLocalPurchases();

        emit(state.copyWith(
          isRestoring: false,
          ownedPackIds: localPurchases,
          errorMessage: null,
        ));
        return;
      }

      // PRODUCTION MODE: Restore from store
      await _purchaseService.restorePurchases();

      // The actual restoration happens in _handlePurchaseUpdates
      // Wait a moment for the stream to process
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(
        isRestoring: false,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isRestoring: false,
        errorMessage: 'Restore error',
      ));
    }
  }

  /// Check if pack is unlocked
  bool isPackUnlocked(String packId) {
    return state.isPurchased(packId);
  }

  /// Get all unlocked pack IDs
  List<String> getUnlockedPackIds() {
    if (state.isLegacyUser) {
      // Legacy users get all packs for free
      return PackConstants.allProductIds;
    }
    return state.ownedPackIds;
  }

  /// Check if user is a legacy user (had app before IAP)
  Future<bool> _checkLegacyUser() async {
    // Check if already marked as legacy
    final isLegacy = _prefs.getBool(_legacyUserKey);
    if (isLegacy != null) {
      return isLegacy;
    }

    // Check first install version
    final firstVersion = _prefs.getString(_firstInstallVersionKey);
    if (firstVersion == null) {
      // This is a new install
      await _prefs.setString(_firstInstallVersionKey, _currentVersion);
      await _prefs.setBool(_legacyUserKey, false);
      return false;
    }

    // Compare versions
    final isOldUser = _compareVersions(firstVersion, _legacyVersion) <= 0;
    await _prefs.setBool(_legacyUserKey, isOldUser);
    return isOldUser;
  }

  /// Compare two version strings (simple comparison)
  int _compareVersions(String v1, String v2) {
    final parts1 = v1.split('.').map(int.parse).toList();
    final parts2 = v2.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      if (parts1[i] < parts2[i]) return -1;
      if (parts1[i] > parts2[i]) return 1;
    }
    return 0;
  }

  /// Load purchased packs from local storage
  Future<List<String>> _loadLocalPurchases() async {
    try {
      final purchasesJson = _prefs.getStringList(_purchasedPacksKey);
      return purchasesJson ?? [];
    } catch (e) {
      return [];
    }
  }

  /// Save all purchased packs to local storage
  Future<void> _saveLocalPurchases(List<String> packIds) async {
    try {
      await _prefs.setStringList(_purchasedPacksKey, packIds);
    } catch (e) {
      print('Error saving purchases: $e');
    }
  }

  /// Save purchased pack to local storage
  Future<void> _savePurchase(String packId) async {
    try {
      final purchases = List<String>.from(state.ownedPackIds);
      if (!purchases.contains(packId)) {
        purchases.add(packId);
        await _prefs.setStringList(_purchasedPacksKey, purchases);
        emit(state.copyWith(ownedPackIds: purchases));
      }
    } catch (e) {
      print('Error saving purchase: $e');
    }
  }

  /// Handle purchase updates from stream
  void _handlePurchaseUpdates(List<iap.PurchaseDetails> purchaseDetailsList) {
    for (final purchase in purchaseDetailsList) {
      _verifyAndSavePurchase(purchase);
    }
  }

  /// Verify and save a purchase
  Future<void> _verifyAndSavePurchase(iap.PurchaseDetails purchase) async {
    if (purchase.status == iap.PurchaseStatus.purchased ||
        purchase.status == iap.PurchaseStatus.restored) {
      // Purchase successful, save it
      final packId = purchase.productID;
      await _savePurchase(packId);

      // Complete the purchase
      await _purchaseService.completePurchase(purchase);

      // Update state
      emit(state.copyWith(
        status: AppPurchaseStatus.available,
        purchasingPackId: null,
        errorMessage: null,
      ));
    } else if (purchase.status == iap.PurchaseStatus.error) {
      // Purchase failed
      emit(state.copyWith(
        status: AppPurchaseStatus.available,
        errorMessage: purchase.error?.message ?? 'Purchase failed',
        purchasingPackId: null,
      ));

      // Still complete the purchase to clear it
      await _purchaseService.completePurchase(purchase);
    } else if (purchase.status == iap.PurchaseStatus.pending) {
      // Purchase is pending (e.g., awaiting parental approval)
      emit(state.copyWith(
        status: AppPurchaseStatus.purchasing,
        purchasingPackId: purchase.productID,
      ));
    } else if (purchase.status == iap.PurchaseStatus.canceled) {
      // User canceled
      emit(state.copyWith(
        status: AppPurchaseStatus.available,
        purchasingPackId: null,
      ));
    }
  }

  @override
  Future<void> close() {
    _purchaseSubscription?.cancel();
    _purchaseService.dispose();
    return super.close();
  }
}
