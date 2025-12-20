import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/card_model.dart';
import '../models/card_service.dart';
import 'game_state.dart';
import 'purchase_cubit.dart';
import 'purchase_state.dart';

class GameCubit extends Cubit<GameState> {
  final PurchaseCubit? purchaseCubit;
  final Locale locale;
  StreamSubscription<PurchaseState>? _purchaseSubscription;
  List<String> _lastKnownOwnedPacks = [];

  GameCubit({this.purchaseCubit, required this.locale}) : super(const GameState()) {
    // Listen to purchase changes
    _purchaseSubscription = purchaseCubit?.stream.listen((purchaseState) {
      // Only refresh if owned packs actually changed
      if (purchaseState.ownedPackIds.length != _lastKnownOwnedPacks.length ||
          !purchaseState.ownedPackIds.every((id) => _lastKnownOwnedPacks.contains(id))) {
        print('🎁 Purchase detected! Old: $_lastKnownOwnedPacks, New: ${purchaseState.ownedPackIds}');
        _lastKnownOwnedPacks = List.from(purchaseState.ownedPackIds);

        // Refresh available cards when packs change
        if (state.status == GameStatus.playing || state.status == GameStatus.initial) {
          print('🔄 Triggering card refresh (status: ${state.status})');
          refreshAvailableCards();
        } else {
          print('⏸️ Not refreshing (status: ${state.status})');
        }
      }
    });
  }

  final Random _random = Random();
  static const String _favoritesKey = 'favorite_cards';

  Future<void> initializeGame() async {
    emit(state.copyWith(status: GameStatus.loading));

    try {
      // Load all cards from JSON based on locale
      final allCards = await CardService.loadCards(locale);

      // Filter cards based on purchased packs
      final accessibleCards = _filterAccessibleCards(allCards);

      // Shuffle cards for good randomization
      accessibleCards.shuffle(_random);

      // Initialize tracking of owned packs
      _lastKnownOwnedPacks = List.from(purchaseCubit?.state.ownedPackIds ?? []);

      await _loadFavorites(accessibleCards);
      emit(state.copyWith(
        status: GameStatus.initial,
        availableCards: accessibleCards,
        drawnCards: [],
        currentCard: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GameStatus.error,
        errorMessage: 'Erreur lors du chargement des cartes: $e',
      ));
    }
  }

  /// Filter cards based on user's purchases and access rights
  List<GameCard> _filterAccessibleCards(List<GameCard> allCards) {
    if (purchaseCubit == null) {
      // No purchase system, return all cards
      return allCards;
    }

    // Get unlocked pack IDs (includes legacy user check)
    final unlockedPacks = purchaseCubit!.getUnlockedPackIds();

    // Filter cards
    return allCards.where((card) {
      // Free cards are always accessible
      if (card.isFree) return true;

      // Cards from unlocked packs are accessible
      if (card.packId != null && unlockedPacks.contains(card.packId)) {
        return true;
      }

      return false;
    }).toList();
  }

  /// Refresh available cards (called after purchase)
  Future<void> refreshAvailableCards() async {
    try {
      // Reload all cards
      final allCards = await CardService.loadCards(locale);

      // Filter based on new purchases
      final accessibleCards = _filterAccessibleCards(allCards);

      // Merge with currently drawn cards
      final drawnIds = state.drawnCards.map((c) => c.id).toSet();
      final newAvailable = accessibleCards.where((c) => !drawnIds.contains(c.id)).toList();

      // Shuffle the cards for better randomization
      newAvailable.shuffle(_random);

      print('🔄 Refreshing cards: ${newAvailable.length} available, ${drawnIds.length} drawn');

      emit(state.copyWith(
        availableCards: newAvailable,
      ));
    } catch (e) {
      // Silent error, don't interrupt game
      print('Error refreshing cards: $e');
    }
  }

  void startGame() {
    if (state.availableCards.isEmpty) {
      emit(state.copyWith(
        status: GameStatus.error,
        errorMessage: 'Aucune carte disponible',
      ));
      return;
    }

    emit(state.copyWith(status: GameStatus.playing));
    drawCard();
  }

  void drawCard() {
    if (!state.hasCardsLeft) {
      emit(state.copyWith(
        status: GameStatus.finished,
        currentCard: null,
      ));
      return;
    }

    // Smart random: avoid drawing same type as previous card
    GameCard drawnCard;
    int randomIndex;

    // Try to pick a different type than the last card
    if (state.currentCard != null && state.availableCards.length > 1) {
      // Get cards of different types
      final differentTypeCards = state.availableCards
          .asMap()
          .entries
          .where((entry) => entry.value.type != state.currentCard!.type)
          .toList();

      if (differentTypeCards.isNotEmpty) {
        // Pick randomly from different types (80% chance)
        if (_random.nextDouble() < 0.8) {
          final randomEntry = differentTypeCards[_random.nextInt(differentTypeCards.length)];
          randomIndex = randomEntry.key;
          drawnCard = randomEntry.value;
        } else {
          // 20% chance to still allow same type
          randomIndex = _random.nextInt(state.availableCards.length);
          drawnCard = state.availableCards[randomIndex];
        }
      } else {
        // All remaining cards are same type, just pick one
        randomIndex = _random.nextInt(state.availableCards.length);
        drawnCard = state.availableCards[randomIndex];
      }
    } else {
      // First card or only one card left, pick randomly
      randomIndex = _random.nextInt(state.availableCards.length);
      drawnCard = state.availableCards[randomIndex];
    }

    // Remove the card from available and add to drawn
    final newAvailableCards = List<GameCard>.from(state.availableCards)
      ..removeAt(randomIndex);
    final newDrawnCards = List<GameCard>.from(state.drawnCards)..add(drawnCard);

    emit(state.copyWith(
      availableCards: newAvailableCards,
      drawnCards: newDrawnCards,
      currentCard: drawnCard,
      status: GameStatus.playing,
    ));
  }

  void newGame() {
    // Reset the game by moving all drawn cards back to available
    final allCards = [...state.availableCards, ...state.drawnCards];

    // Shuffle for new game randomization
    allCards.shuffle(_random);

    emit(state.copyWith(
      status: GameStatus.initial,
      availableCards: allCards,
      drawnCards: [],
      currentCard: null,
    ));
  }

  void endGame() {
    emit(state.copyWith(
      status: GameStatus.finished,
      currentCard: null,
    ));
  }

  Future<void> _loadFavorites(List<GameCard> allCards) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];

      final favoriteIds = favoritesJson.map((json) {
        final data = jsonDecode(json) as Map<String, dynamic>;
        return data['id'] as int;
      }).toList();

      final favoriteCards = allCards
          .where((card) => favoriteIds.contains(card.id))
          .toList();

      emit(state.copyWith(favoriteCards: favoriteCards));
    } catch (e) {
      // Si erreur de chargement, on continue avec une liste vide
      emit(state.copyWith(favoriteCards: []));
    }
  }

  Future<void> toggleFavorite(GameCard card) async {
    final favorites = List<GameCard>.from(state.favoriteCards);
    final isFavorite = favorites.any((c) => c.id == card.id);

    if (isFavorite) {
      favorites.removeWhere((c) => c.id == card.id);
    } else {
      favorites.add(card);
    }

    emit(state.copyWith(favoriteCards: favorites));
    await _saveFavorites(favorites);
  }

  bool isFavorite(GameCard card) {
    return state.favoriteCards.any((c) => c.id == card.id);
  }

  Future<void> _saveFavorites(List<GameCard> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = favorites
          .map((card) => jsonEncode(card.toJson()))
          .toList();
      await prefs.setStringList(_favoritesKey, favoritesJson);
    } catch (e) {
      // Erreur silencieuse pour ne pas interrompre l'expérience
    }
  }

  @override
  Future<void> close() {
    _purchaseSubscription?.cancel();
    return super.close();
  }
}
