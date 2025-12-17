import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum CardType {
  red,
  blue,
  black,
}

class GameCard extends Equatable {
  final int id;
  final CardType type;
  final String question;
  final String? image;

  const GameCard({
    required this.id,
    required this.type,
    required this.question,
    this.image,
  });

  factory GameCard.fromJson(Map<String, dynamic> json) {
    return GameCard(
      id: json['id'] as int,
      type: _cardTypeFromString(json['type'] as String),
      question: json['question'] as String,
      image: json['image'] as String?,
    );
  }

  static CardType _cardTypeFromString(String type) {
    switch (type.toLowerCase()) {
      case 'red':
        return CardType.red;
      case 'blue':
        return CardType.blue;
      case 'black':
        return CardType.black;
      default:
        return CardType.blue;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'question': question,
      'image': image,
    };
  }

  Color getCardColor() {
    switch (type) {
      case CardType.red:
        return const Color(0xFFE53935);
      case CardType.blue:
        return const Color(0xFF1E88E5);
      case CardType.black:
        return const Color(0xFF212121);
    }
  }

  LinearGradient getCardGradient() {
    switch (type) {
      case CardType.red:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF6B6B),
            Color(0xFFE53935),
            Color(0xFFC62828),
          ],
        );
      case CardType.blue:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF42A5F5),
            Color(0xFF1E88E5),
            Color(0xFF1565C0),
          ],
        );
      case CardType.black:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF424242),
            Color(0xFF212121),
            Color(0xFF000000),
          ],
        );
    }
  }

  String getCardTypeLabel() {
    switch (type) {
      case CardType.red:
        return 'Question Sexy';
      case CardType.blue:
        return 'Vie de Couple';
      case CardType.black:
        return 'Infidélité';
    }
  }

  @override
  List<Object?> get props => [id, type, question, image];
}
