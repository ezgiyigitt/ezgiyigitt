import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import '../../core/constants/game_constants.dart';
import '../../models/level_theme.dart';

class FoundationComponent extends BodyComponent {
  final LevelTheme theme;

  FoundationComponent({required this.theme});

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: Vector2(
        GameConstants.worldWidthMeters / 2,
        GameConstants.foundationY,
      ),
      type: BodyType.static,
    );

    final shape = Polygon.box(
      GameConstants.foundationWidth / 2,
      GameConstants.foundationHeight / 2,
    );

    final shapeDef = ShapeDef(
      density: 10.0,
      material: SurfaceMaterial(
        friction: 0.9,
        restitution: 0.05,
      ),
    );

    return world.createBody(bodyDef)..createShape(shape, shapeDef);
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.scale(1.0 / GameConstants.physicsScale, 1.0 / GameConstants.physicsScale);

    final totalWidthPx = GameConstants.foundationWidth * GameConstants.physicsScale;
    final totalHeightPx = GameConstants.foundationHeight * GameConstants.physicsScale;
    final halfW = totalWidthPx / 2;
    final halfH = totalHeightPx / 2;
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: totalWidthPx,
      height: totalHeightPx,
    );

    // Stone base foundation fill
    final basePaint = Paint()
      ..color = theme.groundColor
      ..style = PaintingStyle.fill;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8.0));
    canvas.drawRRect(rrect, basePaint);

    // Stone block masonry joints (ashlar pattern)
    final jointPaint = Paint()
      ..color = theme.groundAccent
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;

    final midY = 0.0;
    canvas.drawLine(Offset(-halfW, midY), Offset(halfW, midY), jointPaint);

    // Top row vertical stone cuts
    canvas.drawLine(Offset(-halfW * 0.5, -halfH), Offset(-halfW * 0.5, midY), jointPaint);
    canvas.drawLine(Offset(halfW * 0.2, -halfH), Offset(halfW * 0.2, midY), jointPaint);

    // Bottom row vertical stone cuts
    canvas.drawLine(Offset(-halfW * 0.1, midY), Offset(-halfW * 0.1, halfH), jointPaint);
    canvas.drawLine(Offset(halfW * 0.6, midY), Offset(halfW * 0.6, halfH), jointPaint);

    // Top stone slab highlight
    final topSlabPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(-halfW, -halfH + 2.0), Offset(halfW, -halfH + 2.0), topSlabPaint);

    // Bold Cartoon Outline
    final borderPaint = Paint()
      ..color = const Color(0xFF212121).withValues(alpha: 0.9)
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(rrect, borderPaint);

    canvas.restore();
  }
}
