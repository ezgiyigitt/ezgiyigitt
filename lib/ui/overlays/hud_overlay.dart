import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/game_viewmodel.dart';
import '../widgets/blueprint_preview_card.dart';
import '../widgets/glass_container.dart';
import '../widgets/height_progress_bar.dart';
import '../widgets/wind_indicator.dart';

class HudOverlay extends StatelessWidget {
  const HudOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, vm, child) {
        return Stack(
          children: [
            // Top HUD Status Bar
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWideScreen = constraints.maxWidth > 560;

                      if (isWideScreen) {
                        return Row(
                          children: [
                            // Back to Level Select
                            GlassContainer(
                              padding: const EdgeInsets.all(8.0),
                              borderRadius: 14.0,
                              onTap: vm.openLevelSelect,
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                size: 18.0,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            // Level info badge
                            GlassContainer(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                              borderRadius: 16.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    vm.currentLevel.title.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                      color: Color(0xFFC75D43),
                                    ),
                                  ),
                                  Text(
                                    vm.currentLevel.subtitle,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1A202C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            // Height progress bar in center
                            Expanded(
                              child: HeightProgressBar(
                                currentHeight: vm.currentHeight,
                                targetHeight: vm.targetHeight,
                                stabilityTimer: vm.stabilityTimer,
                                isStable: vm.isStable,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            // Wind indicator
                            WindIndicatorWidget(
                              speed: vm.windSpeed,
                              direction: vm.windDirection,
                            ),
                            const SizedBox(width: 8.0),
                            // Restart button
                            GlassContainer(
                              padding: const EdgeInsets.all(8.0),
                              borderRadius: 16.0,
                              onTap: vm.restartLevel,
                              child: const Icon(
                                Icons.refresh_rounded,
                                size: 18.0,
                                color: Color(0xFF4A5568),
                              ),
                            ),
                          ],
                        );
                      }

                      // Portrait layout
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GlassContainer(
                                    padding: const EdgeInsets.all(8.0),
                                    borderRadius: 14.0,
                                    onTap: vm.openLevelSelect,
                                    child: const Icon(
                                      Icons.arrow_back_rounded,
                                      size: 18.0,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  GlassContainer(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                                    borderRadius: 16.0,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          vm.currentLevel.title.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 9.0,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Color(0xFFC75D43),
                                          ),
                                        ),
                                        Text(
                                          vm.currentLevel.subtitle,
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1A202C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  WindIndicatorWidget(
                                    speed: vm.windSpeed,
                                    direction: vm.windDirection,
                                  ),
                                  const SizedBox(width: 8.0),
                                  GlassContainer(
                                    padding: const EdgeInsets.all(8.0),
                                    borderRadius: 16.0,
                                    onTap: vm.restartLevel,
                                    child: const Icon(
                                      Icons.refresh_rounded,
                                      size: 18.0,
                                      color: Color(0xFF4A5568),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0),
                          HeightProgressBar(
                            currentHeight: vm.currentHeight,
                            targetHeight: vm.targetHeight,
                            stabilityTimer: vm.stabilityTimer,
                            isStable: vm.isStable,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

            // Target Blueprint Card pinned on the Left Side
            Positioned(
              left: 14.0,
              top: 100.0,
              child: SafeArea(
                child: BlueprintPreviewCard(level: vm.currentLevel),
              ),
            ),
          ],
        );
      },
    );
  }
}
