import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Love Quest'**
  String get appTitle;

  /// Welcome screen title
  ///
  /// In en, this message translates to:
  /// **'Love Quest'**
  String get welcomeTitle;

  /// Welcome screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Intimate questions for couples'**
  String get welcomeSubtitle;

  /// Start game button
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startGame;

  /// New game button
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get newGame;

  /// Game finished title
  ///
  /// In en, this message translates to:
  /// **'Game Finished'**
  String get gameFinished;

  /// Cards drawn label
  ///
  /// In en, this message translates to:
  /// **'Cards drawn'**
  String get cardsDrawn;

  /// Favorites title
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No favorites message
  ///
  /// In en, this message translates to:
  /// **'No favorites'**
  String get noFavorites;

  /// No favorites description
  ///
  /// In en, this message translates to:
  /// **'Tap the star to add a card to your favorites'**
  String get noFavoritesDescription;

  /// Shop title
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shop;

  /// Shop header
  ///
  /// In en, this message translates to:
  /// **'Unlock more questions'**
  String get unlockMoreQuestions;

  /// Free cards available message
  ///
  /// In en, this message translates to:
  /// **'{count} cards already available for free'**
  String freeCardsAvailable(int count);

  /// Hot pack name
  ///
  /// In en, this message translates to:
  /// **'Hot Pack'**
  String get packHotName;

  /// Hot pack description
  ///
  /// In en, this message translates to:
  /// **'Ultra intimate and sensual questions'**
  String get packHotDescription;

  /// Couple pack name
  ///
  /// In en, this message translates to:
  /// **'Long-term Couple Pack'**
  String get packCoupleName;

  /// Couple pack description
  ///
  /// In en, this message translates to:
  /// **'Deepen your relationship'**
  String get packCoupleDescription;

  /// Taboo pack name
  ///
  /// In en, this message translates to:
  /// **'Taboo Pack'**
  String get packTabouName;

  /// Taboo pack description
  ///
  /// In en, this message translates to:
  /// **'Questions about trust and infidelity'**
  String get packTabouDescription;

  /// Fun pack name
  ///
  /// In en, this message translates to:
  /// **'Fun / Party Pack'**
  String get packFunName;

  /// Fun pack description
  ///
  /// In en, this message translates to:
  /// **'Light-hearted questions to have fun with friends'**
  String get packFunDescription;

  /// Cards count
  ///
  /// In en, this message translates to:
  /// **'{count} cards'**
  String cardsCount(int count);

  /// Buy button
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// Owned badge
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get owned;

  /// Restore purchases button
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// Purchase success message
  ///
  /// In en, this message translates to:
  /// **'{packName} unlocked!'**
  String purchaseSuccess(String packName);

  /// Purchase error message
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get purchaseError;

  /// Store not available error
  ///
  /// In en, this message translates to:
  /// **'Store not available'**
  String get storeNotAvailable;

  /// Already owned message
  ///
  /// In en, this message translates to:
  /// **'You already own this pack'**
  String get alreadyOwned;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your connection.'**
  String get networkError;

  /// Restore success message
  ///
  /// In en, this message translates to:
  /// **'{count} packs restored'**
  String restoreSuccess(int count);

  /// No purchases to restore message
  ///
  /// In en, this message translates to:
  /// **'No purchases to restore'**
  String get restoreNone;

  /// Restore error message
  ///
  /// In en, this message translates to:
  /// **'Restore error'**
  String get restoreError;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error loading cards
  ///
  /// In en, this message translates to:
  /// **'Error loading cards: {error}'**
  String errorLoadingCards(String error);

  /// No cards available error
  ///
  /// In en, this message translates to:
  /// **'No cards available'**
  String get noCardsAvailable;

  /// Sexy question label
  ///
  /// In en, this message translates to:
  /// **'Sexy Question'**
  String get questionSexy;

  /// Couple life label
  ///
  /// In en, this message translates to:
  /// **'Couple Life'**
  String get vieDeCouple;

  /// Infidelity label
  ///
  /// In en, this message translates to:
  /// **'Infidelity'**
  String get infidelite;

  /// Fun question label
  ///
  /// In en, this message translates to:
  /// **'Fun Question'**
  String get questionFun;

  /// Swipe instruction
  ///
  /// In en, this message translates to:
  /// **'Swipe for next card'**
  String get swipeInstruction;

  /// You drew cards message
  ///
  /// In en, this message translates to:
  /// **'You drew {count} cards'**
  String youDrewCards(int count);

  /// End game dialog title
  ///
  /// In en, this message translates to:
  /// **'End game?'**
  String get endGameTitle;

  /// End game dialog message
  ///
  /// In en, this message translates to:
  /// **'Do you really want to end the game?'**
  String get endGameMessage;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// End button
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// About button
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// About screen title
  ///
  /// In en, this message translates to:
  /// **'About Love Quest'**
  String get aboutTitle;

  /// Game rules section title
  ///
  /// In en, this message translates to:
  /// **'Game Rules'**
  String get gameRules;

  /// Rules introduction
  ///
  /// In en, this message translates to:
  /// **'Love Quest is an intimate card game for couples who want to deepen their relationship.'**
  String get rulesIntro;

  /// How to play section
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get rulesHowToPlay;

  /// Rule step 1
  ///
  /// In en, this message translates to:
  /// **'1. Get comfortable with your partner in a quiet place'**
  String get rulesStep1;

  /// Rule step 2
  ///
  /// In en, this message translates to:
  /// **'2. Tap \'Start\' to begin a game'**
  String get rulesStep2;

  /// Rule step 3
  ///
  /// In en, this message translates to:
  /// **'3. Swipe the card to reveal the next question'**
  String get rulesStep3;

  /// Rule step 4
  ///
  /// In en, this message translates to:
  /// **'4. Take turns answering questions with honesty and respect'**
  String get rulesStep4;

  /// Rule step 5
  ///
  /// In en, this message translates to:
  /// **'5. Use the star to save your favorite questions'**
  String get rulesStep5;

  /// Card types section
  ///
  /// In en, this message translates to:
  /// **'Card Types'**
  String get cardTypes;

  /// Hot card type description
  ///
  /// In en, this message translates to:
  /// **'🔥 Sexy Questions - Intimate and sensual questions to spice up your relationship'**
  String get cardTypeHot;

  /// Couple card type description
  ///
  /// In en, this message translates to:
  /// **'💙 Couple Life - Questions to deepen your emotional connection'**
  String get cardTypeCouple;

  /// Tabou card type description
  ///
  /// In en, this message translates to:
  /// **'⚫ Infidelity - Questions about trust and boundaries in your relationship'**
  String get cardTypeTabou;

  /// Fun card type description
  ///
  /// In en, this message translates to:
  /// **'🎉 Fun Questions - Light and entertaining questions to lighten the mood'**
  String get cardTypeFun;

  /// Tips section
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// Tip 1
  ///
  /// In en, this message translates to:
  /// **'• Create a relaxed and judgment-free atmosphere'**
  String get tip1;

  /// Tip 2
  ///
  /// In en, this message translates to:
  /// **'• Take your time to answer with sincerity'**
  String get tip2;

  /// Tip 3
  ///
  /// In en, this message translates to:
  /// **'• Respect your partner\'s boundaries'**
  String get tip3;

  /// Tip 4
  ///
  /// In en, this message translates to:
  /// **'• Use the game as an opportunity to get closer'**
  String get tip4;

  /// Developer label
  ///
  /// In en, this message translates to:
  /// **'Developed by'**
  String get developer;

  /// Developer name
  ///
  /// In en, this message translates to:
  /// **'Jonathan .K'**
  String get developerName;

  /// Developer title
  ///
  /// In en, this message translates to:
  /// **'Symfony/Flutter Developer'**
  String get developerTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
