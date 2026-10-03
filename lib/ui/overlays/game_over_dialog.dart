import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/ad_service.dart';
import '../../viewmodels/game_viewmodel.dart';
import '../widgets/glass_container.dart';

class GameOverDialog extends StatefulWidget {
  const GameOverDialog({super.key});

  @override
  State<GameOverDialog> createState() => _GameOverDialogState();
}

class _GameOverDialogState extends State<GameOverDialog> {
  bool _isLoadingAd = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, vm, child) {
        if (vm.status != GameStatus.gameOver) {
          return const SizedBox.shrink();
        }

        return Container(
          color: Colors.black.withValues(alpha: 0.45),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: GlassContainer(
            padding: const EdgeInsets.all(24.0),
            borderRadius: 28.0,
            backgroundColor: const Color(0xF2FFFFFF),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64.0,
                    height: 64.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFEBEE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFC62828),
                      size: 36.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Tower Down!',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFB71C1C),
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    vm.failureReason,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: Color(0xFF556987),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Height Reached',
                              style: TextStyle(fontSize: 11.0, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '${vm.currentHeight.toStringAsFixed(1)}m',
                              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'Goal',
                              style: TextStyle(fontSize: 11.0, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '${vm.targetHeight.toStringAsFixed(1)}m',
                              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // ── REWARDED AD: Continue Button ──────────────────────────
                  // Shown only on real mobile — not on web/kIsWeb
                  if (!kIsWeb) ...[
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF8F00), Color(0xFFFF6D00)],
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6D00).withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _isLoadingAd
                            ? null
                            : () => _watchAdAndContinue(vm),
                        icon: _isLoadingAd
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.play_circle_fill_rounded, size: 22.0),
                        label: Text(
                          _isLoadingAd ? 'Loading Ad...' : '📺  Watch Ad — Get +1 Life',
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          minimumSize: const Size.fromHeight(52.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  ],

                  // ── RESTART BUTTON ────────────────────────────────────────
                  ElevatedButton(
                    onPressed: vm.restartLevel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Shows a rewarded ad. If the user watches it to the end, they get +1 fallen piece allowance
  /// which effectively revives them in the current level.
  void _watchAdAndContinue(GameViewModel vm) {
    if (!AdService.instance.isRewardedReady) {
      // Ad not loaded yet — just restart for now
      vm.restartLevel();
      return;
    }

    setState(() => _isLoadingAd = true);

    AdService.instance.showRewarded(
      onRewarded: () {
        // User earned the reward — give extra life by incrementing allowed fallen count
        vm.grantExtraLife();
      },
      onDismissed: () {
        if (mounted) setState(() => _isLoadingAd = false);
      },
    );
  }
}
