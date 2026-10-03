import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/game_constants.dart';
import '../../viewmodels/game_viewmodel.dart';
import '../widgets/game_button.dart';
import '../widgets/next_piece_card.dart';

class DropControlsOverlay extends StatelessWidget {
  const DropControlsOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, vm, child) {
        final canDrop = vm.status == GameStatus.aiming;

        return Stack(
          children: [
            // Middle playfield gesture detector for tap-to-drop & horizontal sliding.
            // Leaving top 115px and bottom 95px clear so top HUD (back button, restart) and bottom controls receive touches directly.
            Positioned(
              top: 115.0,
              left: 0,
              right: 0,
              bottom: 95.0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: canDrop ? vm.requestDrop : null,
                onHorizontalDragUpdate: (details) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  final deltaMeters = (details.primaryDelta ?? 0.0) / screenWidth * GameConstants.worldWidthMeters;
                  vm.moveDropper(deltaMeters);
                },
              ),
            ),

            // Bottom control bar
            Positioned(
              left: 12.0,
              right: 12.0,
              bottom: 14.0,
              child: SafeArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Active piece & lives card (Takes all remaining width)
                    Expanded(
                      child: NextPieceCard(
                        activePiece: vm.activePiece,
                        nextPiece: vm.nextPiece,
                        theme: vm.currentLevel.theme,
                        fallenCount: vm.fallenCount,
                        maxFallen: vm.maxAllowedFallen,
                      ),
                    ),
                    const SizedBox(width: 8.0),

                    // Juicy 3D Game DROP Button (Compact and crisp)
                    GameButton(
                      text: 'DROP',
                      icon: Icons.arrow_downward_rounded,
                      baseColor: const Color(0xFFFF7A00),
                      shadowColor: const Color(0xFFC75100),
                      width: 96.0,
                      height: 48.0,
                      fontSize: 15.0,
                      onPressed: canDrop ? vm.requestDrop : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
