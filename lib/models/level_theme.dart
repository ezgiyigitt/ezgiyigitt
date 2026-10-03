import 'package:flutter/material.dart';

class LevelTheme {
  final String id;
  final String name;

  // Rich, colorful cartoon sky & ground with strong contrast
  final Color skyGradientTop;
  final Color skyGradientBottom;
  final Color groundColor;
  final Color groundAccent;
  final Color hillColor; // Background hill silhouette for cartoon depth

  // Construction piece colors with bold cartoon styling
  final Color brickColor;
  final Color brickMortarColor;
  final Color wallColor;
  final Color wallBorderColor;
  final Color doorColor;
  final Color doorAccentColor;
  final Color windowFrameColor;
  final Color windowGlassColor;
  final Color columnColor;
  final Color columnDetailColor;
  final Color beamColor;
  final Color beamDetailColor;
  final Color roofColor;

  const LevelTheme({
    required this.id,
    required this.name,
    required this.skyGradientTop,
    required this.skyGradientBottom,
    required this.groundColor,
    required this.groundAccent,
    required this.hillColor,
    required this.brickColor,
    required this.brickMortarColor,
    required this.wallColor,
    required this.wallBorderColor,
    required this.doorColor,
    required this.doorAccentColor,
    required this.windowFrameColor,
    required this.windowGlassColor,
    required this.columnColor,
    required this.columnDetailColor,
    required this.beamColor,
    required this.beamDetailColor,
    required this.roofColor,
  });

  // Level 1: Sıcak Kır Evi (Sunny vibrant cartoon countryside - rich contrast)
  static const LevelTheme warmTerracotta = LevelTheme(
    id: 'warm_terracotta',
    name: 'Sıcak Kırsal Ev',
    skyGradientTop: Color(0xFF64B5F6),      // Vivid cartoon sky blue
    skyGradientBottom: Color(0xFFFFE0B2),   // Warm sunset peach horizon
    hillColor: Color(0xFF81C784),           // Rolling green hill
    groundColor: Color(0xFF6D4C41),         // Deep rich stone brown
    groundAccent: Color(0xFF4E342E),
    brickColor: Color(0xFFE64A19),          // Rich terracotta red brick
    brickMortarColor: Color(0xFFFFCCBC),
    wallColor: Color(0xFFFFF9C4),          // Warm cream plaster
    wallBorderColor: Color(0xFFD7CCC8),
    doorColor: Color(0xFF8D4925),          // Warm chestnut wood door
    doorAccentColor: Color(0xFF4E260E),
    windowFrameColor: Color(0xFF5D4037),    // Dark wood frame
    windowGlassColor: Color(0xFF80DEEA),    // Vivid sky-blue reflective glass
    columnColor: Color(0xFFEEEEEE),        // Clean white marble column
    columnDetailColor: Color(0xFFBDBDBD),
    beamColor: Color(0xFFA0522D),          // Sturdy oak beam
    beamDetailColor: Color(0xFF6B371E),
    roofColor: Color(0xFFD32F2F),          // Bold crimson roof tiles
  );

  // Level 2: İskandinav Sahil Kulübesi (Coastal Nordic Blue & Timber)
  static const LevelTheme scandinavianWood = LevelTheme(
    id: 'scandinavian_wood',
    name: 'Kıyı Feneri & Ahşap Ev',
    skyGradientTop: Color(0xFF4FC3F7),
    skyGradientBottom: Color(0xFFE1F5FE),
    hillColor: Color(0xFF4DB6AC),           // Coastal aqua hill
    groundColor: Color(0xFF455A64),         // Rocky coastal stone
    groundAccent: Color(0xFF263238),
    brickColor: Color(0xFFD87D4A),
    brickMortarColor: Color(0xFFFFE0B2),
    wallColor: Color(0xFFECEFF1),
    wallBorderColor: Color(0xFFB0BEC5),
    doorColor: Color(0xFF0277BD),          // Deep Nordic ocean blue
    doorAccentColor: Color(0xFF01579B),
    windowFrameColor: Color(0xFF37474F),
    windowGlassColor: Color(0xFF81D4FA),
    columnColor: Color(0xFFCFD8DC),
    columnDetailColor: Color(0xFF90A4AE),
    beamColor: Color(0xFF8D6E63),
    beamDetailColor: Color(0xFF5D4037),
    roofColor: Color(0xFF1E88E5),          // Vibrant maritime blue roof
  );

  // Level 3: Dağ Gözetleme Kulesi (Alpine Stormy Mountain & Dark Slate)
  static const LevelTheme modernSlate = LevelTheme(
    id: 'modern_slate',
    name: 'Dağ Gözetleme Kulesi',
    skyGradientTop: Color(0xFF5C6BC0),      // Stormy twilight violet/indigo
    skyGradientBottom: Color(0xFFB0BEC5),   // Misty mountain clouds
    hillColor: Color(0xFF78909C),           // Rugged mountain ridge
    groundColor: Color(0xFF37474F),         // Deep basalt foundation
    groundAccent: Color(0xFF212121),
    brickColor: Color(0xFF78909C),
    brickMortarColor: Color(0xFFCFD8DC),
    wallColor: Color(0xFFECEFF1),
    wallBorderColor: Color(0xFF90A4AE),
    doorColor: Color(0xFF263238),
    doorAccentColor: Color(0xFF000000),
    windowFrameColor: Color(0xFF212121),
    windowGlassColor: Color(0xFF80CBC4),
    columnColor: Color(0xFFB0BEC5),
    columnDetailColor: Color(0xFF546E7A),
    beamColor: Color(0xFF455A64),
    beamDetailColor: Color(0xFF263238),
    roofColor: Color(0xFF3949AB),          // Royal dark slate roof
  );

  // Level 4: Gece Şatosu & Saat Kulesi (Midnight Gothic & Royal Gold)
  static const LevelTheme midnightGothic = LevelTheme(
    id: 'midnight_gothic',
    name: 'Gece Saat Kulesi',
    skyGradientTop: Color(0xFF0F172A),      // Derin gece mavisi
    skyGradientBottom: Color(0xFF312E81),   // Alacakaranlık mor/indigo parıltı
    hillColor: Color(0xFF1E1B4B),           // Gece tepe silüeti
    groundColor: Color(0xFF1E293B),         // Granit avlu zemini
    groundAccent: Color(0xFF0F172A),
    brickColor: Color(0xFF475569),          // Gotik taş duvar
    brickMortarColor: Color(0xFF94A3B8),
    wallColor: Color(0xFF334155),          // Şato taşı
    wallBorderColor: Color(0xFF64748B),
    doorColor: Color(0xFF1E293B),          // Dövme demir kapı
    doorAccentColor: Color(0xFFF59E0B),    // Altın sarısı pirinç detaylar
    windowFrameColor: Color(0xFF0F172A),
    windowGlassColor: Color(0xFFFDE047),   // Gece parlayan sıcak vitray sarısı
    columnColor: Color(0xFF64748B),
    columnDetailColor: Color(0xFF475569),
    beamColor: Color(0xFF1E293B),
    beamDetailColor: Color(0xFF0F172A),
    roofColor: Color(0xFF4338CA),          // Asil gece mavisi gotik kule çatısı
  );

  // Level 5: Uzak Doğu Zen Pagodası (Oriental Zen & Imperial Jade)
  static const LevelTheme orientalZen = LevelTheme(
    id: 'oriental_zen',
    name: 'Uzak Doğu Zen Pagodası',
    skyGradientTop: Color(0xFFE11D48),      // Sisli günbatımı kızılı
    skyGradientBottom: Color(0xFFFDE68A),   // Altın sarısı ufuk sisi
    hillColor: Color(0xFF065F46),           // Sisli çam dağı silüeti
    groundColor: Color(0xFF292524),         // Zen bahçesi bazalt taşı
    groundAccent: Color(0xFF1C1917),
    brickColor: Color(0xFFDC2626),          // Vernikli mabet kırmızısı
    brickMortarColor: Color(0xFFFEF3C7),
    wallColor: Color(0xFFFFFBEB),          // Pirinç kağıdı ve sıva
    wallBorderColor: Color(0xFF78350F),
    doorColor: Color(0xFF991B1B),          // Kutsal Torii kırmızısı
    doorAccentColor: Color(0xFFF59E0B),    // İmparatorluk altını
    windowFrameColor: Color(0xFF451A03),    // Sedir ağacı kafes
    windowGlassColor: Color(0xFFFEF08A),   // Işıklı kağıt fener sarısı
    columnColor: Color(0xFFDC2626),        // Vernikli kırmızı sütun
    columnDetailColor: Color(0xFF991B1B),
    beamColor: Color(0xFF451A03),          // Koyu sedir kirişi
    beamDetailColor: Color(0xFF1C1917),
    roofColor: Color(0xFF047857),          // Zümrüt yeşili kiremit çatı
  );
}
