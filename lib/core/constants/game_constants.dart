import 'package:flame/extensions.dart';

class GameConstants {
  // World scale: 1 meter = 40 screen pixels
  static const double physicsScale = 40.0;

  // Viewport virtual world dimensions in meters
  static const double worldWidthMeters = 10.0;
  static const double worldHeightMeters = 18.0;

  // Crisp, solid gravity for predictable physics dropping
  static final Vector2 gravity = Vector2(0.0, 22.0);

  // Dropper height above highest tower point (keeps dropper comfortably close for accurate aiming)
  static const double dropperOffsetAboveTower = 4.2;
  static const double dropperMinY = 2.2;

  // Horizontal clamp for dropper (meters)
  static const double dropperMinX = 2.2;
  static const double dropperMaxX = 7.8;

  // Foundation platform (near bottom of the screen)
  static const double foundationWidth = 6.4;
  static const double foundationHeight = 1.4;
  static const double foundationY = 15.6; // center Y in meters
  static double get foundationTopY => foundationY - (foundationHeight / 2); // 14.9m

  // Ground death zone (if piece falls below this Y, it has fallen off the platform)
  static const double deathZoneY = 18.2;

  // Terminal velocity for a falling piece (m/s). A free fall from the dropper
  // would reach ~17 m/s, which hammers the tower on landing; real stacking
  // games lower the piece at a controlled speed instead.
  static const double maxFallSpeed = 8.0;

  // Safety margin for the centre-of-mass rule (meters). The load above a
  // course must sit at least this far inside the edges of what carries it.
  static const double centerOfMassMargin = 0.05;

  // Stability settle threshold
  static const double velocityThreshold = 0.20;
  static const double angularVelocityThreshold = 0.25;
  static const double stabilityHoldTimeSeconds = 1.8;

  // Max fallen pieces before game over
  static const int defaultMaxFallenPieces = 3;
}
