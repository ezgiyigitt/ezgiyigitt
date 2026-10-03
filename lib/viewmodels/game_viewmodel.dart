import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/constants/game_constants.dart';
import '../models/level_data.dart';
import '../models/piece_data.dart';

enum AppScreen { home, howToPlay, levelSelect, playing }

enum GameStatus { ready, aiming, dropping, settling, victory, gameOver }

class GameViewModel extends ChangeNotifier {
  AppScreen _currentScreen = AppScreen.home;
  LevelDefinition _currentLevel = LevelDefinition.level1;
  GameStatus _status = GameStatus.ready;

  double _currentHeight = 0.0;
  double _stabilityTimer = 0.0;
  double _misalignedTimer = 0.0;
  double _verdictTimer = 0.0;
  bool _isStable = true;
  bool _isAligned = true;
  String _failureReason = '';
  bool _isCollapsing = false;
  bool _tidyBuild = false;

  int _score = 0;
  int _droppedCount = 0;
  int _fallenCount = 0;

  double _dropperX = GameConstants.worldWidthMeters / 2;
  double _windSpeed = 0.0;
  WindDirection _windDirection = WindDirection.none;

  late PieceDefinition _activePiece;
  PieceDefinition? _nextPiece;
  final List<PieceType> _queue = [];

  final Set<int> _unlockedLevels = {1, 2, 3};

  VoidCallback? onDropRequested;
  VoidCallback? onRestartRequested;

  GameViewModel() {
    _initLevel(LevelDefinition.level1);
  }

  // Getters
  AppScreen get currentScreen => _currentScreen;
  LevelDefinition get currentLevel => _currentLevel;
  GameStatus get status => _status;
  double get currentHeight => _currentHeight;
  double get targetHeight => _currentLevel.targetHeight;
  double get heightProgress =>
      (_droppedCount / _currentLevel.requiredPieces.length).clamp(0.0, 1.0);
  double get stabilityTimer => _stabilityTimer;
  bool get isStable => _isStable;
  bool get isAligned => _isAligned;

  /// True when the winning build was also a tidy one (bonus awarded).
  bool get isTidyBuild => _tidyBuild;

  /// Why the round was lost, shown on the game over screen.
  String get failureReason => _failureReason.isNotEmpty
      ? _failureReason
      : 'Too many pieces ($_fallenCount) fell off the platform.';
  int get score => _score;
  int get droppedCount => _droppedCount;
  int get totalPieces => _currentLevel.requiredPieces.length;
  int get fallenCount => _fallenCount;
  int get maxAllowedFallen => _currentLevel.maxFallenPieces;
  double get dropperX => _dropperX;
  double get windSpeed => _windSpeed;
  WindDirection get windDirection => _windDirection;
  PieceDefinition get activePiece => _activePiece;
  PieceDefinition? get nextPiece => _nextPiece;
  bool get isAllPiecesPlaced =>
      _droppedCount >= _currentLevel.requiredPieces.length;
  bool isLevelUnlocked(int id) => _unlockedLevels.contains(id);

  // Navigation methods
  void goToHome() {
    _currentScreen = AppScreen.home;
    notifyListeners();
  }

  void openHowToPlay() {
    _currentScreen = AppScreen.howToPlay;
    notifyListeners();
  }

  void closeHowToPlay() {
    _currentScreen = AppScreen.home;
    notifyListeners();
  }

  void openLevelSelect() {
    _currentScreen = AppScreen.levelSelect;
    notifyListeners();
  }

  void startLevel(int levelId) {
    _initLevel(LevelDefinition.getLevel(levelId));
    _currentScreen = AppScreen.playing;
    notifyListeners();
    onRestartRequested?.call();
  }

  void _initLevel(LevelDefinition level) {
    _currentLevel = level;
    _status = GameStatus.aiming;
    _currentHeight = 0.0;
    _stabilityTimer = 0.0;
    _misalignedTimer = 0.0;
    _verdictTimer = 0.0;
    _isStable = true;
    _isAligned = true;
    _failureReason = '';
    _isCollapsing = false;
    _tidyBuild = false;
    _score = 0;
    _droppedCount = 0;
    _fallenCount = 0;
    _dropperX = GameConstants.worldWidthMeters / 2;

    _windSpeed = level.wind.baseStrength;
    _windDirection = level.wind.direction;

    // Load the exact architectural construction recipe
    _queue.clear();
    _queue.addAll(level.requiredPieces);

    _activePiece = PieceDefinition.byType(_queue.removeAt(0));
    _nextPiece = _queue.isNotEmpty
        ? PieceDefinition.byType(_queue.first)
        : null;

    if (level.blueprint.isNotEmpty) {
      final bpItem = level.blueprint.first;
      _dropperX =
          ((GameConstants.worldWidthMeters / 2) +
                  (bpItem.xOffset * GameConstants.foundationWidth))
              .clamp(GameConstants.dropperMinX, GameConstants.dropperMaxX);
    } else {
      _dropperX = GameConstants.worldWidthMeters / 2;
    }

    notifyListeners();
  }

  void setDropperX(double x) {
    if (_status != GameStatus.aiming) return;
    _dropperX = x.clamp(GameConstants.dropperMinX, GameConstants.dropperMaxX);
    notifyListeners();
  }

  void updateDropperX(double x) {
    if (_status != GameStatus.aiming) return;
    _dropperX = x.clamp(GameConstants.dropperMinX, GameConstants.dropperMaxX);
  }

  void moveDropper(double deltaMeters) {
    if (_status != GameStatus.aiming) return;
    _dropperX = (_dropperX + deltaMeters).clamp(
      GameConstants.dropperMinX,
      GameConstants.dropperMaxX,
    );
    notifyListeners();
  }

  void requestDrop() {
    if (_status != GameStatus.aiming) return;
    _status = GameStatus.dropping;
    _droppedCount++;
    notifyListeners();
    onDropRequested?.call();
  }

  void onPieceSpawnedAfterDrop() {
    if (_queue.isNotEmpty) {
      final nextIndex = _droppedCount;
      _activePiece = PieceDefinition.byType(_queue.removeAt(0));
      _nextPiece = _queue.isNotEmpty
          ? PieceDefinition.byType(_queue.first)
          : null;

      // Align dropper to recommended blueprint slot for this architectural piece
      if (nextIndex < _currentLevel.blueprint.length) {
        final bpItem = _currentLevel.blueprint[nextIndex];
        _dropperX =
            ((GameConstants.worldWidthMeters / 2) +
                    (bpItem.xOffset * GameConstants.foundationWidth))
                .clamp(GameConstants.dropperMinX, GameConstants.dropperMaxX);
      }

      if (_status != GameStatus.victory && _status != GameStatus.gameOver) {
        _status = GameStatus.aiming;
      }
    } else {
      // All pieces in recipe dropped (last was the Roof)
      _nextPiece = null;
      _status = GameStatus.settling;
    }
    notifyListeners();
  }

  /// How long after the last piece is dropped the round must reach a verdict.
  static const double _verdictDeadlineSeconds = 5.0;

  void updateHeight(
    double heightMeters,
    bool allSettled, {
    bool allAligned = true,
    bool allLocked = false,
    int piecesOnTower = 0,
    double dt = 1 / 60,
  }) {
    if (_status == GameStatus.victory || _status == GameStatus.gameOver) return;

    _currentHeight = max(0.0, heightMeters);
    _isAligned = allAligned;
    // The tower only counts as stable when nothing is moving AND every piece is
    // squarely centred on its support.
    _isStable = allSettled && allAligned;

    // The build is only complete when every piece of the recipe is still
    // standing on the tower — a piece that fell or toppled off leaves a hole.
    final buildComplete = piecesOnTower >= totalPieces;

    _score = (_currentHeight * 150).toInt() + (_droppedCount * 50);

    // Nothing is decided until the whole recipe has been dropped.
    if (!isAllPiecesPlaced) {
      _stabilityTimer = 0.0;
      _misalignedTimer = 0.0;
      _verdictTimer = 0.0;
      notifyListeners();
      return;
    }

    // The round is now in its final phase: from here it always ends in a
    // verdict — win or lose — and never just hangs.
    _verdictTimer += dt;

    // WIN: the building is standing. Every piece of the recipe is still up
    // there and every one of them is mortared into place, which means each is
    // genuinely carried by what is underneath it. Whether it is a tidy build
    // or a slightly rough one only changes the score.
    if (buildComplete && allLocked) {
      _misalignedTimer = 0.0;
      _stabilityTimer += dt;
      if (_stabilityTimer >= 1.0) {
        _declareVictory(tidy: allAligned);
      }
      notifyListeners();
      return;
    }

    _stabilityTimer = 0.0;

    // LOSE: everything has come to rest, but pieces are missing or one is
    // resting on nothing — and there is nothing left in the queue to fix it.
    if (allSettled) {
      _misalignedTimer += dt;
      if (_misalignedTimer >= 1.2) {
        _declareDefeat(buildComplete, piecesOnTower);
      }
    } else {
      // Still moving — wait and see where it ends up.
      _misalignedTimer = 0.0;
    }

    // Hard deadline: if the tower never fully comes to rest (endless wobble,
    // a piece spinning forever, wind nudging things), the round is still
    // decided so the player always gets a result screen.
    if (_status != GameStatus.victory &&
        _status != GameStatus.gameOver &&
        _verdictTimer >= _verdictDeadlineSeconds) {
      if (buildComplete && allLocked) {
        _declareVictory(tidy: allAligned);
      } else {
        _declareDefeat(buildComplete, piecesOnTower);
      }
    }

    notifyListeners();
  }

  /// [tidy] means every course sat squarely on the one below — worth a bonus,
  /// but never a requirement for finishing the level.
  void _declareVictory({required bool tidy}) {
    _status = GameStatus.victory;
    _score += 1500;
    if (tidy) {
      _score += 750;
      _tidyBuild = true;
    }
    _unlockedLevels.add(_currentLevel.id + 1);
  }

  void _declareDefeat(bool buildComplete, int piecesOnTower) {
    final missing = totalPieces - piecesOnTower;
    _failureReason = buildComplete
        ? 'A piece never found solid footing, so the building could not stand.'
        : 'The building is incomplete: $missing piece(s) fell off the tower.';
    _status = GameStatus.gameOver;
  }

  /// The building's centre of mass left its base and it is coming down. The
  /// verdict waits until the player has watched it fall.
  void onCollapseStarted() {
    if (_status == GameStatus.victory || _status == GameStatus.gameOver) return;
    _isCollapsing = true;
    _status = GameStatus.settling;
    _isStable = false;
    _isAligned = false;
    notifyListeners();
  }

  /// Called once the collapse has played out.
  void onTowerCollapsed() {
    if (_status == GameStatus.victory || _status == GameStatus.gameOver) return;
    _isCollapsing = false;
    _failureReason =
        'The building\'s centre of mass left its base, so the tower toppled.';
    _status = GameStatus.gameOver;
    notifyListeners();
  }

  void onPieceFallenOff() {
    if (_status == GameStatus.victory || _status == GameStatus.gameOver) return;
    // Pieces raining down during a collapse are the collapse, not separate
    // mistakes — the verdict for that is already on its way.
    if (_isCollapsing) return;

    _fallenCount++;
    if (_fallenCount >= _currentLevel.maxFallenPieces) {
      _failureReason =
          'Too many pieces ($_fallenCount) fell off the platform.';
      _status = GameStatus.gameOver;
    }
    notifyListeners();
  }

  void updateWind(double currentStrength, WindDirection direction) {
    _windSpeed = currentStrength;
    _windDirection = direction;
    notifyListeners();
  }

  void restartLevel() {
    _initLevel(_currentLevel);
    onRestartRequested?.call();
  }

  void nextLevel() {
    final nextId = _currentLevel.id + 1;
    if (nextId <= LevelDefinition.allLevels.length) {
      startLevel(nextId);
    } else {
      openLevelSelect();
    }
  }

  /// Called after the user earns a reward by watching a rewarded ad on the Game Over screen.
  /// Grants +1 fallen piece allowance and resumes the game from where they left off.
  void grantExtraLife() {
    if (_status != GameStatus.gameOver) return;

    // If the whole recipe has already been dropped there is nothing left to
    // place, so an extra life can only mean starting the level over.
    if (isAllPiecesPlaced) {
      restartLevel();
      return;
    }
    _fallenCount = _currentLevel.maxFallenPieces - 1; // Give one more chance
    _misalignedTimer = 0.0;
    _verdictTimer = 0.0;
    _failureReason = '';
    _status = GameStatus.aiming;
    notifyListeners();
  }
}

