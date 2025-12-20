// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Love Quest';

  @override
  String get welcomeTitle => 'Love Quest';

  @override
  String get welcomeSubtitle => 'Questions intimes pour couples';

  @override
  String get startGame => 'Commencer';

  @override
  String get newGame => 'Nouvelle Partie';

  @override
  String get gameFinished => 'Partie Terminée';

  @override
  String get cardsDrawn => 'Cartes tirées';

  @override
  String get favorites => 'Favoris';

  @override
  String get noFavorites => 'Aucun favori';

  @override
  String get noFavoritesDescription =>
      'Appuyez sur l\'étoile pour ajouter une carte à vos favoris';

  @override
  String get shop => 'Boutique';

  @override
  String get unlockMoreQuestions => 'Débloquez plus de questions';

  @override
  String freeCardsAvailable(int count) {
    return '$count cartes déjà disponibles gratuitement';
  }

  @override
  String get packHotName => 'Pack Hot';

  @override
  String get packHotDescription => 'Questions ultra intimes et sensuelles';

  @override
  String get packCoupleName => 'Pack Couple longue durée';

  @override
  String get packCoupleDescription => 'Approfondissez votre relation';

  @override
  String get packTabouName => 'Pack Tabou';

  @override
  String get packTabouDescription =>
      'Questions sur la confiance et l\'infidélité';

  @override
  String get packFunName => 'Pack Fun / Soirée';

  @override
  String get packFunDescription =>
      'Questions légères pour s\'amuser entre amis';

  @override
  String cardsCount(int count) {
    return '$count cartes';
  }

  @override
  String get buy => 'Acheter';

  @override
  String get owned => 'Possédé';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String purchaseSuccess(String packName) {
    return '$packName débloqué!';
  }

  @override
  String get purchaseError => 'Achat échoué. Veuillez réessayer.';

  @override
  String get storeNotAvailable => 'Boutique non disponible';

  @override
  String get alreadyOwned => 'Vous possédez déjà ce pack';

  @override
  String get networkError => 'Erreur réseau. Vérifiez votre connexion.';

  @override
  String restoreSuccess(int count) {
    return '$count packs restaurés';
  }

  @override
  String get restoreNone => 'Aucun achat à restaurer';

  @override
  String get restoreError => 'Erreur lors de la restauration';

  @override
  String get loading => 'Chargement...';

  @override
  String errorLoadingCards(String error) {
    return 'Erreur lors du chargement des cartes: $error';
  }

  @override
  String get noCardsAvailable => 'Aucune carte disponible';

  @override
  String get questionSexy => 'Question Sexy';

  @override
  String get vieDeCouple => 'Vie de Couple';

  @override
  String get infidelite => 'Infidélité';

  @override
  String get questionFun => 'Question Fun';

  @override
  String get swipeInstruction => 'Swipe pour la prochaine carte';

  @override
  String youDrewCards(int count) {
    return 'Vous avez tiré $count cartes';
  }

  @override
  String get endGameTitle => 'Terminer le jeu?';

  @override
  String get endGameMessage => 'Voulez-vous vraiment terminer le jeu?';

  @override
  String get cancel => 'Annuler';

  @override
  String get end => 'Terminer';

  @override
  String get errorOccurred => 'Une erreur est survenue';

  @override
  String get about => 'À propos';

  @override
  String get aboutTitle => 'À propos de Love Quest';

  @override
  String get gameRules => 'Règles du jeu';

  @override
  String get rulesIntro =>
      'Love Quest est un jeu de cartes intime pour couples qui souhaitent approfondir leur relation.';

  @override
  String get rulesHowToPlay => 'Comment jouer';

  @override
  String get rulesStep1 =>
      '1. Installez-vous confortablement avec votre partenaire dans un endroit calme';

  @override
  String get rulesStep2 =>
      '2. Appuyez sur \'Commencer\' pour lancer une partie';

  @override
  String get rulesStep3 =>
      '3. Swipez la carte pour révéler la question suivante';

  @override
  String get rulesStep4 =>
      '4. Répondez à tour de rôle aux questions avec honnêteté et respect';

  @override
  String get rulesStep5 =>
      '5. Utilisez l\'étoile pour sauvegarder vos questions préférées';

  @override
  String get cardTypes => 'Types de cartes';

  @override
  String get cardTypeHot =>
      '🔥 Questions Sexy - Questions intimes et sensuelles pour pimenter votre vie de couple';

  @override
  String get cardTypeCouple =>
      '💙 Vie de Couple - Questions pour approfondir votre connexion émotionnelle';

  @override
  String get cardTypeTabou =>
      '⚫ Infidélité - Questions sur la confiance et les limites de votre relation';

  @override
  String get cardTypeFun =>
      '🎉 Questions Fun - Questions légères et amusantes pour détendre l\'atmosphère';

  @override
  String get tips => 'Conseils';

  @override
  String get tip1 => '• Créez une ambiance détendue et sans jugement';

  @override
  String get tip2 => '• Prenez votre temps pour répondre avec sincérité';

  @override
  String get tip3 => '• Respectez les limites de votre partenaire';

  @override
  String get tip4 =>
      '• Utilisez le jeu comme une opportunité de vous rapprocher';

  @override
  String get developer => 'Développé par';

  @override
  String get developerName => 'Jonathan .K';

  @override
  String get developerTitle => 'Développeur Symfony/Flutter';
}
