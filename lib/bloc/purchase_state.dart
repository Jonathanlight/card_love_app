import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

enum AppPurchaseStatus {
  initial,
  loading,
  available,
  purchasing,
  error,
}

class PurchaseState extends Equatable {
  final AppPurchaseStatus status;
  final List<String> ownedPackIds;
  final Map<String, ProductDetails> products;
  final bool isRestoring;
  final bool isLegacyUser;
  final String? errorMessage;
  final String? purchasingPackId;

  const PurchaseState({
    this.status = AppPurchaseStatus.initial,
    this.ownedPackIds = const [],
    this.products = const {},
    this.isRestoring = false,
    this.isLegacyUser = false,
    this.errorMessage,
    this.purchasingPackId,
  });

  PurchaseState copyWith({
    AppPurchaseStatus? status,
    List<String>? ownedPackIds,
    Map<String, ProductDetails>? products,
    bool? isRestoring,
    bool? isLegacyUser,
    String? errorMessage,
    String? purchasingPackId,
  }) {
    return PurchaseState(
      status: status ?? this.status,
      ownedPackIds: ownedPackIds ?? this.ownedPackIds,
      products: products ?? this.products,
      isRestoring: isRestoring ?? this.isRestoring,
      isLegacyUser: isLegacyUser ?? this.isLegacyUser,
      errorMessage: errorMessage,
      purchasingPackId: purchasingPackId,
    );
  }

  bool isPurchased(String packId) {
    return isLegacyUser || ownedPackIds.contains(packId);
  }

  ProductDetails? getProduct(String packId) {
    return products[packId];
  }

  @override
  List<Object?> get props => [
        status,
        ownedPackIds,
        products,
        isRestoring,
        isLegacyUser,
        errorMessage,
        purchasingPackId,
      ];
}
