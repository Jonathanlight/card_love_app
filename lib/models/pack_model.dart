import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum PackType {
  hot,
  couple,
  tabou,
  fun,
}

class Pack extends Equatable {
  final String id;
  final PackType type;
  final String nameKey;
  final String descriptionKey;
  final double price;
  final Color color;
  final IconData icon;
  final int cardCount;
  final String imagePath;

  const Pack({
    required this.id,
    required this.type,
    required this.nameKey,
    required this.descriptionKey,
    required this.price,
    required this.color,
    required this.icon,
    required this.cardCount,
    required this.imagePath,
  });

  LinearGradient get gradient {
    switch (type) {
      case PackType.hot:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF6B6B),
            Color(0xFFE53935),
            Color(0xFFC62828),
          ],
        );
      case PackType.couple:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF42A5F5),
            Color(0xFF1E88E5),
            Color(0xFF1565C0),
          ],
        );
      case PackType.tabou:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF424242),
            Color(0xFF212121),
            Color(0xFF000000),
          ],
        );
      case PackType.fun:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFD54F),
            Color(0xFFFFB300),
            Color(0xFFF57C00),
          ],
        );
    }
  }

  @override
  List<Object?> get props => [id, type, nameKey, descriptionKey, price, color, icon, cardCount, imagePath];
}
