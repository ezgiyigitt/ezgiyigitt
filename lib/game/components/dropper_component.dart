import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../core/constants/game_constants.dart';
import '../../viewmodels/game_viewmodel.dart';
import '../brick_up_game.dart';
import '../renderers/piece_painter.dart';

class DropperComponent extends PositionComponent with HasGameReference<BrickUpGame> {
  final GameViewModel viewModel;
  double highestTowerY = GameConstants.foundationTopY;
  double dropperTargetY = 3.2;
  double _oscillationTime = 0.0;

  DropperComponent({required this.viewModel}) {
    anchor = Anchor.center;
    position = Vector2(viewModel.dropperX, 3.2);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Keep dropper high up in the sky relative to camera
    final cameraTopY = game.camera.viewfinder.position.y;
    dropperTargetY = cameraTopY + 3.2;

    // Automatic smooth horizontal sliding (Tower Bloxx / BuildUp mechanic)
    if (viewModel.status == GameStatus.aiming) {
      _oscillationTime += dt;
      // Speed scales nicely with level difficulty
      final speed = 1.9 + (viewModel.currentLevel.id * 0.35);
      const center = GameConstants.worldWidthMeters / 2; // 5.0m
      const amplitude = 2.4; // Glides smoothly between 2.6m and 7.4m

      final targetX = center + sin(_oscillationTime * speed) * amplitude;
      viewModel.updateDropperX(targetX);
    }

    // Smooth horizontal & vertical positioning
    position.x = viewModel.dropperX;
    position.y += (dropperTargetY - position.y) * (dt * 6.0);
  }

  @override
  void render(Canvas canvas) {
    if (viewModel.status != GameStatus.aiming) return;

    final piece = viewModel.activePiece;
    final theme = viewModel.currentLevel.theme;

    canvas.save();
    canvas.scale(1.0 / GameConstants.physicsScale, 1.0 / GameConstants.physicsScale);

    final pieceW = piece.width * GameConstants.physicsScale;
    final pieceH = piece.height * GameConstants.physicsScale;
    final halfH = pieceH / 2;

    final distanceWorld = (highestTowerY - position.y).clamp(0.0, 25.0);
    final landingYPx = distanceWorld * GameConstants.physicsScale;

    // 1. Subtle, lightweight dashed drop guideline (NO bulky solid beam)
    final laserPaint = Paint()
      ..color = const Color(0x77FF9800)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    const dashLength = 8.0;
    const dashSpace = 8.0;
    double currentY = halfH + 4.0;

    while (currentY < landingYPx - 6.0) {
      final nextY = (currentY + dashLength).clamp(halfH, landingYPx - 6.0);
      canvas.drawLine(Offset(0, currentY), Offset(0, nextY), laserPaint);
      currentY += dashLength + dashSpace;
    }

    // 2. Crisp Landing Target Outline on the surface
    final landingRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(0, landingYPx), width: pieceW, height: 10.0),
      const Radius.circular(3.0),
    );
    final targetFill = Paint()
      ..color = const Color(0x33FF9800)
      ..style = PaintingStyle.fill;
    final targetOutline = Paint()
      ..color = const Color(0xAAFF9800)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(landingRRect, targetFill);
    canvas.drawRRect(landingRRect, targetOutline);

    // 3. Draw the piece high in the sky (Clean, no tags, no arrows, no ropes)
    final pixelRect = Rect.fromCenter(
      center: Offset.zero,
      width: pieceW,
      height: pieceH,
    );

    PiecePainter.drawPiece(
      canvas: canvas,
      rect: pixelRect,
      type: piece.type,
      theme: theme,
    );

    canvas.restore();
  }
}
