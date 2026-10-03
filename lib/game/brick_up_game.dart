import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../core/constants/game_constants.dart';
import '../models/level_data.dart';
import '../viewmodels/game_viewmodel.dart';
import 'components/dropper_component.dart';
import 'components/foundation_component.dart';
import 'components/piece_body_component.dart';
import 'components/wind_particles.dart';

class BrickUpGame extends Forge2DGame {
  final GameViewModel viewModel;

  late FoundationComponent _foundation;
  late DropperComponent _dropper;
  late WindParticlesComponent _windParticles;

  double _windTimer = 0.0;
  double _currentWindStrength = 0.0;

  BrickUpGame({required this.viewModel})
    : super(gravity: GameConstants.gravity);

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _resetCamera();
    _setupWorldComponents();

    viewModel.onDropRequested = _handleDrop;
    viewModel.onRestartRequested = _handleRestart;
  }

  /// Camera setup: centered horizontally, fitting the full 10m x 18m world.
  ///
  /// The scale is driven by [Viewfinder.visibleGameSize] — never by setting
  /// `zoom` by hand. Writing `zoom` directly fights the visible-game-size
  /// setting and changes how big the world looks.
  void _resetCamera() {
    camera.viewfinder.anchor = Anchor.topCenter;
    camera.viewfinder.position = Vector2(
      GameConstants.worldWidthMeters / 2,
      0.0,
    );
    camera.viewfinder.visibleGameSize = Vector2(
      GameConstants.worldWidthMeters,
      GameConstants.worldHeightMeters,
    );
  }

  void _setupWorldComponents() {
    _foundation = FoundationComponent(theme: viewModel.currentLevel.theme);
    world.add(_foundation);

    _windParticles = WindParticlesComponent(viewModel: viewModel);
    world.add(_windParticles);

    _dropper = DropperComponent(viewModel: viewModel);
    world.add(_dropper);
  }

  void _handleDrop() {
    final activePiece = viewModel.activePiece;
    final theme = viewModel.currentLevel.theme;
    // Spawn exactly where the dropper is aiming
    final spawnPos = Vector2(viewModel.dropperX, _dropper.position.y);

    final pieceBody = PieceBodyComponent(
      piece: activePiece,
      theme: theme,
      spawnPosition: spawnPos,
      onFallenOff: (component) {
        viewModel.onPieceFallenOff();
      },
    );

    // Apply gentle wind force
    pieceBody.windForce = _currentWindStrength;
    world.add(pieceBody);

    // Tell ViewModel to prepare next piece in recipe
    viewModel.onPieceSpawnedAfterDrop();
  }

  void _handleRestart() {
    final pieces = world.children.whereType<PieceBodyComponent>().toList();
    for (final p in pieces) {
      p.removeFromParent();
    }

    _restTimers.clear();
    _isCollapsing = false;
    _collapseTimer = 0.0;
    _resetCamera();

    _foundation.removeFromParent();
    _dropper.removeFromParent();
    _windParticles.removeFromParent();
    _setupWorldComponents();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 1. Wind System Simulation
    _updateWind(dt);

    // 2. Tower Height and Stability Tracking
    _updateTowerMetrics(dt);

    // 3. Smooth Camera Tracking
    _updateCameraTracking(dt);
  }

  void _updateWind(double dt) {
    _windTimer += dt;
    final windConfig = viewModel.currentLevel.wind;

    if (windConfig.baseStrength <= 0.0) {
      _currentWindStrength = 0.0;
      viewModel.updateWind(0.0, WindDirection.none);
      return;
    }

    // Gentle base wind + subtle gust wave
    final gustCycle = sin(_windTimer * (2 * pi / windConfig.gustPeriodSeconds));
    final gustFactor = gustCycle > 0
        ? (1.0 + gustCycle * (windConfig.gustMultiplier - 1.0))
        : 1.0;
    _currentWindStrength =
        windConfig.baseStrength * windConfig.direction.sign * gustFactor;

    // Wind only pushes pieces that are still in the air. Once a piece has come
    // to rest it is part of the building, and a finished building must not
    // creep sideways on its own.
    final pieces = world.children.whereType<PieceBodyComponent>();
    for (final p in pieces) {
      p.windForce = p.isSettled ? 0.0 : _currentWindStrength;
    }

    viewModel.updateWind(_currentWindStrength.abs(), windConfig.direction);
  }

  /// Once a piece has rested this long, it is mortared into the building.
  static const double _lockDelay = 0.35;

  /// How long the collapse animation plays before the result screen appears.
  static const double _collapseShowTime = 1.3;

  final Map<PieceBodyComponent, double> _restTimers = {};
  bool _isCollapsing = false;
  double _collapseTimer = 0.0;

  void _updateTowerMetrics(double dt) {
    final pieces = world.children.whereType<PieceBodyComponent>().toList();

    // While the building is coming down, physics is left alone to do its work;
    // the verdict follows once the player has seen it fall.
    if (_isCollapsing) {
      _collapseTimer += dt;
      if (_collapseTimer >= _collapseShowTime) {
        _isCollapsing = false;
        viewModel.onTowerCollapsed();
      }
      return;
    }

    if (pieces.isEmpty) {
      _restTimers.clear();
      viewModel.updateHeight(
        0.0,
        true,
        allAligned: false,
        piecesOnTower: 0,
        dt: dt,
      );
      _dropper.highestTowerY = GameConstants.foundationTopY;
      return;
    }

    const foundationLeft =
        GameConstants.worldWidthMeters / 2 - GameConstants.foundationWidth / 2;
    const foundationRight =
        GameConstants.worldWidthMeters / 2 + GameConstants.foundationWidth / 2;

    double highestY = GameConstants.foundationTopY;
    bool allSettled = true;
    for (final p in pieces) {
      if (p.topY < highestY) highestY = p.topY;
      if (!p.isSettled) allSettled = false;
    }

    // 1. Mortar in any piece that has come to rest on a proper support.
    _updateLocking(pieces, dt, foundationLeft, foundationRight);

    final built = pieces.where((p) => p.isLocked).toList();

    // 2. THE ONE PHYSICAL RULE: the weight carried by each course must sit
    // inside that course. If it does not, the building comes down.
    if (built.length >= 2 &&
        _towerIsToppling(built, foundationLeft, foundationRight)) {
      _startCollapse(pieces);
      return;
    }

    // 3. Standing: every piece of the building is mortared in, i.e. genuinely
    // carried by what is under it. This is what decides the round.
    final allLocked = built.length == pieces.length;

    // 4. Tidiness: squarely laid courses. This only earns a bonus — a slightly
    // rough building that stands is still a finished building.
    final allAligned = allLocked &&
        pieces.every((p) => _isPieceTidy(p, pieces, foundationLeft, foundationRight));

    final currentHeightMeters =
        max(0.0, GameConstants.foundationTopY - highestY);
    viewModel.updateHeight(
      currentHeightMeters,
      allSettled,
      allAligned: allAligned,
      allLocked: allLocked,
      piecesOnTower: pieces.length,
      dt: dt,
    );
    _dropper.highestTowerY = highestY;
  }

  /// A piece becomes part of the building once it has held still for a moment
  /// AND its own centre of mass is over the thing it is standing on. A piece
  /// hanging off the edge is never mortared in — free physics tips it off by
  /// itself, exactly as it would in the real world.
  void _updateLocking(
    List<PieceBodyComponent> pieces,
    double dt,
    double foundationLeft,
    double foundationRight,
  ) {
    _restTimers.removeWhere((p, _) => p.isLocked || !pieces.contains(p));

    for (final p in pieces) {
      if (p.isLocked) continue;

      final support = _findSupport(p, pieces, foundationLeft, foundationRight);
      final standsUp = support != null &&
          p.centerX > support.left + GameConstants.centerOfMassMargin &&
          p.centerX < support.right - GameConstants.centerOfMassMargin &&
          p.tiltDegrees < 20.0;

      if (p.isSettled && standsUp) {
        final held = (_restTimers[p] ?? 0.0) + dt;
        if (held >= _lockDelay) {
          _restTimers.remove(p);
          p.lock();
        } else {
          _restTimers[p] = held;
        }
      } else {
        _restTimers.remove(p);
      }
    }
  }

  /// Statics, the way a mason would check it: walk down the building and, at
  /// every course, work out the combined centre of mass of everything resting
  /// on it. If that point falls outside the course underneath, the load above
  /// has nothing holding it up and the whole stack goes over — not one brick.
  bool _towerIsToppling(
    List<PieceBodyComponent> built,
    double foundationLeft,
    double foundationRight,
  ) {
    // Highest piece first.
    final ordered = [...built]
      ..sort((a, b) => a.body.position.y.compareTo(b.body.position.y));

    double massAbove = 0.0;
    double momentAbove = 0.0;
    const margin = GameConstants.centerOfMassMargin;

    for (final course in ordered) {
      if (massAbove > 0.0) {
        final comX = momentAbove / massAbove;
        if (comX < course.leftX + margin || comX > course.rightX - margin) {
          return true;
        }
      }
      massAbove += course.mass;
      momentAbove += course.mass * course.centerX;
    }

    // Finally the whole building against the foundation slab.
    if (massAbove > 0.0) {
      final comX = momentAbove / massAbove;
      if (comX < foundationLeft + margin || comX > foundationRight - margin) {
        return true;
      }
    }

    return false;
  }

  /// Releases every piece back into free physics and lets the building fall.
  void _startCollapse(List<PieceBodyComponent> pieces) {
    _isCollapsing = true;
    _collapseTimer = 0.0;
    _restTimers.clear();
    for (final p in pieces) {
      p.unlock();
    }
    viewModel.onCollapseStarted();
  }

  /// Vertical gap tolerance when deciding whether a piece rests on a support (meters).
  static const double _supportGapTolerance = 0.35;

  /// A piece should hang over its support by roughly the same amount on the
  /// left as on the right. This is a "looks neat" test, not a precision one —
  /// half a metre of difference still reads as a tidy course (meters).
  static const double _symmetryTolerance = 0.50;

  /// How far a course may drift from the foundation's center before the
  /// building starts to look like a staircase rather than a tower (meters).
  static const double _globalCenterTolerance = 0.75;

  /// Minimum share of a piece's width that should overlap its support.
  static const double _minOverlapRatio = 0.60;

  /// Maximum tilt of a tidy piece (degrees).
  static const double _maxTidyTilt = 10.0;

  /// Finds the surface a piece is resting on, or null when it rests on nothing.
  _Support? _findSupport(
    PieceBodyComponent p,
    List<PieceBodyComponent> pieces,
    double foundationLeft,
    double foundationRight,
  ) {
    final pBottom = p.bottomY;
    final pLeft = p.leftX;
    final pRight = p.rightX;

    double? supportLeft;
    double? supportRight;
    double bestSupportTop = double.infinity;

    // Candidate 1: the foundation platform.
    final foundationTop = GameConstants.foundationTopY;
    if (foundationTop >= pBottom - _supportGapTolerance &&
        foundationTop <= pBottom + _supportGapTolerance &&
        pRight > foundationLeft &&
        pLeft < foundationRight) {
      bestSupportTop = foundationTop;
      supportLeft = foundationLeft;
      supportRight = foundationRight;
    }

    // Candidate 2: any other piece whose top surface meets this piece's bottom.
    for (final q in pieces) {
      if (identical(q, p)) continue;
      final qTop = q.topY;
      if (qTop < pBottom - _supportGapTolerance) continue;
      if (qTop > pBottom + _supportGapTolerance) continue;
      if (q.rightX <= pLeft || q.leftX >= pRight) continue;

      if (qTop < bestSupportTop) {
        bestSupportTop = qTop;
        supportLeft = q.leftX;
        supportRight = q.rightX;
      }
    }

    if (supportLeft == null || supportRight == null) return null;
    return _Support(supportLeft, supportRight);
  }

  /// Is this piece laid tidily enough for the build to count as a win? Failing
  /// this never destroys anything — the building simply is not a clean one.
  bool _isPieceTidy(
    PieceBodyComponent p,
    List<PieceBodyComponent> pieces,
    double foundationLeft,
    double foundationRight,
  ) {
    final support = _findSupport(p, pieces, foundationLeft, foundationRight);
    if (support == null) return false;

    // The same amount hanging over on each side.
    final leftGap = p.leftX - support.left;
    final rightGap = support.right - p.rightX;
    if ((leftGap - rightGap).abs() > _symmetryTolerance) return false;

    // Actually resting on it, not clipping a corner.
    final overlap = min(p.rightX, support.right) - max(p.leftX, support.left);
    final span = min(p.piece.width, support.width);
    if (overlap < span * _minOverlapRatio) return false;

    // Flat, not slanted.
    if (p.tiltDegrees > _maxTidyTilt) return false;

    // And the building must not wander off to one side like a staircase.
    const foundationCenterX = GameConstants.worldWidthMeters / 2;
    if ((p.centerX - foundationCenterX).abs() > _globalCenterTolerance) {
      return false;
    }

    return true;
  }

  void _updateCameraTracking(double dt) {
    final towerHeight = viewModel.currentHeight;
    double targetCameraY = 0.0;
    if (towerHeight > 5.0) {
      targetCameraY = -(towerHeight - 5.0);
    }

    final currentCamY = camera.viewfinder.position.y;
    final smoothCamY = currentCamY + (targetCameraY - currentCamY) * (dt * 2.5);
    camera.viewfinder.position = Vector2(GameConstants.worldWidthMeters / 2, smoothCamY);
  }

  @override
  void render(Canvas canvas) {
    final theme = viewModel.currentLevel.theme;
    final size = canvasSize;

    // 1. Vivid Cartoon Sky Gradient
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [theme.skyGradientTop, theme.skyGradientBottom],
      ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), bgPaint);

    // 2. Rolling Cartoon Hills
    final hillPaint = Paint()
      ..color = theme.hillColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    final hillPath = Path()
      ..moveTo(0, size.y * 0.72)
      ..quadraticBezierTo(
        size.x * 0.3,
        size.y * 0.65,
        size.x * 0.65,
        size.y * 0.74,
      )
      ..quadraticBezierTo(size.x * 0.85, size.y * 0.78, size.x, size.y * 0.70)
      ..lineTo(size.x, size.y)
      ..lineTo(0, size.y)
      ..close();
    canvas.drawPath(hillPath, hillPaint);

    final foreHillPaint = Paint()
      ..color = theme.hillColor
      ..style = PaintingStyle.fill;
    final foreHillPath = Path()
      ..moveTo(0, size.y * 0.82)
      ..quadraticBezierTo(
        size.x * 0.4,
        size.y * 0.76,
        size.x * 0.75,
        size.y * 0.84,
      )
      ..quadraticBezierTo(size.x * 0.9, size.y * 0.86, size.x, size.y * 0.80)
      ..lineTo(size.x, size.y)
      ..lineTo(0, size.y)
      ..close();
    canvas.drawPath(foreHillPath, foreHillPaint);

    super.render(canvas);
  }
}

/// The horizontal span of whatever a piece is resting on.
class _Support {
  final double left;
  final double right;

  const _Support(this.left, this.right);

  double get width => right - left;
}
