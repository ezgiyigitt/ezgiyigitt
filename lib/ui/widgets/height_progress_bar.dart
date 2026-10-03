import 'package:flutter/material.dart';
import 'glass_container.dart';

class HeightProgressBar extends StatelessWidget {
  final double currentHeight;
  final double targetHeight;
  final double stabilityTimer;
  final bool isStable;

  const HeightProgressBar({
    super.key,
    required this.currentHeight,
    required this.targetHeight,
    required this.stabilityTimer,
    required this.isStable,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentHeight / targetHeight).clamp(0.0, 1.0);
    final isFinished = progress >= 0.99;

    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      borderRadius: 16.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isFinished ? Icons.check_circle_rounded : Icons.architecture_rounded,
                    size: 16.0,
                    color: isFinished ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    isFinished ? 'Building Complete!' : 'Build Progress',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w800,
                      color: isFinished ? const Color(0xFF2E7D32) : const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '%${(progress * 100).toInt()}',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w900,
                      color: isFinished ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
                    ),
                  ),
                  if (isFinished) ...[
                    const SizedBox(width: 4.0),
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 14.0,
                      color: Color(0xFF2E7D32),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          // Progress bar track
          Stack(
            children: [
              Container(
                height: 7.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 7.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isFinished
                          ? const [Color(0xFF43A047), Color(0xFF66BB6A)]
                          : const [Color(0xFFFF7A00), Color(0xFFFFB300)],
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
