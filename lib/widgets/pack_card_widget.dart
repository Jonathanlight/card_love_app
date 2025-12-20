import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:card_love/l10n/generated/app_localizations.dart';
import '../bloc/purchase_cubit.dart';
import '../bloc/purchase_state.dart';
import '../models/pack_model.dart';

class PackCardWidget extends StatelessWidget {
  final Pack pack;

  const PackCardWidget({
    super.key,
    required this.pack,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<PurchaseCubit, PurchaseState>(
      builder: (context, state) {
        final isPurchased = state.isPurchased(pack.id);
        final product = state.getProduct(pack.id);
        final isPurchasing = state.purchasingPackId == pack.id;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: pack.gradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card image preview with type label
                  Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            pack.imagePath,
                            height: 120,
                            width: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback to icon if image not found
                              return Container(
                                height: 120,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  pack.icon,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Type label
                        Text(
                          _getCardTypeName(l10n, pack),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.95),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Icon and name
                  Row(
                    children: [
                      Icon(
                        pack.icon,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _getPackName(l10n, pack),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    _getPackDescription(l10n, pack),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Card count badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.cardsCount(pack.cardCount),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Price and button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      if (!isPurchased && product != null)
                        Text(
                          product.price,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                      // Button
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: _buildActionButton(
                            context,
                            isPurchased,
                            isPurchasing,
                            l10n,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    bool isPurchased,
    bool isPurchasing,
    AppLocalizations l10n,
  ) {
    if (isPurchased) {
      // Owned badge
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: pack.color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.owned,
              style: TextStyle(
                color: pack.color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (isPurchasing) {
      // Loading indicator
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    // Buy button
    return ElevatedButton(
      onPressed: () {
        context.read<PurchaseCubit>().purchasePack(pack.id);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: pack.color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 0,
      ),
      child: Text(
        l10n.buy,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  String _getPackName(AppLocalizations l10n, Pack pack) {
    switch (pack.type) {
      case PackType.hot:
        return l10n.packHotName;
      case PackType.couple:
        return l10n.packCoupleName;
      case PackType.tabou:
        return l10n.packTabouName;
      case PackType.fun:
        return l10n.packFunName;
    }
  }

  String _getPackDescription(AppLocalizations l10n, Pack pack) {
    switch (pack.type) {
      case PackType.hot:
        return l10n.packHotDescription;
      case PackType.couple:
        return l10n.packCoupleDescription;
      case PackType.tabou:
        return l10n.packTabouDescription;
      case PackType.fun:
        return l10n.packFunDescription;
    }
  }

  String _getCardTypeName(AppLocalizations l10n, Pack pack) {
    switch (pack.type) {
      case PackType.hot:
        return l10n.questionSexy;
      case PackType.couple:
        return l10n.vieDeCouple;
      case PackType.tabou:
        return l10n.infidelite;
      case PackType.fun:
        return l10n.questionFun;
    }
  }
}
