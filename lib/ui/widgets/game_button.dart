import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class GameButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color baseColor;
  final Color shadowColor;
  final Color textColor;
  final double height;
  final double? width;
  final double fontSize;

  const GameButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.baseColor = const Color(0xFFFF7A00),
    this.shadowColor = const Color(0xFFC75100),
    this.textColor = Colors.white,
    this.height = 54.0,
    this.width,
    this.fontSize = 17.0,
  });

  // Juicy Green Preset (for Play / Start)
  const GameButton.green({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.baseColor = const Color(0xFF4CAF50),
    this.shadowColor = const Color(0xFF2E7D32),
    this.textColor = Colors.white,
    this.height = 54.0,
    this.width,
    this.fontSize = 17.0,
  });

  // Juicy Blue Preset (for Secondary / How to Play)
  const GameButton.blue({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.baseColor = const Color(0xFF0288D1),
    this.shadowColor = const Color(0xFF01579B),
    this.textColor = Colors.white,
    this.height = 50.0,
    this.width,
    this.fontSize = 15.0,
  });

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;
    const depth = 4.0; // Slightly less harsh depth for modern iOS feel

    final bgColor = isEnabled ? widget.baseColor : const Color(0xFFB0BEC5);
    final shColor = isEnabled ? widget.shadowColor : const Color(0xFF78909C);

    return GestureDetector(
      onTapDown: isEnabled
          ? (_) {
              setState(() => _isPressed = true);
              HapticFeedback.lightImpact();
            }
          : null,
      onTapUp: isEnabled
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: () {
        if (_isPressed) setState(() => _isPressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        width: widget.width,
        height: widget.height,
        margin: EdgeInsets.only(
          top: _isPressed ? depth : 0,
          bottom: _isPressed ? 0 : depth,
        ),
        decoration: ShapeDecoration(
          color: bgColor,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(42.0), // Squircle effect common in Apple HIG
          ),
          shadows: [
            // 3D physical game button bottom lip
            BoxShadow(
              color: shColor,
              offset: Offset(0, _isPressed ? 0 : depth),
              blurRadius: 0,
            ),
            // Soft ambient ground shadow
            BoxShadow(
              color: shColor.withValues(alpha: 0.3),
              offset: const Offset(0, 4),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0), // Reduced from 16.0 to fit constrained buttons
          decoration: ShapeDecoration(
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(42.0),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.15),
                Colors.transparent,
              ],
              stops: const [0.0, 0.4],
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: widget.textColor,
                    size: widget.fontSize + 4,
                  ),
                  const SizedBox(width: 6.0),
                ],
                Text(
                  widget.text,
                  style: GoogleFonts.baloo2(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: widget.textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
