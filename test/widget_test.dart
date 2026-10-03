import 'package:flutter_test/flutter_test.dart';
import 'package:brickup/core/constants/game_constants.dart';
import 'package:brickup/models/level_data.dart';
import 'package:brickup/models/piece_data.dart';
import 'package:brickup/viewmodels/game_viewmodel.dart';

void main() {
  group('Architectural Piece Models', () {
    test('PieceDefinition has standardized heights and high friction', () {
      final door = PieceDefinition.door;
      final column = PieceDefinition.column;
      final window = PieceDefinition.window;
      final wall = PieceDefinition.wall;
      final balcony = PieceDefinition.balcony;
      final arch = PieceDefinition.arch;
      final dome = PieceDefinition.dome;

      // Heights & Dimensions
      expect(door.height, 2.0);
      expect(column.height, 2.0);
      expect(window.height, 1.8);
      expect(wall.height, 1.8);
      expect(balcony.height, 1.6);
      expect(arch.height, 2.2);
      expect(dome.height, 2.0);

      // High friction for solid construction
      expect(door.friction, greaterThan(0.9));
      expect(column.friction, greaterThan(0.9));
      expect(balcony.friction, greaterThan(0.9));
      expect(arch.friction, greaterThan(0.9));
      expect(dome.friction, greaterThan(0.9));
    });
  });

  group('Level Architectural Recipes', () {
    test('Level 1 has zero wind and exactly 5 pieces in construction order', () {
      final level1 = LevelDefinition.level1;
      expect(level1.id, 1);
      expect(level1.wind.baseStrength, 0.0);
      expect(level1.requiredPieces.length, 5);
      expect(level1.requiredPieces[0], PieceType.door);
      expect(level1.requiredPieces[1], PieceType.beam);
      expect(level1.requiredPieces[2], PieceType.window);
      expect(level1.requiredPieces[3], PieceType.beam);
      expect(level1.requiredPieces.last, PieceType.roof);
    });

    test('Level 2 features balcony and ends with roof', () {
      final level2 = LevelDefinition.level2;
      expect(level2.wind.baseStrength, greaterThan(0.0));
      expect(level2.requiredPieces.contains(PieceType.balcony), true);
      expect(level2.requiredPieces.last, PieceType.roof);
    });

    test('Level 3 features antique arch and majestic dome', () {
      final level3 = LevelDefinition.level3;
      expect(level3.requiredPieces.first, PieceType.arch);
      expect(level3.requiredPieces.contains(PieceType.balcony), true);
      expect(level3.requiredPieces.last, PieceType.dome);
    });

    test('Level 4 features clock tower pieces: gate, roseWindow, clock, crenellation, spire', () {
      final level4 = LevelDefinition.level4;
      expect(level4.id, 4);
      expect(level4.requiredPieces.first, PieceType.gate);
      expect(level4.requiredPieces.contains(PieceType.roseWindow), true);
      expect(level4.requiredPieces.contains(PieceType.clock), true);
      expect(level4.requiredPieces.contains(PieceType.crenellation), true);
      expect(level4.requiredPieces.last, PieceType.spire);
      expect(level4.blueprint.length, 8);
    });

    test('Level 5 features oriental pagoda pieces: toriiGate, shojiFloor, pagodaRoof, zenBelfry, sorinSpire', () {
      final level5 = LevelDefinition.level5;
      expect(level5.id, 5);
      expect(level5.requiredPieces.first, PieceType.toriiGate);
      expect(level5.requiredPieces.contains(PieceType.shojiFloor), true);
      expect(level5.requiredPieces.contains(PieceType.pagodaRoof), true);
      expect(level5.requiredPieces.contains(PieceType.zenBelfry), true);
      expect(level5.requiredPieces.last, PieceType.sorinSpire);
      expect(LevelDefinition.allLevels.length, 5);
      expect(LevelDefinition.getLevel(5).id, 5);
    });
  });

  group('GameViewModel Navigation & Recipe Progression', () {
    late GameViewModel viewModel;

    setUp(() {
      viewModel = GameViewModel();
    });

    test('Loads Level 1 recipe starting with Door', () {
      viewModel.startLevel(1);
      expect(viewModel.activePiece.type, PieceType.door);
      expect(viewModel.nextPiece?.type, PieceType.beam);
    });

    test('Progresses through recipe when pieces are dropped', () {
      viewModel.startLevel(1);
      expect(viewModel.droppedCount, 0);

      viewModel.requestDrop();
      viewModel.onPieceSpawnedAfterDrop();
      expect(viewModel.droppedCount, 1);
      expect(viewModel.activePiece.type, PieceType.beam);
      expect(viewModel.nextPiece?.type, PieceType.window);
    });

    test('Dropper clamps within world bounds', () {
      viewModel.startLevel(1);
      viewModel.setDropperX(0.0);
      expect(viewModel.dropperX, GameConstants.dropperMinX);

      viewModel.setDropperX(100.0);
      expect(viewModel.dropperX, GameConstants.dropperMaxX);
    });
  });
}
