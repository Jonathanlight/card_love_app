import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Initialize the IAP plugin and return whether store is available
  Future<bool> initialize() async {
    try {
      final available = await _iap.isAvailable();
      if (!available) {
        return false;
      }

      // Set up platform-specific configurations
      // iOS delegate is optional and not needed for basic IAP functionality
      // if (Platform.isIOS) {
      //   var iosPlatform = _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      //   await iosPlatform.setDelegate(_PaymentQueueDelegate());
      // }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Load products from the store
  Future<Map<String, ProductDetails>> loadProducts(List<String> productIds) async {
    try {
      final ProductDetailsResponse response = await _iap.queryProductDetails(productIds.toSet());

      if (response.error != null) {
        throw Exception('Error loading products: ${response.error}');
      }

      if (response.notFoundIDs.isNotEmpty) {
        print('Products not found: ${response.notFoundIDs}');
      }

      // Convert list to map for easy lookup
      final Map<String, ProductDetails> products = {};
      for (var product in response.productDetails) {
        products[product.id] = product;
      }

      return products;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  /// Purchase a product
  Future<void> buyProduct(ProductDetails product) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      throw Exception('Failed to initiate purchase: $e');
    }
  }

  /// Restore previous purchases (required for iOS)
  Future<void> restorePurchases() async {
    try {
      await _iap.restorePurchases();
    } catch (e) {
      throw Exception('Failed to restore purchases: $e');
    }
  }

  /// Complete/acknowledge a purchase
  Future<void> completePurchase(PurchaseDetails purchase) async {
    try {
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    } catch (e) {
      print('Error completing purchase: $e');
    }
  }

  /// Get the purchase stream
  Stream<List<PurchaseDetails>> get purchaseStream {
    return _iap.purchaseStream;
  }

  /// Dispose of resources
  void dispose() {
    _subscription?.cancel();
  }
}

/// iOS payment queue delegate (optional, not used in basic implementation)
// class _PaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
//   @override
//   bool shouldContinueTransaction(SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
//     return true;
//   }
//
//   @override
//   bool shouldShowPriceConsent() {
//     return false;
//   }
// }
