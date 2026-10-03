import 'package:flutter/material.dart';
import 'level_theme.dart';
import 'piece_data.dart';

enum WindDirection {
  left(-1.0),
  right(1.0),
  none(0.0);

  final double sign;
  const WindDirection(this.sign);
}

class WindConfig {
  final double baseStrength;
  final WindDirection direction;
  final double gustMultiplier;
  final double gustPeriodSeconds;
  final String description;

  const WindConfig({
    required this.baseStrength,
    required this.direction,
    this.gustMultiplier = 1.0,
    this.gustPeriodSeconds = 8.0,
    required this.description,
  });

  // Level 1: Zero wind - completely calm, relaxing start
  static const WindConfig calmNoWind = WindConfig(
    baseStrength: 0.0,
    direction: WindDirection.none,
    description: 'Calm (No Wind)',
  );

  // Level 2: Gentle coastal breeze (light, easy, no disruptive drift)
  static const WindConfig level2Wind = WindConfig(
    baseStrength: 2.5,
    direction: WindDirection.right,
    gustMultiplier: 1.3,
    gustPeriodSeconds: 7.0,
    description: 'Gentle Sea Breeze',
  );

  // Level 3: Moderate mountain breeze
  static const WindConfig level3Storm = WindConfig(
    baseStrength: 5.5,
    direction: WindDirection.left,
    gustMultiplier: 1.5,
    gustPeriodSeconds: 5.5,
    description: 'Light Mountain Wind',
  );

  // Level 4: Gentle mystical night breeze
  static const WindConfig level4NightWind = WindConfig(
    baseStrength: 3.8,
    direction: WindDirection.right,
    gustMultiplier: 1.4,
    gustPeriodSeconds: 6.0,
    description: 'Twilight Breeze',
  );

  // Level 5: Oriental mountain mist breeze
  static const WindConfig level5MountainWind = WindConfig(
    baseStrength: 4.2,
    direction: WindDirection.left,
    gustMultiplier: 1.3,
    gustPeriodSeconds: 6.5,
    description: 'Misty Valley Gale',
  );
}

class BlueprintItem {
  final PieceType type;
  final double xOffset; // Relative normalized X (-0.5 to 0.5)
  final double yBottom; // Relative normalized Y from ground (0.0 to 1.0)
  final double width;
  final double height;

  const BlueprintItem({
    required this.type,
    required this.xOffset,
    required this.yBottom,
    required this.width,
    required this.height,
  });
}

class LevelDefinition {
  final int id;
  final String title;
  final String subtitle;
  final String story;
  final IconData icon;
  final double targetHeight; // in meters
  final int maxFallenPieces;
  final LevelTheme theme;
  final WindConfig wind;
  final List<PieceType> requiredPieces; // Exact architectural recipe
  final List<BlueprintItem> blueprint;

  const LevelDefinition({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.story,
    required this.icon,
    required this.targetHeight,
    this.maxFallenPieces = 3,
    required this.theme,
    required this.wind,
    required this.requiredPieces,
    required this.blueprint,
  });

  // Level 1: Sevimli Kır Evi (5 Katmanlı Gerçek İnşaat Sırası)
  static const LevelDefinition level1 = LevelDefinition(
    id: 1,
    title: 'Level 1',
    subtitle: 'Cosy Country House',
    story: 'Build a cosy country house floor by floor in a quiet valley. Start with the entrance, lay the floor beam, then set the living floor and cap it with the roof.',
    icon: Icons.cottage_rounded,
    targetHeight: 6.6,
    maxFallenPieces: 3,
    theme: LevelTheme.warmTerracotta,
    wind: WindConfig.calmNoWind,
    requiredPieces: [
      PieceType.door,   // 1. Zemin Giriş Katı
      PieceType.beam,   // 2. 1. Kat Döşeme Kirişi
      PieceType.window, // 3. Pencereli Yaşam Katı
      PieceType.beam,   // 4. Çatı Destek Kirişi
      PieceType.roof,   // 5. Kiremit Çatı (Zirve!)
    ],
    blueprint: [
      BlueprintItem(type: PieceType.door, xOffset: 0.0, yBottom: 0.0, width: 0.88, height: 0.28),
      BlueprintItem(type: PieceType.beam, xOffset: 0.0, yBottom: 0.29, width: 0.92, height: 0.08),
      BlueprintItem(type: PieceType.window, xOffset: 0.0, yBottom: 0.38, width: 0.88, height: 0.26),
      BlueprintItem(type: PieceType.beam, xOffset: 0.0, yBottom: 0.65, width: 0.92, height: 0.08),
      BlueprintItem(type: PieceType.roof, xOffset: 0.0, yBottom: 0.74, width: 0.96, height: 0.24),
    ],
  );

  // Level 2: Kıyı Çiçekli Köşk (7 Katmanlı Sahil Villası)
  static const LevelDefinition level2 = LevelDefinition(
    id: 2,
    title: 'Level 2',
    subtitle: 'Seaside Flower Villa',
    story: 'Raise a flower-terraced villa on the bright blue coast. A gentle breeze blows in off the sea, so set each balcony and window squarely.',
    icon: Icons.deck_rounded,
    targetHeight: 8.8,
    maxFallenPieces: 3,
    theme: LevelTheme.scandinavianWood,
    wind: WindConfig.level2Wind,
    requiredPieces: [
      PieceType.door,    // 1. Giriş Katı
      PieceType.beam,    // 2. 1. Kat Kirişi
      PieceType.window,  // 3. Köşk Pencereli Katı
      PieceType.beam,    // 4. Teras Kirişi
      PieceType.balcony, // 5. Çiçekli Balkon Katı
      PieceType.beam,    // 6. Çatı Taban Kirişi
      PieceType.roof,    // 7. Kiremit Çatı
    ],
    blueprint: [
      BlueprintItem(type: PieceType.door, xOffset: 0.0, yBottom: 0.0, width: 0.86, height: 0.22),
      BlueprintItem(type: PieceType.beam, xOffset: 0.0, yBottom: 0.23, width: 0.90, height: 0.06),
      BlueprintItem(type: PieceType.window, xOffset: 0.0, yBottom: 0.30, width: 0.86, height: 0.20),
      BlueprintItem(type: PieceType.beam, xOffset: 0.0, yBottom: 0.51, width: 0.90, height: 0.06),
      BlueprintItem(type: PieceType.balcony, xOffset: 0.0, yBottom: 0.58, width: 0.86, height: 0.18),
      BlueprintItem(type: PieceType.beam, xOffset: 0.0, yBottom: 0.77, width: 0.90, height: 0.06),
      BlueprintItem(type: PieceType.roof, xOffset: 0.0, yBottom: 0.84, width: 0.94, height: 0.15),
    ],
  );

  // Level 3: Dağ Kraliyet Kalesi (7 Katmanlı Antik Kale & Kubbe)
  static const LevelDefinition level3 = LevelDefinition(
    id: 3,
    title: 'Level 3',
    subtitle: 'Royal Mountain Castle',
    story: 'Build a castle that stands up to the wind on a sheer cliff. Begin with the stone arch, raise the pillared hall and the lookout balcony, and crown it with the golden dome.',
    icon: Icons.castle_rounded,
    targetHeight: 9.6,
    maxFallenPieces: 3,
    theme: LevelTheme.modernSlate,
    wind: WindConfig.level3Storm,
    requiredPieces: [
      PieceType.arch,    // 1. Antik Taş Kemer Katı
      PieceType.beam,    // 2. Orta Kat Kirişi
      PieceType.column,  // 3. Sütunlu Kolon Katı
      PieceType.beam,    // 4. Kule Kirişi
      PieceType.balcony, // 5. Seyir Balkonu Katı
      PieceType.beam,    // 6. Kubbe Kaidesi Kirişi
      PieceType.dome,    // 7. Görkemli Altın Kubbe
    ],
    blueprint: [
      BlueprintItem(type: PieceType.arch, xOffset: 0.0, yBottom: 0.0, width: 0.88, height: 0.22),
      BlueprintItem(type: PieceType.beam, xOffset: 0.0, yBottom: 0.23, width: 0.90, height: 0.06),
      BlueprintItem(type: PieceType.column, xOffset: 0.0, yBottom: 0.30, width: 0.86, height: 0.20),
      BlueprintItem(type: PieceType.beam, xOffset: 0.0, yBottom: 0.51, width: 0.90, height: 0.06),
      BlueprintItem(type: PieceType.balcony, xOffset: 0.0, yBottom: 0.58, width: 0.86, height: 0.18),
      BlueprintItem(type: PieceType.beam, xOffset: 0.0, yBottom: 0.77, width: 0.90, height: 0.06),
      BlueprintItem(type: PieceType.dome, xOffset: 0.0, yBottom: 0.84, width: 0.94, height: 0.16),
    ],
  );

  // Level 4: Görkemli Kraliyet Saat Kulesi (8 Katmanlı Gotik Mimari)
  static const LevelDefinition level4 = LevelDefinition(
    id: 4,
    title: 'Level 4',
    subtitle: 'Royal Clock Tower',
    story: 'Build the city\'s grandest clock tower under a starry sky. Start with the heavy iron gate, raise the rose window, the great golden clock and the battlements, then reach for the sky with a gothic spire.',
    icon: Icons.access_time_filled_rounded,
    targetHeight: 11.2,
    maxFallenPieces: 3,
    theme: LevelTheme.midnightGothic,
    wind: WindConfig.level4NightWind,
    requiredPieces: [
      PieceType.gate,         // 1. Zemin Şato Kapısı (Ağır Demir Parmaklıklı)
      PieceType.beam,         // 2. Taş Kat Kirişi
      PieceType.roseWindow,   // 3. Gotik Gül Vitray Katı
      PieceType.beam,         // 4. Saat Kaidesi Kirişi
      PieceType.clock,        // 5. Görkemli Altın Saat Katı
      PieceType.beam,         // 6. Mazgal Altı Kirişi
      PieceType.crenellation, // 7. Mazgallı Muhafız Siperi & Meşaleler
      PieceType.spire,        // 8. Sivri Gotik Kule Çatısı (Zirve!)
    ],
    blueprint: [
      BlueprintItem(type: PieceType.gate, xOffset: 0.0, yBottom: 0.0, width: 0.88, height: 0.19),
      BlueprintItem(type: PieceType.beam, xOffset: 0.0, yBottom: 0.20, width: 0.90, height: 0.05),
      BlueprintItem(type: PieceType.roseWindow, xOffset: 0.0, yBottom: 0.26, width: 0.84, height: 0.17),
      BlueprintItem(type: PieceType.beam, xOffset: 0.0, yBottom: 0.44, width: 0.88, height: 0.05),
      BlueprintItem(type: PieceType.clock, xOffset: 0.0, yBottom: 0.50, width: 0.84, height: 0.18),
      BlueprintItem(type: PieceType.beam, xOffset: 0.0, yBottom: 0.69, width: 0.88, height: 0.05),
      BlueprintItem(type: PieceType.crenellation, xOffset: 0.0, yBottom: 0.75, width: 0.90, height: 0.11),
      BlueprintItem(type: PieceType.spire, xOffset: 0.0, yBottom: 0.87, width: 0.92, height: 0.19),
    ],
  );

  // Level 5: Uzak Doğu Zen Pagodası (8 Katmanlı Geleneksel Mimari)
  static const LevelDefinition level5 = LevelDefinition(
    id: 5,
    title: 'Level 5',
    subtitle: 'Far East Zen Pagoda',
    story: 'Build a sacred Zen pagoda below misty pine mountains at sunset. Enter through the red Torii gate, stack the Shoji rooms and curved green roofs, and balance it all with the golden Sorin finial.',
    icon: Icons.temple_buddhist_rounded,
    targetHeight: 12.0,
    maxFallenPieces: 3,
    theme: LevelTheme.orientalZen,
    wind: WindConfig.level5MountainWind,
    requiredPieces: [
      PieceType.toriiGate,  // 1. Zemin Kırmızı Torii Kapısı
      PieceType.beam,       // 2. Kırmızı Sedir Kirişi
      PieceType.shojiFloor, // 3. Shoji Kafesli Zen Katı
      PieceType.pagodaRoof, // 4. 1. Kat Kıvrık Pagoda Çatısı
      PieceType.zenBelfry,  // 5. Bronz Çanlı Tapınak Katı
      PieceType.beam,       // 6. Üst Kat Kirişi
      PieceType.pagodaRoof, // 7. 2. Kat Pagoda Çatısı
      PieceType.sorinSpire, // 8. Altın Sorin Tapınak Zirvesi (Taç!)
    ],
    blueprint: [
      BlueprintItem(type: PieceType.toriiGate, xOffset: 0.0, yBottom: 0.0, width: 0.88, height: 0.18),
      BlueprintItem(type: PieceType.beam, xOffset: 0.0, yBottom: 0.19, width: 0.90, height: 0.05),
      BlueprintItem(type: PieceType.shojiFloor, xOffset: 0.0, yBottom: 0.25, width: 0.84, height: 0.16),
      BlueprintItem(type: PieceType.pagodaRoof, xOffset: 0.0, yBottom: 0.42, width: 0.94, height: 0.12),
      BlueprintItem(type: PieceType.zenBelfry, xOffset: 0.0, yBottom: 0.55, width: 0.84, height: 0.16),
      BlueprintItem(type: PieceType.beam, xOffset: 0.0, yBottom: 0.72, width: 0.88, height: 0.05),
      BlueprintItem(type: PieceType.pagodaRoof, xOffset: 0.0, yBottom: 0.78, width: 0.94, height: 0.12),
      BlueprintItem(type: PieceType.sorinSpire, xOffset: 0.0, yBottom: 0.91, width: 0.86, height: 0.19),
    ],
  );

  static const List<LevelDefinition> allLevels = [level1, level2, level3, level4, level5];

  static LevelDefinition getLevel(int levelId) {
    if (levelId <= 1) return level1;
    if (levelId == 2) return level2;
    if (levelId == 3) return level3;
    if (levelId == 4) return level4;
    return level5;
  }
}
