import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/game_viewmodel.dart';
import '../widgets/video_box/video_box.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<GameViewModel>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Full-screen Video (No artificial gradient or extra background)
          const VideoBox(),

          // 2. Apple Guidelines Styled Action Buttons placed cleanly over the video
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 48.0, left: 24.0, right: 24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _AppleButton.primary(
                        text: 'PLAY',
                        icon: Icons.play_arrow_rounded,
                        customColor: const Color(0xFFFF7A00),
                        onPressed: vm.openLevelSelect,
                      ),
                      const SizedBox(height: 14.0),
                      _AppleButton.secondary(
                        text: 'HOW TO PLAY',
                        icon: Icons.help_outline_rounded,
                        onPressed: vm.openHowToPlay,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// Apple HIG Style Button Component
// -------------------------------------------------------------
enum _AppleButtonStyle {
  primary,
  secondary,
}

class _AppleButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final _AppleButtonStyle style;
  final Color? customColor;

  const _AppleButton.primary({
    required this.text,
    this.icon,
    this.onPressed,
    this.customColor,
  }) : style = _AppleButtonStyle.primary;

  const _AppleButton.secondary({
    required this.text,
    this.icon,
    this.onPressed,
  })  : style = _AppleButtonStyle.secondary,
        customColor = null;

  @override
  State<_AppleButton> createState() => _AppleButtonState();
}

class _AppleButtonState extends State<_AppleButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isPrimary = widget.style == _AppleButtonStyle.primary;
    final primaryColor = widget.customColor ?? const Color(0xFFFF7A00);

    const borderRadius = BorderRadius.all(Radius.circular(18.0));

    final bgColor = isPrimary
        ? primaryColor
        : Colors.white.withValues(alpha: 0.92);

    final textColor = isPrimary
        ? Colors.white
        : const Color(0xFF1E293B);

    final iconColor = isPrimary
        ? Colors.white
        : primaryColor;

    final border = isPrimary
        ? null
        : Border.all(
            color: Colors.white.withValues(alpha: 0.95),
            width: 1.5,
          );

    final shadows = isPrimary
        ? [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.40),
              blurRadius: 18.0,
              offset: const Offset(0, 6),
            ),
          ]
        : [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.14),
              blurRadius: 16.0,
              offset: const Offset(0, 4),
            ),
          ];

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOutCubic,
        child: Container(
          width: double.infinity,
          height: 56.0,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: borderRadius,
            border: border,
            boxShadow: shadows,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: iconColor,
                    size: 24.0,
                  ),
                  const SizedBox(width: 8.0),
                ],
                Text(
                  widget.text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
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
