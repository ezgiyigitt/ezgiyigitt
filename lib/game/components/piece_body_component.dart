import 'dart:math' as math;

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import '../../core/constants/game_constants.dart';
import '../../models/level_theme.dart';
import '../../models/piece_data.dart';
import '../renderers/piece_painter.dart';

/// A single building piece.
///
/// A piece lives in one of two states:
///
///  * **Free** — it is falling or still shifting around. Ordinary rigid-body
///    physics applies: gravity, wind, collisions, tipping over.
///  * **Locked** — it has come to rest squarely on its support and has become
///    part of the building. It is turned into a static body, exactly like a
///    brick that has been mortared in place: it cannot jitter, creep or be
///    nudged by later pieces landing on it.
///
/// Locking is what real stacking games do (they weld the block to the one
/// below). Whether the building as a whole stays up is then decided by its
/// centre of mass, not by each brick wobbling on its own — see
/// `BrickUpGame._towerIsToppling`. If the building does topple, every piece is
/// unlocked again and real physics takes over for the collapse.
class PieceBodyComponent extends BodyComponent {
  final PieceDefinition piece;
  final LevelTheme theme;
  final Vector2 spawnPosition;
  final void Function(PieceBodyComponent component)? onFallenOff;

  double windForce = 0.0;
  bool _hasReportedFall = false;

  /// True once this piece has been mortared into the building.
  bool isLocked = false;

  PieceBodyComponent({
    required this.piece,
    required this.theme,
    required this.spawnPosition,
    this.onFallenOff,
  });

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: spawnPosition,
      type: BodyType.dynamic,
      // Real physics: an unbalanced piece tips over and falls.
      fixedRotation: false,
      linearDamping: 0.5,
      angularDamping: 0.6,
    );

    final Body body = world.createBody(bodyDef);
    final material = SurfaceMaterial(
      friction: piece.friction,
      restitution: piece.restitution,
    );
    final shapeDef = ShapeDef(
      density: piece.density,
      material: material,
    );

    if (piece.type == PieceType.roof) {
      final halfW = piece.width / 2;
      final halfH = piece.height / 2;
      final shape = Polygon([
        Vector2(0.0, -halfH),   // Apex
        Vector2(halfW, halfH),  // Bottom right
        Vector2(-halfW, halfH), // Bottom left
      ]);
      body.createShape(shape, shapeDef);
    } else if (piece.type == PieceType.dome) {
      final halfW = piece.width / 2;
      final halfH = piece.height / 2;
      final shape = Polygon([
        Vector2(0.0, -halfH),
        Vector2(halfW * 0.7, -halfH * 0.3),
        Vector2(halfW, halfH),
        Vector2(-halfW, halfH),
        Vector2(-halfW * 0.7, -halfH * 0.3),
      ]);
      body.createShape(shape, shapeDef);
    } else if (piece.type == PieceType.spire || piece.type == PieceType.sorinSpire) {
      final halfW = piece.width / 2;
      final halfH = piece.height / 2;
      final shape = Polygon([
        Vector2(0.0, -halfH),
        Vector2(halfW * 0.35, -halfH * 0.3),
        Vector2(halfW, halfH),
        Vector2(-halfW, halfH),
        Vector2(-halfW * 0.35, -halfH * 0.3),
      ]);
      body.createShape(shape, shapeDef);
    } else {
      final shape = Polygon.box(
        piece.width / 2,
        piece.height / 2,
      );
      body.createShape(shape, shapeDef);
    }

    return body;
  }

  /// Mortars this piece into the building. A static body has no velocity and is
  /// never moved by a collision, so the finished structure is perfectly still.
  void lock() {
    if (isLocked) return;
    isLocked = true;
    windForce = 0.0;
    body.type = BodyType.static;
  }

  /// Releases the piece back into free physics — used when the building topples.
  void unlock() {
    if (!isLocked) return;
    isLocked = false;
    body.type = BodyType.dynamic;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isLocked) return;

    // Terminal velocity. Without this a piece hits the tower at ~17 m/s, which
    // slams the structure and, on a slow frame, can even punch through a thin
    // beam. The impulse below cancels exactly the excess speed.
    final velocityY = body.linearVelocity.y;
    if (velocityY > GameConstants.maxFallSpeed) {
      body.applyLinearImpulse(
        Vector2(0.0, -(velocityY - GameConstants.maxFallSpeed) * body.mass),
      );
    }

    // Wind pushes the piece that is still in the air, never the building.
    if (windForce.abs() > 0.01) {
      final area = piece.width * piece.height;
      final totalForce = windForce * piece.windFactor * area;
      body.applyForce(Vector2(totalForce, 0.0));
    }

    // Check death zone (fallen off the platform past the ground)
    if (!_hasReportedFall && body.position.y > GameConstants.deathZoneY) {
      _hasReportedFall = true;
      onFallenOff?.call(this);
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    // Body local origin is (0, 0).
    // Convert to pixel space for crisp vector strokes and details.
    canvas.save();
    canvas.scale(1.0 / GameConstants.physicsScale, 1.0 / GameConstants.physicsScale);

    final pixelRect = Rect.fromCenter(
      center: Offset.zero,
      width: piece.width * GameConstants.physicsScale,
      height: piece.height * GameConstants.physicsScale,
    );

    PiecePainter.drawPiece(
      canvas: canvas,
      rect: pixelRect,
      type: piece.type,
      theme: theme,
    );

    canvas.restore();
  }

  /// Half extents of the piece's axis-aligned bounding box, taking the body's
  /// current rotation into account. Without this a tilted piece would still be
  /// measured as if it were perfectly upright.
  double get _halfWidthRotated {
    final c = math.cos(body.angle).abs();
    final s = math.sin(body.angle).abs();
    return (piece.width * c + piece.height * s) / 2;
  }

  double get _halfHeightRotated {
    final c = math.cos(body.angle).abs();
    final s = math.sin(body.angle).abs();
    return (piece.width * s + piece.height * c) / 2;
  }

  /// Current top Y coordinate in world space (smaller Y means higher)
  double get topY => body.position.y - _halfHeightRotated;

  /// Current bottom Y coordinate in world space (larger Y means lower)
  double get bottomY => body.position.y + _halfHeightRotated;

  /// Left edge in world space
  double get leftX => body.position.x - _halfWidthRotated;

  /// Right edge in world space
  double get rightX => body.position.x + _halfWidthRotated;

  /// Horizontal center in world space
  double get centerX => body.position.x;

  /// Weight of this piece, used for centre-of-mass arithmetic.
  double get mass => piece.width * piece.height * piece.density;

  /// Tilt away from upright, measured against the nearest right angle (degrees).
  double get tiltDegrees {
    final angleDeg = body.angle * 180 / math.pi;
    final normalized = angleDeg.abs() % 90.0;
    return math.min(normalized, 90.0 - normalized);
  }

  /// Check if the piece is at rest (settled)
  bool get isSettled {
    if (isLocked) return true;
    return body.linearVelocity.length < GameConstants.velocityThreshold &&
        body.angularVelocity.abs() < GameConstants.angularVelocityThreshold;
  }
}
