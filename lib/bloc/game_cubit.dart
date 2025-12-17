import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/card_model.dart';
import '../models/card_service.dart';
import 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(const GameState());

  final Random _random = Random();

  Future<void> initializeGame() async {
    emit(state.copyWith(status: GameStatus.loading));

    try {
      final cards = await CardService.loadCards();
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
}
