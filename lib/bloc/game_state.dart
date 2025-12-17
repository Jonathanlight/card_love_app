import 'package:equatable/equatable.dart';
import '../models/card_model.dart';

enum GameStatus {
  initial,
  loading,
  playing,
  finished,
  error,
}

class GameState extends Equatable {
  final GameStatus status;
  final List<GameCard> availableCards;
  final List<GameCard> drawnCards;
  final GameCard? currentCard;
  final String? errorMessage;

  const GameState({
    this.status = GameStatus.initial,
    this.availableCards = const [],
    this.drawnCards = const [],
    this.currentCard,
    this.errorMessage,
  });

  GameState copyWith({
    GameStatus? status,
    List<GameCard>? availableCards,
    List<GameCard>? drawnCards,
    GameCard? currentCard,
    String? errorMessage,
  }) {
    return GameState(
      status: status ?? this.status,
      availableCards: availableCards ?? this.availableCards,
      drawnCards: drawnCards ?? this.drawnCards,
      currentCard: currentCard ?? this.currentCard,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  int get totalCards => availableCards.length + drawnCards.length;
  int get remainingCards => availableCards.length;
  bool get hasCardsLeft => availableCards.isNotEmpty;

  @override
  List<Object?> get props => [
        status,
        availableCards,
        drawnCards,
        currentCard,
        errorMessage,
      ];
}
