// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Love Quest';

  @override
  String get welcomeTitle => 'Love Quest';

  @override
  String get welcomeSubtitle => 'Intimate questions for couples';

  @override
  String get startGame => 'Start';

  @override
  String get newGame => 'New Game';

  @override
  String get gameFinished => 'Game Finished';

  @override
  String get cardsDrawn => 'Cards drawn';

  @override
  String get favorites => 'Favorites';

  @override
  String get noFavorites => 'No favorites';

  @override
  String get noFavoritesDescription =>
      'Tap the star to add a card to your favorites';

  @override
  String get shop => 'Shop';

  @override
  String get unlockMoreQuestions => 'Unlock more questions';

  @override
  String freeCardsAvailable(int count) {
    return '$count cards already available for free';
  }

  @override
  String get packHotName => 'Hot Pack';

  @override
  String get packHotDescription => 'Ultra intimate and sensual questions';

  @override
  String get packCoupleName => 'Long-term Couple Pack';

  @override
  String get packCoupleDescription => 'Deepen your relationship';

  @override
  String get packTabouName => 'Taboo Pack';

  @override
  String get packTabouDescription => 'Questions about trust and infidelity';

  @override
  String get packFunName => 'Fun / Party Pack';

  @override
  String get packFunDescription =>
      'Light-hearted questions to have fun with friends';

  @override
  String cardsCount(int count) {
    return '$count cards';
  }

  @override
  String get buy => 'Buy';

  @override
  String get owned => 'Owned';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String purchaseSuccess(String packName) {
    return '$packName unlocked!';
  }

  @override
  String get purchaseError => 'Purchase failed. Please try again.';

  @override
  String get storeNotAvailable => 'Store not available';

  @override
  String get alreadyOwned => 'You already own this pack';

  @override
  String get networkError => 'Network error. Check your connection.';

  @override
  String restoreSuccess(int count) {
    return '$count packs restored';
  }

  @override
  String get restoreNone => 'No purchases to restore';

  @override
  String get restoreError => 'Restore error';

  @override
  String get loading => 'Loading...';

  @override
  String errorLoadingCards(String error) {
    return 'Error loading cards: $error';
  }

  @override
  String get noCardsAvailable => 'No cards available';

  @override
  String get questionSexy => 'Sexy Question';

  @override
  String get vieDeCouple => 'Couple Life';

  @override
  String get infidelite => 'Infidelity';

  @override
  String get questionFun => 'Fun Question';

  @override
  String get swipeInstruction => 'Swipe for next card';

  @override
  String youDrewCards(int count) {
    return 'You drew $count cards';
  }

  @override
  String get endGameTitle => 'End game?';

  @override
  String get endGameMessage => 'Do you really want to end the game?';

  @override
  String get cancel => 'Cancel';

  @override
  String get end => 'End';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get about => 'About';

  @override
  String get aboutTitle => 'About Love Quest';

  @override
  String get gameRules => 'Game Rules';

  @override
  String get rulesIntro =>
      'Love Quest is an intimate card game for couples who want to deepen their relationship.';

  @override
  String get rulesHowToPlay => 'How to Play';

  @override
  String get rulesStep1 =>
      '1. Get comfortable with your partner in a quiet place';

  @override
  String get rulesStep2 => '2. Tap \'Start\' to begin a game';

  @override
  String get rulesStep3 => '3. Swipe the card to reveal the next question';

  @override
  String get rulesStep4 =>
      '4. Take turns answering questions with honesty and respect';

  @override
  String get rulesStep5 => '5. Use the star to save your favorite questions';

  @override
  String get cardTypes => 'Card Types';

  @override
  String get cardTypeHot =>
      '🔥 Sexy Questions - Intimate and sensual questions to spice up your relationship';

  @override
  String get cardTypeCouple =>
      '💙 Couple Life - Questions to deepen your emotional connection';

  @override
  String get cardTypeTabou =>
      '⚫ Infidelity - Questions about trust and boundaries in your relationship';

  @override
  String get cardTypeFun =>
      '🎉 Fun Questions - Light and entertaining questions to lighten the mood';

  @override
  String get tips => 'Tips';

  @override
  String get tip1 => '• Create a relaxed and judgment-free atmosphere';

  @override
  String get tip2 => '• Take your time to answer with sincerity';

  @override
  String get tip3 => '• Respect your partner\'s boundaries';

  @override
  String get tip4 => '• Use the game as an opportunity to get closer';

  @override
  String get developer => 'Developed by';

  @override
  String get developerName => 'Jonathan .K';

  @override
  String get developerTitle => 'Symfony/Flutter Developer';
}
