import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:card_love/l10n/generated/app_localizations.dart';
import '../bloc/purchase_cubit.dart';
import '../bloc/purchase_state.dart';
import '../bloc/game_cubit.dart';
import '../constants/pack_constants.dart';
import '../models/pack_model.dart';
import '../widgets/pack_card_widget.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.shop),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<PurchaseCubit, PurchaseState>(
        listener: (context, state) {
          // Show error messages
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_getErrorMessage(l10n, state.errorMessage!)),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }

          // Show success message when purchase completes
          if (state.status == AppPurchaseStatus.available &&
              state.purchasingPackId != null) {
            final pack = PackConstants.getPackById(state.purchasingPackId!);
            if (pack != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.purchaseSuccess(_getPackName(l10n, pack.type))),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );

              // Refresh game cards
              context.read<GameCubit>().refreshAvailableCards();
            }
          }
        },
        builder: (context, state) {
          if (state.status == AppPurchaseStatus.loading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    l10n.loading,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            );
          }

          if (state.status == AppPurchaseStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? l10n.storeNotAvailable,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PurchaseCubit>().initialize();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  l10n.unlockMoreQuestions,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                // Free cards info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.white70),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.freeCardsAvailable(25),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Packs grid
                ...PackConstants.allPacks.map((pack) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: PackCardWidget(pack: pack),
                  );
                }).toList(),

                const SizedBox(height: 24),

                // Restore purchases button
                Center(
                  child: OutlinedButton.icon(
                    onPressed: state.isRestoring
                        ? null
                        : () async {
                            await context.read<PurchaseCubit>().restorePurchases();

                            if (context.mounted) {
                              final cubit = context.read<PurchaseCubit>();
                              final restoredCount = cubit.state.ownedPackIds.length;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    restoredCount > 0
                                        ? l10n.restoreSuccess(restoredCount)
                                        : l10n.restoreNone,
                                  ),
                                  backgroundColor:
                                      restoredCount > 0 ? Colors.green : Colors.orange,
                                ),
                              );

                              if (restoredCount > 0) {
                                context.read<GameCubit>().refreshAvailableCards();
                              }
                            }
                          },
                    icon: state.isRestoring
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.refresh),
                    label: Text(l10n.restorePurchases),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getErrorMessage(AppLocalizations l10n, String error) {
    if (error.contains('Store not available')) {
      return l10n.storeNotAvailable;
    } else if (error.contains('Already owned')) {
      return l10n.alreadyOwned;
    } else if (error.contains('network') || error.contains('connection')) {
      return l10n.networkError;
    } else {
      return l10n.purchaseError;
    }
  }

  String _getPackName(AppLocalizations l10n, PackType type) {
    switch (type) {
      case PackType.hot:
        return l10n.packHotName;
      case PackType.couple:
        return l10n.packCoupleName;
      case PackType.tabou:
        return l10n.packTabouName;
      case PackType.fun:
        return l10n.packFunName;
      default:
        return '';
    }
  }
}
