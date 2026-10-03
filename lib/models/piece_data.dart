enum PieceType {
  door,    // Giriş Katı (Giriş Kapısı & Taş Duvarlar)
  beam,    // Kat Kirişi (Döşeme & Kat Ayırıcı)
  window,  // Pencereli Yaşam Katı
  balcony, // Çiçekli Balkon Katı
  column,  // Sütunlu Kolon Katı
  arch,    // Antik Taş Kemer Katı
  wall,    // Taş Duvar Katı
  roof,    // Kiremit Çatı (Zirve Kapatıcı)
  dome,    // Görkemli Altın Kubbe (Zirve Tacı)
  gate,    // Ağır Demir Parmaklıklı Şato Kapısı
  roseWindow, // Gotik Gül Vitray Katı
  clock,   // Dev Altın Saat Katı
  crenellation, // Mazgallı Muhafız Siperi
  spire,   // Sivri Gotik Kule Çatısı & Rüzgârgülü
  toriiGate, // Kırmızı Torii Tapınak Girişi
  shojiFloor, // Shoji Kafesli Zen Katı
  pagodaRoof, // Kıvrık Saçaklı Pagoda Çatısı
  zenBelfry, // Bronz Çanlı Tapınak Katı
  sorinSpire, // Altın Sorin Zirvesi & Kutsal Halkalar
}

class PieceDefinition {
  final PieceType type;
  final String name;
  final String displayName;
  final double width; // Metre cinsinden
  final double height; // Metre cinsinden
  final double density; // kg/m^2
  final double friction; // Yüksek sürtünme parçaların kaymasını önler
  final double restitution; // Sekme (tok oturma)
  final double windFactor; // Rüzgâr hassasiyeti

  const PieceDefinition({
    required this.type,
    required this.name,
    required this.displayName,
    required this.width,
    required this.height,
    required this.density,
    required this.friction,
    required this.restitution,
    required this.windFactor,
  });

  // Gerçek İnşaat Sırasına Uygun Katmanlar:
  static const PieceDefinition door = PieceDefinition(
    type: PieceType.door,
    name: 'door',
    displayName: 'Entrance Floor',
    width: 4.4,
    height: 2.0,
    density: 4.5,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.2,
  );

  static const PieceDefinition beam = PieceDefinition(
    type: PieceType.beam,
    name: 'beam',
    displayName: 'Floor Beam',
    width: 4.6,
    height: 0.6,
    density: 5.0,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.2,
  );

  static const PieceDefinition window = PieceDefinition(
    type: PieceType.window,
    name: 'window',
    displayName: 'Living Floor',
    width: 4.4,
    height: 1.8,
    density: 4.0,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.25,
  );

  static const PieceDefinition balcony = PieceDefinition(
    type: PieceType.balcony,
    name: 'balcony',
    displayName: 'Flower Balcony',
    width: 4.4,
    height: 1.6,
    density: 4.0,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.25,
  );

  static const PieceDefinition column = PieceDefinition(
    type: PieceType.column,
    name: 'column',
    displayName: 'Pillar Floor',
    width: 4.4,
    height: 2.0,
    density: 4.5,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.2,
  );

  static const PieceDefinition arch = PieceDefinition(
    type: PieceType.arch,
    name: 'arch',
    displayName: 'Stone Arch Floor',
    width: 4.6,
    height: 2.2,
    density: 4.8,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.2,
  );

  static const PieceDefinition wall = PieceDefinition(
    type: PieceType.wall,
    name: 'wall',
    displayName: 'Stone Wall',
    width: 4.4,
    height: 1.8,
    density: 4.2,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.25,
  );

  static const PieceDefinition roof = PieceDefinition(
    type: PieceType.roof,
    name: 'roof',
    displayName: 'Tiled Roof',
    width: 4.8,
    height: 1.6,
    density: 3.5,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.3,
  );

  static const PieceDefinition dome = PieceDefinition(
    type: PieceType.dome,
    name: 'dome',
    displayName: 'Golden Dome',
    width: 4.8,
    height: 2.0,
    density: 3.8,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.3,
  );

  // Bölüm 4: Görkemli Kraliyet Saat Kulesi Parçaları
  static const PieceDefinition gate = PieceDefinition(
    type: PieceType.gate,
    name: 'gate',
    displayName: 'Iron Castle Gate',
    width: 4.6,
    height: 2.2,
    density: 5.0,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.2,
  );

  static const PieceDefinition roseWindow = PieceDefinition(
    type: PieceType.roseWindow,
    name: 'roseWindow',
    displayName: 'Rose Window Floor',
    width: 4.4,
    height: 2.0,
    density: 4.2,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.22,
  );

  static const PieceDefinition clock = PieceDefinition(
    type: PieceType.clock,
    name: 'clock',
    displayName: 'Golden Clock Floor',
    width: 4.4,
    height: 2.2,
    density: 4.6,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.22,
  );

  static const PieceDefinition crenellation = PieceDefinition(
    type: PieceType.crenellation,
    name: 'crenellation',
    displayName: 'Battlement',
    width: 4.6,
    height: 1.4,
    density: 4.4,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.24,
  );

  static const PieceDefinition spire = PieceDefinition(
    type: PieceType.spire,
    name: 'spire',
    displayName: 'Gothic Spire',
    width: 4.6,
    height: 2.4,
    density: 3.8,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.28,
  );

  // Bölüm 5: Uzak Doğu Zen Pagodası Parçaları
  static const PieceDefinition toriiGate = PieceDefinition(
    type: PieceType.toriiGate,
    name: 'toriiGate',
    displayName: 'Red Torii Gate',
    width: 4.6,
    height: 2.2,
    density: 5.0,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.2,
  );

  static const PieceDefinition shojiFloor = PieceDefinition(
    type: PieceType.shojiFloor,
    name: 'shojiFloor',
    displayName: 'Shoji Zen Floor',
    width: 4.4,
    height: 2.0,
    density: 4.2,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.22,
  );

  static const PieceDefinition pagodaRoof = PieceDefinition(
    type: PieceType.pagodaRoof,
    name: 'pagodaRoof',
    displayName: 'Pagoda Roof',
    width: 4.8,
    height: 1.4,
    density: 4.0,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.26,
  );

  static const PieceDefinition zenBelfry = PieceDefinition(
    type: PieceType.zenBelfry,
    name: 'zenBelfry',
    displayName: 'Bronze Bell Floor',
    width: 4.4,
    height: 2.0,
    density: 4.5,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.22,
  );

  static const PieceDefinition sorinSpire = PieceDefinition(
    type: PieceType.sorinSpire,
    name: 'sorinSpire',
    displayName: 'Golden Sorin Finial',
    width: 4.4,
    height: 2.4,
    density: 3.8,
    friction: 0.98,
    restitution: 0.01,
    windFactor: 0.28,
  );

  static PieceDefinition byType(PieceType type) {
    switch (type) {
      case PieceType.door:
        return door;
      case PieceType.beam:
        return beam;
      case PieceType.window:
        return window;
      case PieceType.balcony:
        return balcony;
      case PieceType.column:
        return column;
      case PieceType.arch:
        return arch;
      case PieceType.wall:
        return wall;
      case PieceType.roof:
        return roof;
      case PieceType.dome:
        return dome;
      case PieceType.gate:
        return gate;
      case PieceType.roseWindow:
        return roseWindow;
      case PieceType.clock:
        return clock;
      case PieceType.crenellation:
        return crenellation;
      case PieceType.spire:
        return spire;
      case PieceType.toriiGate:
        return toriiGate;
      case PieceType.shojiFloor:
        return shojiFloor;
      case PieceType.pagodaRoof:
        return pagodaRoof;
      case PieceType.zenBelfry:
        return zenBelfry;
      case PieceType.sorinSpire:
        return sorinSpire;
    }
  }
}
