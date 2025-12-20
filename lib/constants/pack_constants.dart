import 'package:flutter/material.dart';
import '../models/pack_model.dart';

class PackConstants {
  // Product IDs (same for Android & iOS)
  static const String packHotId = 'pack_hot';
  static const String packCoupleId = 'pack_couple';
  static const String packTabouId = 'pack_tabou';
  static const String packFunId = 'pack_fun';

  static const List<String> allProductIds = [
    packHotId,
    packCoupleId,
    packTabouId,
    packFunId,
  ];

  // Pack definitions
  static final List<Pack> allPacks = [
    const Pack(
      id: packHotId,
      type: PackType.hot,
      nameKey: 'packHotName',
      descriptionKey: 'packHotDescription',
      price: 0.99,
      color: Color(0xFFE53935),
      icon: Icons.whatshot,
      cardCount: 50,
      imagePath: 'assets/images/card_hot.png',
    ),
    const Pack(
      id: packCoupleId,
      type: PackType.couple,
      nameKey: 'packCoupleName',
      descriptionKey: 'packCoupleDescription',
      price: 1.49,
      color: Color(0xFF1E88E5),
      icon: Icons.favorite,
      cardCount: 85,
      imagePath: 'assets/images/card_couple_long_time.png',
    ),
    const Pack(
      id: packTabouId,
      type: PackType.tabou,
      nameKey: 'packTabouName',
      descriptionKey: 'packTabouDescription',
      price: 1.49,
      color: Color(0xFF212121),
      icon: Icons.warning_amber,
      cardCount: 35,
      imagePath: 'assets/images/card_tabou.png',
    ),
    const Pack(
      id: packFunId,
      type: PackType.fun,
      nameKey: 'packFunName',
      descriptionKey: 'packFunDescription',
      price: 0.99,
      color: Color(0xFFFFB300),
      icon: Icons.celebration,
      cardCount: 30,
      imagePath: 'assets/images/card_fun.png',
    ),
  ];

  static Pack? getPackById(String id) {
    try {
      return allPacks.firstWhere((pack) => pack.id == id);
    } catch (e) {
      return null;
    }
  }
}
