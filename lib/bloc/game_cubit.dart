import 'dart:convert';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/card_model.dart';
import '../models/card_service.dart';
import 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(const GameState());

  final Random _random = Random();
  static const String _favoritesKey = 'favorite_cards';

  Future<void> initializeGame() async {
    emit(state.copyWith(status: GameStatus.loading));

    try {
      final cards = await CardService.loadCards();
      await _loadFavorites(cards);
      emit(state.copyWith(
        status: GameStatus.initial,
        availableCards: cards,
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

    // Pick a random card from available cards
    final randomIndex = _random.nextInt(state.availableCards.length);
    final drawnCard = state.availableCards[randomIndex];

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
}
