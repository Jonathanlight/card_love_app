import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'card_model.dart';

class CardService {
  static Future<List<GameCard>> loadCards(Locale locale) async {
    try {
      // Determine which JSON file to load based on locale
      String fileName;
      switch (locale.languageCode) {
        case 'fr':
          fileName = 'assets/data/cards_fr.json';
          break;
        case 'en':
          fileName = 'assets/data/cards_en.json';
          break;
        default:
          // Fallback to French for unsupported languages
          fileName = 'assets/data/cards_fr.json';
      }

      final String jsonString = await rootBundle.loadString(fileName);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> cardsJson = jsonData['cards'] as List<dynamic>;

      return cardsJson
          .map((cardJson) => GameCard.fromJson(cardJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load cards: $e');
    }
  }
}
