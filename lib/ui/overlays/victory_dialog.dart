import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/ad_service.dart';
import '../../viewmodels/game_viewmodel.dart';
import '../widgets/blueprint_preview_card.dart';
import '../widgets/glass_container.dart';

class VictoryDialog extends StatefulWidget {
  const VictoryDialog({super.key});

  @override
  State<VictoryDialog> createState() => _VictoryDialogState();
}

class _VictoryDialogState extends State<VictoryDialog> {
  bool _isInspectingHouse = false;
  bool _isLoadingNextLevel = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, vm, child) {
        if (vm.status != GameStatus.victory) {
          if (_isInspectingHouse) {
            _isInspectingHouse = false;
          }
          return const SizedBox.shrink();
        }

        // If inspecting house: provide full visibility to the live physics world with a bottom quick-bar
        if (_isInspectingHouse) {
          return Positioned(
            left: 20.0,
            right: 20.0,
            bottom: 24.0,
            child: SafeArea(
              child: GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                borderRadius: 20.0,
                backgroundColor: const Color(0xF5FFFFFF),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF2E7D32),
                      size: 24.0,
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${vm.currentLevel.title} - ${vm.currentLevel.subtitle}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const Text(
                            'Built exactly to the blueprint!',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _isInspectingHouse = false),
                      icon: const Icon(Icons.assessment_rounded, size: 16.0),
                      label: const Text('Results'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    IconButton(
                      onPressed: vm.nextLevel,
                      tooltip: 'Next Level',
                      icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xFF1E293B)),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Full Victory Modal Dialog
        return Container(
          color: Colors.black.withValues(alpha: 0.35),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20.0),
          child: GlassContainer(
            padding: const EdgeInsets.all(22.0),
            borderRadius: 28.0,
            backgroundColor: const Color(0xF5FFFFFF), // 96% white blur
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Title & Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 44.0,
                        height: 44.0,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F5E9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.emoji_events_rounded,
                          color: Color(0xFF2E7D32),
                          size: 26.0,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Building Complete!',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                          Text(
                            '${vm.currentLevel.title} • ${vm.currentLevel.subtitle}',
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // 1:1 Architectural Building Showcase
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 120.0,
                          height: 145.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: const Color(0xFFCBD5E1), width: 1.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(11.0),
                            child: CustomPaint(
                              painter: BlueprintPainter(
                                requiredPieces: vm.currentLevel.requiredPieces,
                                theme: vm.currentLevel.theme,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_rounded, size: 14.0, color: Color(0xFF2E7D32)),
                              SizedBox(width: 4.0),
                              Text(
                                'Matches the blueprint',
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1B5E20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // Stats row
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatColumn(
                          title: 'Height',
                          value: '${vm.currentHeight.toStringAsFixed(1)}m',
                        ),
                        _StatColumn(
                          title: 'Pieces',
                          value: '${vm.droppedCount}',
                        ),
                        _StatColumn(
                          title: 'Skor',
                          value: '${vm.score}',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18.0),

                  // Next level button — shows interstitial ad first on real mobile
                  ElevatedButton(
                    onPressed: _isLoadingNextLevel
                        ? null
                        : () => _goToNextLevel(vm),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(48.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: _isLoadingNextLevel
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Next Level',
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                  const SizedBox(height: 8.0),

                  // Inspect House & Restart buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => setState(() => _isInspectingHouse = true),
                          icon: const Icon(Icons.remove_red_eye_rounded, size: 17.0),
                          label: const Text('Inspect Build'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0F172A),
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: TextButton(
                          onPressed: vm.restartLevel,
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                          child: const Text(
                            'Play Again',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  /// Shows an interstitial ad (on real devices only), then goes to next level.
  void _goToNextLevel(GameViewModel vm) {
    if (kIsWeb) {
      vm.nextLevel();
      return;
    }
    setState(() => _isLoadingNextLevel = true);
    AdService.instance.showInterstitial(onComplete: () {
      if (mounted) {
        setState(() => _isLoadingNextLevel = false);
        vm.nextLevel();
      }
    });
  }
}

class _StatColumn extends StatelessWidget {
  final String title;
  final String value;

  const _StatColumn({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11.0,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3.0),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
