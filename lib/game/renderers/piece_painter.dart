import 'package:flutter/material.dart';
import '../../models/level_theme.dart';
import '../../models/piece_data.dart';

class PiecePainter {
  /// Draw a piece within the given bounding rectangle [rect] onto [canvas].
  static void drawPiece({
    required Canvas canvas,
    required Rect rect,
    required PieceType type,
    required LevelTheme theme,
    double opacity = 1.0,
  }) {
    canvas.save();
    switch (type) {
      case PieceType.door:
        _drawDoor(canvas, rect, theme, opacity);
        break;
      case PieceType.column:
        _drawColumn(canvas, rect, theme, opacity);
        break;
      case PieceType.beam:
        _drawBeam(canvas, rect, theme, opacity);
        break;
      case PieceType.window:
        _drawWindow(canvas, rect, theme, opacity);
        break;
      case PieceType.wall:
        _drawWall(canvas, rect, theme, opacity);
        break;
      case PieceType.roof:
        _drawRoof(canvas, rect, theme, opacity);
        break;
      case PieceType.balcony:
        _drawBalcony(canvas, rect, theme, opacity);
        break;
      case PieceType.arch:
        _drawArch(canvas, rect, theme, opacity);
        break;
      case PieceType.dome:
        _drawDome(canvas, rect, theme, opacity);
        break;
      case PieceType.gate:
        _drawGate(canvas, rect, theme, opacity);
        break;
      case PieceType.roseWindow:
        _drawRoseWindow(canvas, rect, theme, opacity);
        break;
      case PieceType.clock:
        _drawClock(canvas, rect, theme, opacity);
        break;
      case PieceType.crenellation:
        _drawCrenellation(canvas, rect, theme, opacity);
        break;
      case PieceType.spire:
        _drawSpire(canvas, rect, theme, opacity);
        break;
      case PieceType.toriiGate:
        _drawToriiGate(canvas, rect, theme, opacity);
        break;
      case PieceType.shojiFloor:
        _drawShojiFloor(canvas, rect, theme, opacity);
        break;
      case PieceType.pagodaRoof:
        _drawPagodaRoof(canvas, rect, theme, opacity);
        break;
      case PieceType.zenBelfry:
        _drawZenBelfry(canvas, rect, theme, opacity);
        break;
      case PieceType.sorinSpire:
        _drawSorinSpire(canvas, rect, theme, opacity);
        break;
    }
    canvas.restore();
  }

  // 1. Giriş Katı (Giriş Kapısı, Taş Köşe Taşları ve Fenerler)
  static void _drawDoor(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4.0));

    // Outer Stone Facade Wall
    final wallPaint = Paint()
      ..color = theme.wallColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, wallPaint);

    // Stone Corner Quoins (Left and Right pillars)
    final quoinW = rect.width * 0.14;
    final quoinPaint = Paint()
      ..color = theme.columnColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(rect.left, rect.top, quoinW, rect.height), quoinPaint);
    canvas.drawRect(Rect.fromLTWH(rect.right - quoinW, rect.top, quoinW, rect.height), quoinPaint);

    // Quoin horizontal seam lines
    final seamPaint = Paint()
      ..color = const Color(0xFF212121).withValues(alpha: opacity * 0.4)
      ..strokeWidth = 1.4;
    for (int i = 1; i < 4; i++) {
      final y = rect.top + (rect.height * (i / 4));
      canvas.drawLine(Offset(rect.left, y), Offset(rect.left + quoinW, y), seamPaint);
      canvas.drawLine(Offset(rect.right - quoinW, y), Offset(rect.right, y), seamPaint);
    }

    // Central Grand Entrance Door
    final doorW = rect.width * 0.40;
    final doorH = rect.height * 0.88;
    final doorLeft = rect.left + (rect.width - doorW) / 2;
    final doorTop = rect.bottom - doorH;
    final doorRect = Rect.fromLTWH(doorLeft, doorTop, doorW, doorH);

    // Stone threshold step at the bottom
    final stepH = 6.0;
    final stepRect = Rect.fromLTWH(doorLeft - 4, rect.bottom - stepH, doorW + 8, stepH);
    final stepPaint = Paint()
      ..color = theme.brickMortarColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(stepRect, const Radius.circular(2.0)), stepPaint);

    // Outer Door Frame
    final frameRRect = RRect.fromRectAndCorners(
      doorRect,
      topLeft: const Radius.circular(6.0),
      topRight: const Radius.circular(6.0),
    );
    final framePaint = Paint()
      ..color = theme.doorAccentColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(frameRRect, framePaint);

    // Door Leaf
    final leafRect = Rect.fromLTWH(doorLeft + 3, doorTop + 3, doorW - 6, doorH - stepH - 3);
    final leafPaint = Paint()
      ..color = theme.doorColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRect(leafRect, leafPaint);

    // Recessed Panels
    final panelPaint = Paint()
      ..color = theme.doorAccentColor.withValues(alpha: opacity * 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final pW = leafRect.width * 0.76;
    final pLeft = leafRect.left + (leafRect.width - pW) / 2;
    final topP = Rect.fromLTWH(pLeft, leafRect.top + 4, pW, leafRect.height * 0.42);
    final btmP = Rect.fromLTWH(pLeft, leafRect.top + leafRect.height * 0.52, pW, leafRect.height * 0.42);
    canvas.drawRRect(RRect.fromRectAndRadius(topP, const Radius.circular(2.5)), panelPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(btmP, const Radius.circular(2.5)), panelPaint);

    // Brass Doorknob
    final knobPaint = Paint()
      ..color = const Color(0xFFFFD54F).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(leafRect.right - 6.0, leafRect.top + leafRect.height * 0.52), 3.0, knobPaint);

    // Exterior Wall Lanterns on Left and Right
    final lanternPaint = Paint()
      ..color = const Color(0xFFFFCA28).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    final lanternFrame = Paint()
      ..color = const Color(0xFF212121).withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final leftLantern = Rect.fromCenter(center: Offset(doorLeft - (doorLeft - (rect.left + quoinW)) / 2, rect.top + rect.height * 0.42), width: 8, height: 12);
    final rightLantern = Rect.fromCenter(center: Offset(doorRect.right + ((rect.right - quoinW) - doorRect.right) / 2, rect.top + rect.height * 0.42), width: 8, height: 12);
    canvas.drawRect(leftLantern, lanternPaint);
    canvas.drawRect(leftLantern, lanternFrame);
    canvas.drawRect(rightLantern, lanternPaint);
    canvas.drawRect(rightLantern, lanternFrame);

    // Bold Outline
    final borderPaint = Paint()
      ..color = const Color(0xFF212121).withValues(alpha: opacity * 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawRRect(rrect, borderPaint);
    canvas.drawRRect(frameRRect, borderPaint);
  }

  // 2. Sütunlu Kolon Katı (4 Sütunlu Kraliyet Galerisi)
  static void _drawColumn(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4.0));

    // Dark Architrave / Gallery Background
    final bgPaint = Paint()
      ..color = const Color(0xDD1E293B).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, bgPaint);

    // Top Beam Architrave & Bottom Plinth
    final beamH = rect.height * 0.14;
    final topBeam = Rect.fromLTWH(rect.left, rect.top, rect.width, beamH);
    final btmBeam = Rect.fromLTWH(rect.left, rect.bottom - beamH, rect.width, beamH);
    final beamPaint = Paint()
      ..color = theme.columnColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRect(topBeam, beamPaint);
    canvas.drawRect(btmBeam, beamPaint);

    // 4 Classical Pillars
    final pillarCount = 4;
    final pillarW = rect.width * 0.12;
    final totalPillarW = pillarCount * pillarW;
    final spacing = (rect.width - totalPillarW) / (pillarCount + 1);

    final pillarPaint = Paint()
      ..color = theme.columnColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    final flutingPaint = Paint()
      ..color = theme.columnDetailColor.withValues(alpha: opacity * 0.8)
      ..strokeWidth = 1.4;

    for (int i = 0; i < pillarCount; i++) {
      final pLeft = rect.left + spacing + i * (pillarW + spacing);
      final pRect = Rect.fromLTWH(pLeft, rect.top + beamH, pillarW, rect.height - 2 * beamH);
      canvas.drawRect(pRect, pillarPaint);

      // Fluting lines
      final midX = pRect.center.dx;
      canvas.drawLine(Offset(midX - 3, pRect.top + 2), Offset(midX - 3, pRect.bottom - 2), flutingPaint);
      canvas.drawLine(Offset(midX + 3, pRect.top + 2), Offset(midX + 3, pRect.bottom - 2), flutingPaint);
    }

    // Bold Outline
    final borderPaint = Paint()
      ..color = const Color(0xFF212121).withValues(alpha: opacity * 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawRRect(rrect, borderPaint);
    canvas.drawRect(topBeam, borderPaint);
    canvas.drawRect(btmBeam, borderPaint);
  }

  // 3. Kat Kirişi (Geniş Yapısal Kiriş)
  static void _drawBeam(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4.0));

    // Beam Fill
    final beamPaint = Paint()
      ..color = theme.beamColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, beamPaint);

    // Bevel highlights
    final bevelPaint = Paint()
      ..color = Colors.white.withValues(alpha: opacity * 0.35)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(rect.left + 4, rect.top + 2), Offset(rect.right - 4, rect.top + 2), bevelPaint);

    // Grain line
    final grainPaint = Paint()
      ..color = theme.beamDetailColor.withValues(alpha: opacity * 0.8)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    final midY = rect.top + rect.height / 2;
    canvas.drawLine(Offset(rect.left + 8, midY), Offset(rect.right - 8, midY), grainPaint);

    // Bolted Joint Plates
    final boltPaint = Paint()
      ..color = const Color(0xFFFFD54F).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    for (final x in [rect.left + 10.0, rect.left + rect.width * 0.33, rect.left + rect.width * 0.67, rect.right - 10.0]) {
      canvas.drawCircle(Offset(x, midY), 2.8, boltPaint);
    }

    // Bold Outline
    final borderPaint = Paint()
      ..color = const Color(0xFF212121).withValues(alpha: opacity * 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawRRect(rrect, borderPaint);
  }

  // 4. Pencereli Yaşam Katı (Çift Pencereli & Tuğla Duvarlı Kat)
  static void _drawWindow(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4.0));

    // Wall Facade
    final wallPaint = Paint()
      ..color = theme.wallColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, wallPaint);

    // Masonry Seams in center
    final seamPaint = Paint()
      ..color = const Color(0xFF212121).withValues(alpha: opacity * 0.25)
      ..strokeWidth = 1.4;
    final midX = rect.center.dx;
    canvas.drawLine(Offset(midX, rect.top + 4), Offset(midX, rect.bottom - 4), seamPaint);

    // Dual Symmetrical Windows (Left & Right)
    final winW = rect.width * 0.32;
    final winH = rect.height * 0.68;
    final winY = rect.top + (rect.height - winH) / 2;

    final leftWinRect = Rect.fromLTWH(rect.left + rect.width * 0.12, winY, winW, winH);
    final rightWinRect = Rect.fromLTWH(rect.right - rect.width * 0.12 - winW, winY, winW, winH);

    for (final wRect in [leftWinRect, rightWinRect]) {
      // Outer Frame
      final frameRRect = RRect.fromRectAndRadius(wRect, const Radius.circular(4.0));
      final framePaint = Paint()
        ..color = theme.windowFrameColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(frameRRect, framePaint);

      // Glass Area
      final glassRect = Rect.fromLTWH(wRect.left + 3, wRect.top + 3, wRect.width - 6, wRect.height - 8);
      final glassPaint = Paint()
        ..color = theme.windowGlassColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      canvas.drawRect(glassRect, glassPaint);

      // Cross Mullions
      final mullionPaint = Paint()
        ..color = theme.windowFrameColor.withValues(alpha: opacity)
        ..strokeWidth = 2.0;
      final gMidX = glassRect.center.dx;
      final gMidY = glassRect.center.dy;
      canvas.drawLine(Offset(gMidX, glassRect.top), Offset(gMidX, glassRect.bottom), mullionPaint);
      canvas.drawLine(Offset(glassRect.left, gMidY), Offset(glassRect.right, gMidY), mullionPaint);

      // Specular Shine
      final shinePaint = Paint()
        ..color = Colors.white.withValues(alpha: opacity * 0.75)
        ..strokeWidth = 2.0;
      canvas.drawLine(Offset(glassRect.left + 4, glassRect.bottom - 4), Offset(glassRect.right - 4, glassRect.top + 4), shinePaint);

      // Window Sill
      final sillRect = Rect.fromLTWH(wRect.left - 2, wRect.bottom - 4, wRect.width + 4, 5);
      final sillPaint = Paint()
        ..color = theme.columnColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(RRect.fromRectAndRadius(sillRect, const Radius.circular(1.5)), sillPaint);

      // Outline
      final winBorder = Paint()
        ..color = const Color(0xFF212121).withValues(alpha: opacity * 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawRRect(frameRRect, winBorder);
    }

    // Bold Outer Outline
    final borderPaint = Paint()
      ..color = const Color(0xFF212121).withValues(alpha: opacity * 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawRRect(rrect, borderPaint);
  }

  // 5. Duvar Bloğu (Bireysel Taş/Tuğla Duvar Bloğu)
  static void _drawWall(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4.0));

    // Wall Fill
    final wallPaint = Paint()
      ..color = theme.wallColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, wallPaint);

    // Masonry courses and mortar joints
    final mortarPaint = Paint()
      ..color = theme.wallBorderColor.withValues(alpha: opacity * 0.75)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final row1Y = rect.top + rect.height * 0.33;
    final row2Y = rect.top + rect.height * 0.66;
    canvas.drawLine(Offset(rect.left + 3, row1Y), Offset(rect.right - 3, row1Y), mortarPaint);
    canvas.drawLine(Offset(rect.left + 3, row2Y), Offset(rect.right - 3, row2Y), mortarPaint);

    // Vertical joints
    final midX = rect.left + rect.width * 0.5;
    final quarter1X = rect.left + rect.width * 0.25;
    final quarter3X = rect.left + rect.width * 0.75;
    canvas.drawLine(Offset(midX, rect.top + 2), Offset(midX, row1Y), mortarPaint);
    canvas.drawLine(Offset(quarter1X, row1Y), Offset(quarter1X, row2Y), mortarPaint);
    canvas.drawLine(Offset(quarter3X, row1Y), Offset(quarter3X, row2Y), mortarPaint);
    canvas.drawLine(Offset(midX, row2Y), Offset(midX, rect.bottom - 2), mortarPaint);

    // Bold Outline
    final borderPaint = Paint()
      ..color = const Color(0xFF212121).withValues(alpha: opacity * 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawRRect(rrect, borderPaint);
  }

  // 6. Kiremit Çatı (Bireysel Çatı Bloğu)
  static void _drawRoof(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    final apexX = rect.left + rect.width / 2;
    final path = Path()
      ..moveTo(apexX, rect.top)          // Apex
      ..lineTo(rect.right, rect.bottom)  // Bottom right
      ..lineTo(rect.left, rect.bottom)   // Bottom left
      ..close();

    final roofPaint = Paint()
      ..color = theme.roofColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, roofPaint);

    // Shingle lines
    final shinglePaint = Paint()
      ..color = Colors.black.withValues(alpha: opacity * 0.35)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    final layers = 3;
    for (int i = 1; i <= layers; i++) {
      final factor = i / (layers + 1);
      final y = rect.top + (rect.height * factor);
      final halfW = (rect.width / 2) * factor;
      canvas.drawLine(Offset(apexX - halfW, y), Offset(apexX + halfW, y), shinglePaint);
    }

    // Apex Ornament
    final capPaint = Paint()
      ..color = const Color(0xFFFFD54F).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(apexX, rect.top + 2.0), 4.5, capPaint);

    // Bold Outline
    final borderPaint = Paint()
      ..color = const Color(0xFF212121).withValues(alpha: opacity * 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6;
    canvas.drawPath(path, borderPaint);
  }

  // 7. Çiçekli Balkon (Ferforje Korkuluk & Çiçek Kutulu Teras)
  static void _drawBalcony(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    final slabHeight = rect.height * 0.28;
    final slabRect = Rect.fromLTWH(rect.left, rect.bottom - slabHeight, rect.width, slabHeight);
    final slabRRect = RRect.fromRectAndRadius(slabRect, const Radius.circular(3.0));

    // Stone / Wood Floor Slab
    final slabPaint = Paint()
      ..color = theme.beamColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(slabRRect, slabPaint);

    // Decorative corbel brackets under slab
    final corbelPaint = Paint()
      ..color = theme.columnColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(rect.left + 4, rect.bottom - 4, 8, 5), const Radius.circular(1.5)), corbelPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(rect.right - 12, rect.bottom - 4, 8, 5), const Radius.circular(1.5)), corbelPaint);

    // Wrought Iron Railing Top Bar
    final railTop = rect.top + 6.0;
    final railPaint = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: opacity)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(rect.left + 2, railTop), Offset(rect.right - 2, railTop), railPaint);

    // Vertical Balusters
    final balusterCount = 6;
    final balusterSpacing = (rect.width - 12) / (balusterCount - 1);
    for (int i = 0; i < balusterCount; i++) {
      final x = rect.left + 6 + (i * balusterSpacing);
      canvas.drawLine(Offset(x, railTop), Offset(x, slabRect.top), railPaint);
    }

    // Wooden Planter Box
    final boxW = rect.width * 0.82;
    final boxH = rect.height * 0.32;
    final boxLeft = rect.left + (rect.width - boxW) / 2;
    final boxTop = slabRect.top - boxH + 2.0;
    final boxRect = Rect.fromLTWH(boxLeft, boxTop, boxW, boxH);
    final boxPaint = Paint()
      ..color = const Color(0xFF8D6E63).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    final boxRRect = RRect.fromRectAndRadius(boxRect, const Radius.circular(2.5));
    canvas.drawRRect(boxRRect, boxPaint);

    // Flower Blooms (Red, Pink, Yellow) and Green Leaves
    final flowerColors = [
      const Color(0xFFEF5350), // Red
      const Color(0xFFFFCA28), // Yellow
      const Color(0xFFEC407A), // Pink
      const Color(0xFFFF7043), // Orange
      const Color(0xFFAB47BC), // Purple
    ];
    final leafPaint = Paint()
      ..color = const Color(0xFF4CAF50).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    final flowerCount = 5;
    final fSpacing = (boxW - 10) / (flowerCount - 1);
    for (int i = 0; i < flowerCount; i++) {
      final fx = boxLeft + 5 + (i * fSpacing);
      final fy = boxTop - 2.0;

      // Green Leaf
      canvas.drawCircle(Offset(fx - 2, fy + 2), 3.0, leafPaint);
      canvas.drawCircle(Offset(fx + 2, fy + 2), 3.0, leafPaint);

      // Colorful Bloom
      final bloomPaint = Paint()
        ..color = flowerColors[i % flowerColors.length].withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(fx, fy), 4.0, bloomPaint);

      // Flower Center
      final centerPaint = Paint()
        ..color = Colors.white.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(fx, fy), 1.5, centerPaint);
    }

    // Bold Outline
    final borderPaint = Paint()
      ..color = const Color(0xFF212121).withValues(alpha: opacity * 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawRRect(slabRRect, borderPaint);
    canvas.drawRRect(boxRRect, borderPaint);
  }

  // 8. Antik Taş Kemer (Kemerli Giriş / Kapı Kemeri)
  static void _drawArch(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4.0));

    // Outer Stone Wall Fill
    final wallPaint = Paint()
      ..color = theme.wallColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, wallPaint);

    // Arch Opening Cutout
    final archW = rect.width * 0.54;
    final archH = rect.height * 0.72;
    final archLeft = rect.left + (rect.width - archW) / 2;
    final archRight = archLeft + archW;
    final archSpringY = rect.bottom - (archH * 0.60);

    final archPath = Path()
      ..moveTo(archLeft, rect.bottom)
      ..lineTo(archLeft, archSpringY)
      ..arcToPoint(
        Offset(archRight, archSpringY),
        radius: Radius.circular(archW / 2),
        clockwise: true,
      )
      ..lineTo(archRight, rect.bottom)
      ..close();

    // Dark Arched Opening (Interior depth shadow)
    final openingPaint = Paint()
      ..color = const Color(0xCC1E293B).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawPath(archPath, openingPaint);

    // Voussoirs / Stone Radial Arch Rim
    final rimPaint = Paint()
      ..color = theme.brickMortarColor.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawPath(archPath, rimPaint);

    // Central Prominent Keystone (Kilit Taşı) at apex
    final keystoneW = 12.0;
    final keystoneH = 14.0;
    final keystonePath = Path()
      ..moveTo(rect.center.dx - keystoneW / 2, archSpringY - (archW / 2) - 3)
      ..lineTo(rect.center.dx + keystoneW / 2, archSpringY - (archW / 2) - 3)
      ..lineTo(rect.center.dx + (keystoneW * 0.35), archSpringY - (archW / 2) + keystoneH)
      ..lineTo(rect.center.dx - (keystoneW * 0.35), archSpringY - (archW / 2) + keystoneH)
      ..close();

    final keystonePaint = Paint()
      ..color = theme.columnColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawPath(keystonePath, keystonePaint);

    // Bold Outline
    final borderPaint = Paint()
      ..color = const Color(0xFF212121).withValues(alpha: opacity * 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawRRect(rrect, borderPaint);
    canvas.drawPath(archPath, borderPaint);
    canvas.drawPath(keystonePath, borderPaint);
  }

  // 9. Görkemli Altın / Turkuaz Kubbe
  static void _drawDome(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    final baseH = rect.height * 0.18;
    final baseRect = Rect.fromLTWH(rect.left, rect.bottom - baseH, rect.width, baseH);
    final baseRRect = RRect.fromRectAndRadius(baseRect, const Radius.circular(3.0));

    // Base Plinth / Cornice
    final plinthPaint = Paint()
      ..color = theme.columnColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(baseRRect, plinthPaint);

    // Smooth Curved Dome Shell
    final domeApexX = rect.left + rect.width / 2;
    final domeApexY = rect.top + 10.0;
    final domePath = Path()
      ..moveTo(rect.left + 4, rect.bottom - baseH)
      ..cubicTo(
        rect.left + 4,
        rect.top + (rect.height * 0.2),
        domeApexX - (rect.width * 0.2),
        domeApexY,
        domeApexX,
        domeApexY,
      )
      ..cubicTo(
        domeApexX + (rect.width * 0.2),
        domeApexY,
        rect.right - 4,
        rect.top + (rect.height * 0.2),
        rect.right - 4,
        rect.bottom - baseH,
      )
      ..close();

    // Vibrant Metallic Gold / Royal Dome Shading
    final domePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFFD54F).withValues(alpha: opacity),
          const Color(0xFFFFA000).withValues(alpha: opacity),
        ],
      ).createShader(rect);
    canvas.drawPath(domePath, domePaint);

    // Vertical Ribbed Lines for 3D sphere look
    final ribPaint = Paint()
      ..color = const Color(0xFFC77800).withValues(alpha: opacity * 0.8)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final quarterW = (rect.width / 2) * 0.52;
    // Left rib
    final leftRib = Path()
      ..moveTo(domeApexX, domeApexY)
      ..cubicTo(
        domeApexX - quarterW,
        rect.top + (rect.height * 0.3),
        domeApexX - quarterW,
        rect.bottom - baseH,
        domeApexX - quarterW,
        rect.bottom - baseH,
      );
    canvas.drawPath(leftRib, ribPaint);

    // Right rib
    final rightRib = Path()
      ..moveTo(domeApexX, domeApexY)
      ..cubicTo(
        domeApexX + quarterW,
        rect.top + (rect.height * 0.3),
        domeApexX + quarterW,
        rect.bottom - baseH,
        domeApexX + quarterW,
        rect.bottom - baseH,
      );
    canvas.drawPath(rightRib, ribPaint);

    // Center Vertical Spine
    canvas.drawLine(Offset(domeApexX, domeApexY), Offset(domeApexX, rect.bottom - baseH), ribPaint);

    // Royal Golden Spire / Finial (Alem) on Apex
    final spirePaint = Paint()
      ..color = const Color(0xFFFFECB3).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    final spireBorder = Paint()
      ..color = const Color(0xFF212121).withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    // Spire rod
    final spireTopY = rect.top;
    canvas.drawLine(Offset(domeApexX, domeApexY), Offset(domeApexX, spireTopY), spireBorder..strokeWidth = 2.4);

    // Finial ball & crescent
    canvas.drawCircle(Offset(domeApexX, spireTopY + 3.0), 3.5, spirePaint);
    canvas.drawCircle(Offset(domeApexX, spireTopY + 3.0), 3.5, spireBorder);

    // Bold Outline
    final borderPaint = Paint()
      ..color = const Color(0xFF212121).withValues(alpha: opacity * 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6;
    canvas.drawPath(domePath, borderPaint);
    canvas.drawRRect(baseRRect, borderPaint);
  }

  // 10. Bölüm 4: Ağır Demir Parmaklıklı Şato Kapısı (Gate)
  static void _drawGate(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4.0));

    // Dark fortress stone facade
    final wallPaint = Paint()
      ..color = theme.wallColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, wallPaint);

    // Fortress Corner Bastion Stones (Left & Right)
    final bastionW = rect.width * 0.16;
    final bastionPaint = Paint()
      ..color = theme.columnColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(rect.left, rect.top, bastionW, rect.height), bastionPaint);
    canvas.drawRect(Rect.fromLTWH(rect.right - bastionW, rect.top, bastionW, rect.height), bastionPaint);

    // Stone seam cuts
    final seamPaint = Paint()
      ..color = const Color(0xFF0F172A).withValues(alpha: opacity * 0.6)
      ..strokeWidth = 1.4;
    for (int i = 1; i < 4; i++) {
      final y = rect.top + (rect.height * (i / 4));
      canvas.drawLine(Offset(rect.left, y), Offset(rect.left + bastionW, y), seamPaint);
      canvas.drawLine(Offset(rect.right - bastionW, y), Offset(rect.right, y), seamPaint);
    }

    // Heavy Stone Arch Entryway
    final archW = rect.width * 0.48;
    final archH = rect.height * 0.90;
    final archLeft = rect.left + (rect.width - archW) / 2;
    final archTop = rect.bottom - archH;

    // Deep shadowy portal interior
    final portalPath = Path()
      ..moveTo(archLeft, rect.bottom)
      ..lineTo(archLeft, archTop + archW / 2)
      ..arcTo(
        Rect.fromLTWH(archLeft, archTop, archW, archW),
        3.14159,
        3.14159,
        false,
      )
      ..lineTo(archLeft + archW, rect.bottom)
      ..close();

    final shadowPaint = Paint()
      ..color = const Color(0xFF090D16).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawPath(portalPath, shadowPaint);

    // Outer Stone Arch Voussoirs (Arch stones)
    final archFramePaint = Paint()
      ..color = theme.columnColor.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;
    canvas.drawPath(portalPath, archFramePaint);

    // Heavy Iron Portcullis (Demir Parmaklık)
    final ironPaint = Paint()
      ..color = const Color(0xFF475569).withValues(alpha: opacity)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.square;

    // Vertical iron bars with sharp spear tips
    const barCount = 5;
    for (int i = 0; i < barCount; i++) {
      final bx = archLeft + (archW * (i + 1) / (barCount + 1));
      final byTop = archTop + 8.0;
      final byBtm = rect.bottom - 6.0;
      canvas.drawLine(Offset(bx, byTop), Offset(bx, byBtm), ironPaint);

      // Spear spike tip
      final tipPath = Path()
        ..moveTo(bx - 3.0, byBtm - 6.0)
        ..lineTo(bx, byBtm)
        ..lineTo(bx + 3.0, byBtm - 6.0)
        ..close();
      canvas.drawPath(tipPath, Paint()..color = const Color(0xFF94A3B8).withValues(alpha: opacity));
    }

    // Horizontal crossbars with golden rivets
    final rivetPaint = Paint()
      ..color = const Color(0xFFF59E0B).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    for (int r = 1; r <= 3; r++) {
      final ry = archTop + (archH * (r / 4));
      canvas.drawLine(Offset(archLeft + 4, ry), Offset(archLeft + archW - 4, ry), ironPaint..strokeWidth = 3.5);
      for (int i = 0; i < barCount; i++) {
        final bx = archLeft + (archW * (i + 1) / (barCount + 1));
        canvas.drawCircle(Offset(bx, ry), 2.2, rivetPaint);
      }
    }

    // Two Glowing Wall Torches on left and right
    final torchColor = const Color(0xFFF59E0B).withValues(alpha: opacity);
    final flameColor = const Color(0xFFEF4444).withValues(alpha: opacity * 0.85);
    final torchY = rect.top + rect.height * 0.45;
    final leftTorchX = rect.left + bastionW * 0.55;
    final rightTorchX = rect.right - bastionW * 0.55;

    for (final tx in [leftTorchX, rightTorchX]) {
      // Sconce bracket
      canvas.drawLine(Offset(tx - 3, torchY + 6), Offset(tx + 3, torchY + 6), seamPaint..strokeWidth = 2.0);
      canvas.drawRect(Rect.fromCenter(center: Offset(tx, torchY + 4), width: 5, height: 8), Paint()..color = const Color(0xFF1E293B));
      // Outer amber flame glow
      canvas.drawCircle(Offset(tx, torchY - 2), 5.5, Paint()..color = torchColor);
      // Inner yellow flame
      canvas.drawCircle(Offset(tx, torchY - 2), 3.0, Paint()..color = const Color(0xFFFEF08A));
      // Flickering red top
      canvas.drawCircle(Offset(tx, torchY - 5), 2.0, Paint()..color = flameColor);
    }

    // Bold Outline
    final borderPaint = Paint()
      ..color = const Color(0xFF0F172A).withValues(alpha: opacity * 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawRRect(rrect, borderPaint);
    canvas.drawPath(portalPath, borderPaint);
  }

  // 11. Bölüm 4: Gotik Gül Vitray Katı (Rose Window)
  static void _drawRoseWindow(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4.0));

    // Dark ashlar stone facade
    final wallPaint = Paint()
      ..color = theme.wallColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, wallPaint);

    // Gothic side buttress pillars
    final pillarW = rect.width * 0.12;
    final pillarPaint = Paint()
      ..color = theme.columnColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(rect.left, rect.top, pillarW, rect.height), pillarPaint);
    canvas.drawRect(Rect.fromLTWH(rect.right - pillarW, rect.top, pillarW, rect.height), pillarPaint);

    // Two flanking pointed lancet windows
    final lancetW = rect.width * 0.10;
    final lancetH = rect.height * 0.65;
    final lancetY = rect.bottom - lancetH - 6.0;

    for (final lx in [rect.left + pillarW + 5.0, rect.right - pillarW - lancetW - 5.0]) {
      final lancetPath = Path()
        ..moveTo(lx, rect.bottom - 6.0)
        ..lineTo(lx, lancetY + lancetW)
        ..arcToPoint(Offset(lx + lancetW / 2, lancetY), radius: Radius.circular(lancetW * 0.8))
        ..arcToPoint(Offset(lx + lancetW, lancetY + lancetW), radius: Radius.circular(lancetW * 0.8))
        ..lineTo(lx + lancetW, rect.bottom - 6.0)
        ..close();
      // Glowing warm golden light from inside
      canvas.drawPath(lancetPath, Paint()..color = const Color(0xFFFDE047).withValues(alpha: opacity * 0.9));
      canvas.drawPath(lancetPath, Paint()
        ..color = const Color(0xFF0F172A).withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6);
      // Cross mullion
      canvas.drawLine(Offset(lx + lancetW / 2, lancetY), Offset(lx + lancetW / 2, rect.bottom - 6.0), Paint()..color = const Color(0xFF0F172A)..strokeWidth = 1.2);
    }

    // Central Grand Rose Window
    final roseRadius = (rect.height * 0.40);
    final roseCenter = rect.center;

    // Outer stone tracery ring
    final outerRingPaint = Paint()
      ..color = const Color(0xFFF59E0B).withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawCircle(roseCenter, roseRadius + 3.0, outerRingPaint);

    // Colorful Stained Glass Sectors (8 petals)
    final petalColors = [
      const Color(0xFFE11D48), // Ruby red
      const Color(0xFF2563EB), // Sapphire blue
      const Color(0xFF9333EA), // Royal amethyst
      const Color(0xFFF59E0B), // Glowing amber
      const Color(0xFF059669), // Emerald
      const Color(0xFF2563EB), // Sapphire blue
      const Color(0xFFE11D48), // Ruby red
      const Color(0xFFF59E0B), // Glowing amber
    ];

    for (int i = 0; i < 8; i++) {
      const sweepAngle = (3.14159 / 4);
      final startAngle = i * sweepAngle;
      final sectorPaint = Paint()
        ..color = petalColors[i].withValues(alpha: opacity * 0.92)
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(center: roseCenter, radius: roseRadius),
        startAngle,
        sweepAngle,
        true,
        sectorPaint,
      );
    }

    // Lead mullions radiating outward
    final leadPaint = Paint()
      ..color = const Color(0xFF0F172A).withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    for (int i = 0; i < 8; i++) {
      final angle = i * (3.14159 / 4);
      final pt = roseCenter + Offset.fromDirection(angle, roseRadius);
      canvas.drawLine(roseCenter, pt, leadPaint);
    }

    // Center Golden Boss / Flower Medallion
    canvas.drawCircle(roseCenter, roseRadius * 0.28, Paint()..color = const Color(0xFFFDE047).withValues(alpha: opacity));
    canvas.drawCircle(roseCenter, roseRadius * 0.28, Paint()
      ..color = const Color(0xFF0F172A).withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0);

    // Bold Outline
    final borderPaint = Paint()
      ..color = const Color(0xFF0F172A).withValues(alpha: opacity * 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawRRect(rrect, borderPaint);
  }

  // 12. Bölüm 4: Dev Altın Saat Katı (Clock Face)
  static void _drawClock(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4.0));

    // Dark fortress stone background
    final wallPaint = Paint()
      ..color = theme.wallColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, wallPaint);

    // Beveled square clock casing frame
    const caseMargin = 6.0;
    final caseRect = Rect.fromLTWH(rect.left + caseMargin, rect.top + caseMargin, rect.width - caseMargin * 2, rect.height - caseMargin * 2);
    final casePaint = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(caseRect, const Radius.circular(6.0)), casePaint);

    // 4 Golden Corner Medallions (Ornate clock corners)
    final cornerGold = Paint()
      ..color = const Color(0xFFF59E0B).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(caseRect.left + 8, caseRect.top + 8), 4.5, cornerGold);
    canvas.drawCircle(Offset(caseRect.right - 8, caseRect.top + 8), 4.5, cornerGold);
    canvas.drawCircle(Offset(caseRect.left + 8, caseRect.bottom - 8), 4.5, cornerGold);
    canvas.drawCircle(Offset(caseRect.right - 8, caseRect.bottom - 8), 4.5, cornerGold);

    // Large Circular Clock Dial
    final clockCenter = rect.center;
    final dialRadius = (rect.height * 0.42);

    // Outer Gear / Beaded Golden Rim
    final rimPaint = Paint()
      ..color = const Color(0xFFF59E0B).withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawCircle(clockCenter, dialRadius, rimPaint);

    // Glowing warm clock face
    final dialPaint = Paint()
      ..color = const Color(0xFFFFFBEB).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(clockCenter, dialRadius - 2.0, dialPaint);

    // Inner subtle rim
    canvas.drawCircle(
      clockCenter,
      dialRadius - 7.0,
      Paint()
        ..color = const Color(0xFFCBD5E1).withValues(alpha: opacity * 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // 12 Hour Marks (Major marks on 12, 3, 6, 9)
    final markPaint = Paint()
      ..color = const Color(0xFF0F172A).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    for (int h = 0; h < 12; h++) {
      final angle = (h * 30.0 - 90.0) * (3.14159 / 180.0);
      final isMajor = (h % 3 == 0);
      final dist = dialRadius - 5.5;
      final markOffset = clockCenter + Offset.fromDirection(angle, dist);

      if (isMajor) {
        canvas.drawCircle(markOffset, 2.5, markPaint);
      } else {
        canvas.drawCircle(markOffset, 1.4, markPaint);
      }
    }

    // Antique Ornate Clock Hands (10:10 classic aesthetic)
    // Hour Hand pointing to 10 o'clock (-120 degrees)
    const hourAngle = (-120.0) * (3.14159 / 180.0);
    final hourLen = dialRadius * 0.52;
    final hourPt = clockCenter + Offset.fromDirection(hourAngle, hourLen);
    canvas.drawLine(
      clockCenter,
      hourPt,
      Paint()
        ..color = const Color(0xFF0F172A).withValues(alpha: opacity)
        ..strokeWidth = 3.2
        ..strokeCap = StrokeCap.round,
    );

    // Minute Hand pointing to 2 o'clock (-30 degrees)
    const minuteAngle = (-30.0) * (3.14159 / 180.0);
    final minuteLen = dialRadius * 0.76;
    final minutePt = clockCenter + Offset.fromDirection(minuteAngle, minuteLen);
    canvas.drawLine(
      clockCenter,
      minutePt,
      Paint()
        ..color = const Color(0xFF0F172A).withValues(alpha: opacity)
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round,
    );

    // Center Gold Pin & Cap
    canvas.drawCircle(clockCenter, 3.8, Paint()..color = const Color(0xFFF59E0B).withValues(alpha: opacity));
    canvas.drawCircle(clockCenter, 1.8, Paint()..color = const Color(0xFF0F172A).withValues(alpha: opacity));

    // Bold Outlines
    final borderPaint = Paint()
      ..color = const Color(0xFF0F172A).withValues(alpha: opacity * 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawRRect(rrect, borderPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(caseRect, const Radius.circular(6.0)), borderPaint);
  }

  // 13. Bölüm 4: Mazgallı Muhafız Siperi & Meşaleler (Crenellation)
  static void _drawCrenellation(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    // Parapet corbel stone base band
    final corbelH = rect.height * 0.35;
    final corbelY = rect.bottom - corbelH;
    final baseRect = Rect.fromLTWH(rect.left, corbelY, rect.width, corbelH);

    final wallPaint = Paint()
      ..color = theme.wallColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRect(baseRect, wallPaint);

    // Corbel brackets supporting the parapet
    const bracketCount = 6;
    final bracketPaint = Paint()
      ..color = theme.columnColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < bracketCount; i++) {
      final bx = rect.left + (rect.width * i / (bracketCount - 1));
      final bRect = Rect.fromCenter(center: Offset(bx, corbelY + corbelH / 2), width: 7.0, height: corbelH - 2.0);
      canvas.drawRRect(RRect.fromRectAndRadius(bRect, const Radius.circular(1.5)), bracketPaint);
    }

    // Upper Parapet Wall with Alternating Merlons (Teeth) and Crenels (Gaps)
    const merlonCount = 5;
    final merlonW = rect.width / (merlonCount * 2 - 1);
    final merlonH = rect.height * 0.65;
    final crenelY = rect.top + merlonH * 0.45;

    final merlonPaint = Paint()
      ..color = theme.columnColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    // Draw crenel low wall
    canvas.drawRect(Rect.fromLTWH(rect.left, crenelY, rect.width, corbelY - crenelY), wallPaint);

    // Draw upright stone merlons
    for (int i = 0; i < merlonCount; i++) {
      final mx = rect.left + (i * 2 * merlonW);
      final mRect = Rect.fromLTWH(mx, rect.top, merlonW, corbelY - rect.top);
      canvas.drawRect(mRect, merlonPaint);

      // Stone cap on each merlon
      final capRect = Rect.fromLTWH(mx - 1.0, rect.top - 1.0, merlonW + 2.0, 3.5);
      canvas.drawRRect(RRect.fromRectAndRadius(capRect, const Radius.circular(1.0)), Paint()..color = const Color(0xFFF1F5F9).withValues(alpha: opacity));

      // Arrow slits on middle merlons
      if (i > 0 && i < merlonCount - 1) {
        final slitRect = Rect.fromCenter(center: Offset(mx + merlonW / 2, rect.top + merlonH * 0.45), width: 3.0, height: 10.0);
        canvas.drawRRect(RRect.fromRectAndRadius(slitRect, const Radius.circular(1.0)), Paint()..color = const Color(0xFF0F172A).withValues(alpha: opacity));
      }
    }

    // Two Flaming Torches mounted on corner merlons
    final leftTorchX = rect.left + merlonW / 2;
    final rightTorchX = rect.right - merlonW / 2;
    final torchY = rect.top + 2.0;

    for (final tx in [leftTorchX, rightTorchX]) {
      // Golden torch bowl
      canvas.drawRect(Rect.fromCenter(center: Offset(tx, torchY), width: 6.0, height: 5.0), Paint()..color = const Color(0xFFF59E0B));
      // Outer bright orange flame
      canvas.drawCircle(Offset(tx, torchY - 5.0), 5.5, Paint()..color = const Color(0xFFF97316).withValues(alpha: opacity));
      // Inner yellow core flame
      canvas.drawCircle(Offset(tx, torchY - 5.0), 3.0, Paint()..color = const Color(0xFFFEF08A).withValues(alpha: opacity));
    }

    // Bold Outlines
    final borderPaint = Paint()
      ..color = const Color(0xFF0F172A).withValues(alpha: opacity * 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;

    final parapetPath = Path()..moveTo(rect.left, corbelY);
    for (int i = 0; i < merlonCount; i++) {
      final mx = rect.left + (i * 2 * merlonW);
      parapetPath.lineTo(mx, corbelY);
      parapetPath.lineTo(mx, rect.top);
      parapetPath.lineTo(mx + merlonW, rect.top);
      if (i < merlonCount - 1) {
        parapetPath.lineTo(mx + merlonW, crenelY);
        parapetPath.lineTo(mx + merlonW * 2, crenelY);
      } else {
        parapetPath.lineTo(mx + merlonW, corbelY);
      }
    }
    parapetPath.lineTo(rect.right, rect.bottom);
    parapetPath.lineTo(rect.left, rect.bottom);
    parapetPath.close();

    canvas.drawPath(parapetPath, borderPaint);
    canvas.drawLine(Offset(rect.left, corbelY), Offset(rect.right, corbelY), borderPaint);
  }

  // 14. Bölüm 4: Sivri Gotik Kule Çatısı & Rüzgârgülü (Spire)
  static void _drawSpire(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    // Belfry stone turret base
    final baseH = rect.height * 0.22;
    final baseY = rect.bottom - baseH;
    final baseRect = Rect.fromLTWH(rect.left + 2.0, baseY, rect.width - 4.0, baseH);

    final stonePaint = Paint()
      ..color = theme.columnColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(baseRect, const Radius.circular(3.0)), stonePaint);

    // Three Gothic Belfry Louver Arches in base
    final louverW = (baseRect.width - 24.0) / 3;
    final louverH = baseH * 0.65;
    for (int i = 0; i < 3; i++) {
      final lx = baseRect.left + 8.0 + (i * (louverW + 4.0));
      final ly = baseRect.bottom - louverH - 3.0;
      final lPath = Path()
        ..moveTo(lx, baseRect.bottom - 3.0)
        ..lineTo(lx, ly + louverW / 2)
        ..arcToPoint(Offset(lx + louverW / 2, ly), radius: Radius.circular(louverW * 0.7))
        ..arcToPoint(Offset(lx + louverW, ly + louverW / 2), radius: Radius.circular(louverW * 0.7))
        ..lineTo(lx + louverW, baseRect.bottom - 3.0)
        ..close();
      canvas.drawPath(lPath, Paint()..color = const Color(0xFF0F172A).withValues(alpha: opacity));
    }

    // Tall Gothic Needle Spire Cone
    final spireApexX = rect.center.dx;
    final spireApexY = rect.top + 20.0; // Leaves top 20px for golden weather vane
    final spireLeftX = baseRect.left + 2.0;
    final spireRightX = baseRect.right - 2.0;

    final spirePath = Path()
      ..moveTo(spireLeftX, baseY)
      ..lineTo(spireApexX, spireApexY)
      ..lineTo(spireRightX, baseY)
      ..close();

    final roofPaint = Paint()
      ..color = theme.roofColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawPath(spirePath, roofPaint);

    // Spire 3D Facet Shading (Right half darker slate)
    final shadowSpirePath = Path()
      ..moveTo(spireApexX, spireApexY)
      ..lineTo(spireRightX, baseY)
      ..lineTo(spireApexX, baseY)
      ..close();
    canvas.drawPath(
      shadowSpirePath,
      Paint()
        ..color = const Color(0xFF000000).withValues(alpha: opacity * 0.28)
        ..style = PaintingStyle.fill,
    );

    // Decorative Slate Tile Ridges (Horizontal scalloped bands)
    final ridgePaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: opacity * 0.22)
      ..strokeWidth = 1.4;
    for (int i = 1; i <= 4; i++) {
      final t = i / 5.0;
      final y = spireApexY + (baseY - spireApexY) * t;
      final halfW = (spireRightX - spireApexX) * t;
      canvas.drawLine(Offset(spireApexX - halfW, y), Offset(spireApexX + halfW, y), ridgePaint);
    }

    // Center Vertical Hip Ridge
    final spinePaint = Paint()
      ..color = const Color(0xFF0F172A).withValues(alpha: opacity * 0.8)
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(spireApexX, spireApexY), Offset(spireApexX, baseY), spinePaint);

    // Royal Golden Weather Vane & Spire Finial (Rüzgârgülü & Alem)
    final goldPaint = Paint()
      ..color = const Color(0xFFF59E0B).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    final vaneRodPaint = Paint()
      ..color = const Color(0xFF0F172A).withValues(alpha: opacity)
      ..strokeWidth = 2.2;

    // Central brass rod from apex to very top
    canvas.drawLine(Offset(spireApexX, spireApexY), Offset(spireApexX, rect.top), vaneRodPaint);

    // Lower finial sphere
    canvas.drawCircle(Offset(spireApexX, spireApexY - 4.0), 3.5, goldPaint);

    // Compass directional arms (Cross)
    final compassY = rect.top + 8.0;
    canvas.drawLine(Offset(spireApexX - 9.0, compassY), Offset(spireApexX + 9.0, compassY), vaneRodPaint);
    canvas.drawCircle(Offset(spireApexX - 9.0, compassY), 1.5, goldPaint);
    canvas.drawCircle(Offset(spireApexX + 9.0, compassY), 1.5, goldPaint);

    // Golden Wind Arrow at top
    final arrowY = rect.top + 3.0;
    final arrowPath = Path()
      ..moveTo(spireApexX - 8.0, arrowY + 2.0)
      ..lineTo(spireApexX + 4.0, arrowY + 2.0)
      ..lineTo(spireApexX + 8.0, arrowY)
      ..lineTo(spireApexX + 4.0, arrowY - 2.0)
      ..lineTo(spireApexX - 8.0, arrowY - 2.0)
      ..lineTo(spireApexX - 5.0, arrowY)
      ..close();
    canvas.drawPath(arrowPath, goldPaint);
    canvas.drawPath(
      arrowPath,
      Paint()
        ..color = const Color(0xFF0F172A).withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Bold Outlines
    final borderPaint = Paint()
      ..color = const Color(0xFF0F172A).withValues(alpha: opacity * 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawPath(spirePath, borderPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(baseRect, const Radius.circular(3.0)), borderPaint);
  }

  // 15. Bölüm 5: Kırmızı Torii Tapınak Girişi (Torii Gate)
  static void _drawToriiGate(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4.0));

    // Warm temple background wall
    final wallPaint = Paint()
      ..color = theme.wallColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, wallPaint);

    // Stone plinth floor at bottom
    const baseH = 6.0;
    canvas.drawRect(
      Rect.fromLTWH(rect.left, rect.bottom - baseH, rect.width, baseH),
      Paint()..color = const Color(0xFF292524).withValues(alpha: opacity),
    );

    // Two Main Vermilion Torii Pillars (Hashira)
    final pillarW = rect.width * 0.13;
    final pillarH = rect.height * 0.88;
    final pillarTop = rect.bottom - pillarH;
    final leftPillarX = rect.left + rect.width * 0.16;
    final rightPillarX = rect.right - rect.width * 0.16 - pillarW;

    final pillarPaint = Paint()
      ..color = const Color(0xFFDC2626).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    // Black stone pillar bases (Kamebara)
    final baseStonePaint = Paint()
      ..color = const Color(0xFF1C1917).withValues(alpha: opacity);
    for (final px in [leftPillarX, rightPillarX]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(px - 2.0, rect.bottom - 10.0, pillarW + 4.0, 10.0),
          const Radius.circular(2.0),
        ),
        baseStonePaint,
      );
      // Red pillar body
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(px, pillarTop, pillarW, pillarH - 4.0),
          const Radius.circular(3.0),
        ),
        pillarPaint,
      );
    }

    // Lower Crossbeam (Nuki) passing through pillars
    const nukiH = 6.5;
    final nukiY = pillarTop + pillarH * 0.28;
    final nukiRect = Rect.fromLTWH(rect.left + rect.width * 0.10, nukiY, rect.width * 0.80, nukiH);
    canvas.drawRRect(RRect.fromRectAndRadius(nukiRect, const Radius.circular(2.0)), pillarPaint);

    // Upper Curved Lintel (Kasagi & Shimaki)
    final kasagiPath = Path()
      ..moveTo(rect.left + 2.0, pillarTop - 4.0)
      ..quadraticBezierTo(rect.center.dx, pillarTop + 4.0, rect.right - 2.0, pillarTop - 4.0)
      ..lineTo(rect.right - 2.0, pillarTop + 7.0)
      ..quadraticBezierTo(rect.center.dx, pillarTop + 14.0, rect.left + 2.0, pillarTop + 7.0)
      ..close();
    canvas.drawPath(kasagiPath, pillarPaint);

    // Black lacquered top ridge cap
    final capPath = Path()
      ..moveTo(rect.left, pillarTop - 6.0)
      ..quadraticBezierTo(rect.center.dx, pillarTop + 2.0, rect.right, pillarTop - 6.0)
      ..lineTo(rect.right - 1.0, pillarTop - 2.0)
      ..quadraticBezierTo(rect.center.dx, pillarTop + 5.0, rect.left + 1.0, pillarTop - 2.0)
      ..close();
    canvas.drawPath(capPath, baseStonePaint);

    // Center Vertical Strut (Gakuzuka) with golden sacred tablet
    const gakuW = 12.0;
    final gakuH = nukiY - (pillarTop + 9.0);
    final gakuRect = Rect.fromLTWH(rect.center.dx - gakuW / 2, pillarTop + 9.0, gakuW, gakuH);
    canvas.drawRect(gakuRect, pillarPaint);
    // Gold emblem on tablet
    canvas.drawCircle(Offset(rect.center.dx, pillarTop + 9.0 + gakuH / 2), 3.5, Paint()..color = const Color(0xFFF59E0B).withValues(alpha: opacity));

    // Two Hanging Traditional Red Paper Lanterns (Chōchin)
    final lanternY = nukiY + 14.0;
    for (final lx in [leftPillarX + pillarW / 2 + 18.0, rightPillarX + pillarW / 2 - 18.0]) {
      // Hanging cord
      canvas.drawLine(Offset(lx, nukiY + nukiH), Offset(lx, lanternY - 7.0), Paint()..color = const Color(0xFF1C1917)..strokeWidth = 1.2);
      // Red oval lantern body
      final lRect = Rect.fromCenter(center: Offset(lx, lanternY), width: 14.0, height: 16.0);
      canvas.drawOval(lRect, Paint()..color = const Color(0xFFDC2626).withValues(alpha: opacity));
      // Golden glowing center band
      canvas.drawRect(Rect.fromCenter(center: Offset(lx, lanternY), width: 14.0, height: 5.0), Paint()..color = const Color(0xFFFEF08A).withValues(alpha: opacity * 0.9));
      // Black cap and base
      canvas.drawRect(Rect.fromCenter(center: Offset(lx, lanternY - 8.0), width: 8.0, height: 2.5), baseStonePaint);
      canvas.drawRect(Rect.fromCenter(center: Offset(lx, lanternY + 8.0), width: 8.0, height: 2.5), baseStonePaint);
      // Gold tassel
      canvas.drawLine(Offset(lx, lanternY + 9.0), Offset(lx, lanternY + 14.0), Paint()..color = const Color(0xFFF59E0B)..strokeWidth = 1.4);
    }

    // Bold Comic Outlines
    final borderPaint = Paint()
      ..color = const Color(0xFF1C1917).withValues(alpha: opacity * 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawRRect(rrect, borderPaint);
    canvas.drawPath(kasagiPath, borderPaint);
  }

  // 16. Bölüm 5: Shoji Kafesli Zen Katı (Shoji Floor)
  static void _drawShojiFloor(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4.0));

    // Dark polished cedar wood outer frame
    final cedarPaint = Paint()
      ..color = const Color(0xFF451A03).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, cedarPaint);

    // Three Shoji Screen Bays
    const bayCount = 3;
    final bayW = (rect.width - 24.0) / bayCount;
    final bayH = rect.height - 12.0;

    final paperPaint = Paint()
      ..color = const Color(0xFFFFFBEB).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    final gridPaint = Paint()
      ..color = const Color(0xFF78350F).withValues(alpha: opacity * 0.85)
      ..strokeWidth = 1.2;

    for (int b = 0; b < bayCount; b++) {
      final bx = rect.left + 6.0 + (b * (bayW + 6.0));
      final by = rect.top + 6.0;
      final bayRect = Rect.fromLTWH(bx, by, bayW, bayH);

      // Translucent rice paper background
      canvas.drawRRect(RRect.fromRectAndRadius(bayRect, const Radius.circular(3.0)), paperPaint);

      // Warm interior glowing center
      canvas.drawCircle(
        bayRect.center,
        bayH * 0.35,
        Paint()..color = const Color(0xFFFEF08A).withValues(alpha: opacity * 0.35),
      );

      // Shoji Wooden Kumiko Grid lines (vertical and horizontal lattice)
      const cols = 3;
      const rows = 4;
      for (int c = 1; c < cols; c++) {
        final gx = bx + (bayW * c / cols);
        canvas.drawLine(Offset(gx, by), Offset(gx, by + bayH), gridPaint);
      }
      for (int r = 1; r < rows; r++) {
        final gy = by + (bayH * r / rows);
        canvas.drawLine(Offset(bx, gy), Offset(bx + bayW, gy), gridPaint);
      }

      // Bay inner border
      canvas.drawRRect(
        RRect.fromRectAndRadius(bayRect, const Radius.circular(3.0)),
        Paint()
          ..color = const Color(0xFF451A03).withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8,
      );
    }

    // Vermilion corner braces & cedar floor runners
    final runnerPaint = Paint()
      ..color = const Color(0xFFDC2626).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(rect.left + 4, rect.bottom - 4, rect.width - 8, 3), runnerPaint);

    // Bold Outline
    final borderPaint = Paint()
      ..color = const Color(0xFF1C1917).withValues(alpha: opacity * 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawRRect(rrect, borderPaint);
  }

  // 17. Bölüm 5: Kıvrık Saçaklı Pagoda Çatısı (Pagoda Roof)
  static void _drawPagodaRoof(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    final roofW = rect.width;
    final roofH = rect.height;

    // Exposed under-eave timber brackets (Tokyō)
    final bracketH = roofH * 0.28;
    final bracketY = rect.bottom - bracketH;
    final bracketRect = Rect.fromLTWH(rect.left + 10.0, bracketY, roofW - 20.0, bracketH);
    canvas.drawRect(
      bracketRect,
      Paint()..color = const Color(0xFFDC2626).withValues(alpha: opacity),
    );

    // Bracket teeth
    for (int i = 0; i < 7; i++) {
      final bx = rect.left + 14.0 + (i * ((roofW - 28.0) / 6));
      canvas.drawRect(
        Rect.fromCenter(center: Offset(bx, bracketY + bracketH / 2), width: 5.0, height: bracketH - 2.0),
        Paint()..color = const Color(0xFF451A03).withValues(alpha: opacity),
      );
    }

    // Sweeping upturned roof path
    final roofPath = Path()
      ..moveTo(rect.left - 4.0, rect.bottom - 10.0)
      ..quadraticBezierTo(rect.left + roofW * 0.20, rect.bottom - 4.0, rect.center.dx, rect.bottom - 3.0)
      ..quadraticBezierTo(rect.right - roofW * 0.20, rect.bottom - 4.0, rect.right + 4.0, rect.bottom - 10.0)
      ..lineTo(rect.right - 6.0, rect.top + 2.0)
      ..quadraticBezierTo(rect.center.dx, rect.top - 1.0, rect.left + 6.0, rect.top + 2.0)
      ..close();

    // Glazed Imperial Jade Green Ceramic Tiles
    final tilePaint = Paint()
      ..color = const Color(0xFF047857).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawPath(roofPath, tilePaint);

    // Decorative vertical roof tile ribs (Kawara)
    final ribPaint = Paint()
      ..color = const Color(0xFF064E3B).withValues(alpha: opacity)
      ..strokeWidth = 2.0;
    const ribCount = 9;
    for (int i = 0; i < ribCount; i++) {
      final t = i / (ribCount - 1);
      final topX = (rect.left + 8.0) + (t * (roofW - 16.0));
      final btmX = (rect.left - 2.0) + (t * (roofW + 4.0));
      canvas.drawLine(Offset(topX, rect.top + 3.0), Offset(btmX, rect.bottom - 5.0), ribPaint);
    }

    // Golden Roof Ridge Caps (Onigawara) at corners
    final goldCorner = Paint()
      ..color = const Color(0xFFF59E0B).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    // Left upturned horn & hanging bronze bell
    canvas.drawCircle(Offset(rect.left - 4.0, rect.bottom - 10.0), 3.5, goldCorner);
    canvas.drawLine(Offset(rect.left - 4.0, rect.bottom - 7.0), Offset(rect.left - 4.0, rect.bottom - 2.0), Paint()..color = const Color(0xFF78350F)..strokeWidth = 1.2);
    canvas.drawCircle(Offset(rect.left - 4.0, rect.bottom), 2.2, Paint()..color = const Color(0xFFD97706));

    // Right upturned horn & hanging bronze bell
    canvas.drawCircle(Offset(rect.right + 4.0, rect.bottom - 10.0), 3.5, goldCorner);
    canvas.drawLine(Offset(rect.right + 4.0, rect.bottom - 7.0), Offset(rect.right + 4.0, rect.bottom - 2.0), Paint()..color = const Color(0xFF78350F)..strokeWidth = 1.2);
    canvas.drawCircle(Offset(rect.right + 4.0, rect.bottom), 2.2, Paint()..color = const Color(0xFFD97706));

    // Flat top ridge bar (ready for next tier to sit solidly on top)
    final ridgeBar = Rect.fromLTWH(rect.left + 6.0, rect.top, roofW - 12.0, 4.0);
    canvas.drawRRect(RRect.fromRectAndRadius(ridgeBar, const Radius.circular(2.0)), Paint()..color = const Color(0xFF1C1917).withValues(alpha: opacity));

    // Bold Outline
    final borderPaint = Paint()
      ..color = const Color(0xFF1C1917).withValues(alpha: opacity * 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawPath(roofPath, borderPaint);
  }

  // 18. Bölüm 5: Bronz Çanlı Tapınak Katı (Zen Belfry)
  static void _drawZenBelfry(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4.0));

    // Dark temple interior background
    final wallPaint = Paint()
      ..color = const Color(0xFF1C1917).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, wallPaint);

    // 4 Open Pavilion Columns in Vermilion
    const colW = 8.0;
    final colPaint = Paint()
      ..color = const Color(0xFFDC2626).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(rect.left + 4, rect.top, colW, rect.height), colPaint);
    canvas.drawRect(Rect.fromLTWH(rect.left + rect.width * 0.28, rect.top, colW, rect.height), colPaint);
    canvas.drawRect(Rect.fromLTWH(rect.right - rect.width * 0.28 - colW, rect.top, colW, rect.height), colPaint);
    canvas.drawRect(Rect.fromLTWH(rect.right - 4 - colW, rect.top, colW, rect.height), colPaint);

    // Large Antique Sacred Bronze Bell (Bonshō) in center
    final bellW = rect.width * 0.36;
    final bellH = rect.height * 0.68;
    final bellLeft = rect.center.dx - bellW / 2;
    final bellTop = rect.top + 10.0;

    final bellPath = Path()
      ..moveTo(bellLeft + 6.0, bellTop)
      ..lineTo(bellLeft + bellW - 6.0, bellTop)
      ..quadraticBezierTo(bellLeft + bellW, bellTop + bellH * 0.60, bellLeft + bellW + 2.0, bellTop + bellH)
      ..lineTo(bellLeft - 2.0, bellTop + bellH)
      ..quadraticBezierTo(bellLeft, bellTop + bellH * 0.60, bellLeft + 6.0, bellTop)
      ..close();

    final bronzePaint = Paint()
      ..color = const Color(0xFF78350F).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawPath(bellPath, bronzePaint);

    // Bronze Bell Patina / Lotus Bands
    final patinaPaint = Paint()
      ..color = const Color(0xFF059669).withValues(alpha: opacity * 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(bellLeft, bellTop + bellH * 0.35), Offset(bellLeft + bellW, bellTop + bellH * 0.35), patinaPaint);
    canvas.drawLine(Offset(bellLeft - 2, bellTop + bellH * 0.85), Offset(bellLeft + bellW + 2, bellTop + bellH * 0.85), patinaPaint);

    // Striking boss studs (Chichi) on bell
    final studPaint = Paint()..color = const Color(0xFFF59E0B).withValues(alpha: opacity);
    for (int i = 0; i < 4; i++) {
      final sx = bellLeft + 5.0 + (i * ((bellW - 10.0) / 3));
      canvas.drawCircle(Offset(sx, bellTop + bellH * 0.20), 1.8, studPaint);
    }

    // Bell hanger loop (Ryūzu dragon head loop)
    canvas.drawCircle(Offset(rect.center.dx, bellTop - 3.0), 4.5, Paint()..color = const Color(0xFFF59E0B).withValues(alpha: opacity));
    canvas.drawCircle(Offset(rect.center.dx, bellTop - 3.0), 2.2, Paint()..color = const Color(0xFF1C1917));

    // Wooden Balustrade Railing at bottom
    const railH = 8.0;
    final railRect = Rect.fromLTWH(rect.left + 2, rect.bottom - railH, rect.width - 4, railH);
    canvas.drawRect(railRect, Paint()..color = const Color(0xFF451A03).withValues(alpha: opacity));

    // Bold Outline
    final borderPaint = Paint()
      ..color = const Color(0xFF1C1917).withValues(alpha: opacity * 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawRRect(rrect, borderPaint);
    canvas.drawPath(bellPath, borderPaint..strokeWidth = 1.8);
  }

  // 19. Bölüm 5: Altın Sorin Tapınak Zirvesi (Sorin Spire)
  static void _drawSorinSpire(Canvas canvas, Rect rect, LevelTheme theme, double opacity) {
    // Pagoda base rooflet
    final baseH = rect.height * 0.22;
    final baseY = rect.bottom - baseH;
    final baseRect = Rect.fromLTWH(rect.left + 4.0, baseY, rect.width - 8.0, baseH);

    final jadePaint = Paint()
      ..color = const Color(0xFF047857).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(baseRect, const Radius.circular(3.0)), jadePaint);

    final spireApexX = rect.center.dx;
    final spireTopY = rect.top + 8.0;

    // Sacred Inverted Lotus Bowl (Fukubachi)
    final bowlY = baseY - 5.0;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(spireApexX, bowlY), width: 22.0, height: 10.0),
      Paint()..color = const Color(0xFFF59E0B).withValues(alpha: opacity),
    );

    // Central Sacred Gold Spire Shaft
    final shaftPaint = Paint()
      ..color = const Color(0xFFD97706).withValues(alpha: opacity)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(spireApexX, bowlY), Offset(spireApexX, spireTopY + 12.0), shaftPaint);

    // 9 Sacred Golden Rings (Kurin)
    const ringCount = 7;
    final ringsTopY = spireTopY + 18.0;
    final ringsHeight = bowlY - ringsTopY - 6.0;
    final ringGold = Paint()
      ..color = const Color(0xFFFDE047).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < ringCount; i++) {
      final t = i / (ringCount - 1);
      final ry = bowlY - 6.0 - (t * ringsHeight);
      final rW = 20.0 - (t * 8.0);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(spireApexX, ry), width: rW, height: 3.5),
          const Radius.circular(1.5),
        ),
        ringGold,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(spireApexX, ry), width: rW, height: 3.5),
          const Radius.circular(1.5),
        ),
        Paint()
          ..color = const Color(0xFF78350F).withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );
    }

    // Sacred Flaming Water Crest (Suien)
    final crestPath = Path()
      ..moveTo(spireApexX, ringsTopY)
      ..quadraticBezierTo(spireApexX - 9.0, ringsTopY - 5.0, spireApexX - 5.0, ringsTopY - 12.0)
      ..quadraticBezierTo(spireApexX - 2.0, ringsTopY - 7.0, spireApexX, ringsTopY - 6.0)
      ..quadraticBezierTo(spireApexX + 2.0, ringsTopY - 7.0, spireApexX + 5.0, ringsTopY - 12.0)
      ..quadraticBezierTo(spireApexX + 9.0, ringsTopY - 5.0, spireApexX, ringsTopY)
      ..close();
    canvas.drawPath(crestPath, ringGold);

    // Sacred Glowing Jewel Pearl (Hōju) at very top
    final pearlY = spireTopY;
    canvas.drawCircle(
      Offset(spireApexX, pearlY),
      7.0,
      Paint()..color = const Color(0xFFFEF08A).withValues(alpha: opacity * 0.5),
    );
    canvas.drawCircle(
      Offset(spireApexX, pearlY),
      4.5,
      Paint()..color = const Color(0xFFF59E0B).withValues(alpha: opacity),
    );
    canvas.drawCircle(
      Offset(spireApexX - 1.5, pearlY - 1.5),
      1.5,
      Paint()..color = Colors.white.withValues(alpha: opacity),
    );

    // Bold Outlines
    final borderPaint = Paint()
      ..color = const Color(0xFF1C1917).withValues(alpha: opacity * 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawRRect(RRect.fromRectAndRadius(baseRect, const Radius.circular(3.0)), borderPaint);
  }
}

