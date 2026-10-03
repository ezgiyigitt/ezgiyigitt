import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/game_viewmodel.dart';
import '../widgets/glass_container.dart';

class HowToPlayDialog extends StatelessWidget {
  const HowToPlayDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, vm, child) {
        return Container(
          color: Colors.black.withValues(alpha: 0.5),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: GlassContainer(
            padding: const EdgeInsets.all(22.0),
            borderRadius: 26.0,
            backgroundColor: const Color(0xF7FFFFFF), // 97% frosted blur
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420.0, maxHeight: 520.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                children: [
                  // Title row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.help_outline_rounded,
                            color: Color(0xFFE65100),
                            size: 26.0,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'How to Play',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: vm.closeHowToPlay,
                        child: const Icon(
                          Icons.close_rounded,
                          size: 22.0,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18.0),

                  // Step 1
                  _TutorialStep(
                    icon: Icons.swipe_rounded,
                    color: const Color(0xFF0288D1),
                    title: '1. Line it up, then drop',
                    desc: 'The piece slides above the tower. Tap DROP the moment it sits over the spot you want.',
                  ),
                  const SizedBox(height: 12.0),

                  // Step 2
                  _TutorialStep(
                    icon: Icons.architecture_rounded,
                    color: const Color(0xFFE65100),
                    title: '2. Keep it balanced',
                    desc: 'Every floor must rest squarely on the one below. If the weight above a floor leans past its edge, the whole tower goes over.',
                  ),
                  const SizedBox(height: 12.0),

                  // Step 3
                  _TutorialStep(
                    icon: Icons.air_rounded,
                    color: const Color(0xFF43A047),
                    title: '3. Watch the wind',
                    desc: 'The first level is calm. Later on, gusts push a falling piece off course — aim early.',
                  ),
                  const SizedBox(height: 22.0),

                  // Continue button
                  ElevatedButton(
                    onPressed: vm.openLevelSelect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE65100),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(48.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: const Text(
                      'Choose a Level',
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
          ),
        );
      },
    );
  }
}

class _TutorialStep extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String desc;

  const _TutorialStep({
    required this.icon,
    required this.color,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20.0, color: color),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF475569),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
