import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../core/constants/game_constants.dart';
import '../../viewmodels/game_viewmodel.dart';

class _WindParticle {
  double x;
  double y;
  double speed;
  double size;
  double angle;
  Color color;

  _WindParticle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.angle,
    required this.color,
  });
}

class WindParticlesComponent extends Component {
  final GameViewModel viewModel;
  final List<_WindParticle> _particles = [];
  final Random _random = Random();

  WindParticlesComponent({required this.viewModel}) {
    // Generate 18 subtle particles (leaves & breeze wisps)
    for (int i = 0; i < 18; i++) {
      _particles.add(_createRandomParticle());
    }
  }

  _WindParticle _createRandomParticle() {
    final isLeaf = _random.nextBool();
    return _WindParticle(
      x: _random.nextDouble() * GameConstants.worldWidthMeters,
      y: _random.nextDouble() * (GameConstants.worldHeightMeters - 2.0) + 1.0,
      speed: _random.nextDouble() * 2.0 + 1.5,
      size: isLeaf ? (_random.nextDouble() * 0.25 + 0.15) : (_random.nextDouble() * 0.4 + 0.3),
      angle: _random.nextDouble() * pi,
      color: isLeaf
          ? (_random.nextBool() ? const Color(0xFFC07D3E) : const Color(0xFF8D6E63))
          : Colors.white.withValues(alpha: 0.35),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    final dirSign = viewModel.windDirection.sign;
    final windVelocity = dirSign * (viewModel.windSpeed * 0.45);

    for (final p in _particles) {
      p.x += (windVelocity * p.speed) * dt;
      p.y += sin(p.x * 0.8) * 0.2 * dt; // gentle floating wave
      p.angle += dt * 2.0;

      // Wrap around world borders
      if (dirSign >= 0 && p.x > GameConstants.worldWidthMeters + 1.0) {
        p.x = -1.0;
        p.y = _random.nextDouble() * (GameConstants.worldHeightMeters - 2.0) + 1.0;
      } else if (dirSign < 0 && p.x < -1.0) {
        p.x = GameConstants.worldWidthMeters + 1.0;
        p.y = _random.nextDouble() * (GameConstants.worldHeightMeters - 2.0) + 1.0;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.scale(1.0 / GameConstants.physicsScale, 1.0 / GameConstants.physicsScale);

    for (final p in _particles) {
      final centerPx = Offset(
        p.x * GameConstants.physicsScale,
        p.y * GameConstants.physicsScale,
      );
      final sizePx = p.size * GameConstants.physicsScale;

      final paint = Paint()
        ..color = p.color
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(centerPx.dx, centerPx.dy);
      canvas.rotate(p.angle);

      // Draw oval leaf or wind stream
      final ovalRect = Rect.fromCenter(center: Offset.zero, width: sizePx * 1.6, height: sizePx * 0.7);
      canvas.drawOval(ovalRect, paint);

      canvas.restore();
    }

    canvas.restore();
  }
}
