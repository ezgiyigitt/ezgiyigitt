import 'package:flutter/material.dart';
import '../../models/level_data.dart';
import 'glass_container.dart';

class WindIndicatorWidget extends StatelessWidget {
  final double speed;
  final WindDirection direction;

  const WindIndicatorWidget({
    super.key,
    required this.speed,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    final isWindy = speed > 6.0;
    final isStormy = speed > 10.0;

    Color badgeColor;
    if (isStormy) {
      badgeColor = const Color(0xFFE53935);
    } else if (isWindy) {
      badgeColor = const Color(0xFFFB8C00);
    } else {
      badgeColor = const Color(0xFF43A047);
    }

    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      borderRadius: 20.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.air_rounded,
            size: 18.0,
            color: badgeColor,
          ),
          const SizedBox(width: 6.0),
          Text(
            '${(speed * 3.6).toStringAsFixed(0)} km/h',
            style: const TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(width: 6.0),
          // Direction Arrow
          if (direction != WindDirection.none)
            Icon(
              direction == WindDirection.left
                  ? Icons.arrow_back_rounded
                  : Icons.arrow_forward_rounded,
              size: 16.0,
              color: badgeColor,
            ),
        ],
      ),
    );
  }
}
