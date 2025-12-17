import 'dart:convert';
import 'package:flutter/services.dart';
import 'card_model.dart';

class CardService {
  static Future<List<GameCard>> loadCards() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/cards.json');
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
