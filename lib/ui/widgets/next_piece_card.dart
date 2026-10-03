import 'package:flutter/material.dart';
import '../../models/level_theme.dart';
import '../../models/piece_data.dart';
import '../../game/renderers/piece_painter.dart';
import 'glass_container.dart';

class NextPieceCard extends StatelessWidget {
  final PieceDefinition activePiece;
  final PieceDefinition? nextPiece;
  final LevelTheme theme;
  final int fallenCount;
  final int maxFallen;

  const NextPieceCard({
    super.key,
    required this.activePiece,
    required this.nextPiece,
    required this.theme,
    required this.fallenCount,
    required this.maxFallen,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      borderRadius: 16.0,
      backgroundColor: const Color(0xF7FFFFFF),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // High-contrast Piece Preview Box
          Container(
            width: 38.0,
            height: 38.0,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
            ),
            child: Center(
              child: CustomPaint(
                size: const Size(30.0, 30.0),
                painter: _PieceThumbnailPainter(
                  piece: activePiece,
                  theme: theme,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),

          // Active Piece Info & Name (Flexible/Expanded to prevent ANY overflow)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7A00),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: const Text(
                        'FALLING',
                        style: TextStyle(
                          fontSize: 8.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.4,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '${activePiece.width.toStringAsFixed(1)}×${activePiece.height.toStringAsFixed(1)}m',
                      style: const TextStyle(
                        fontSize: 9.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1.5),
                Text(
                  activePiece.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 1.0),
                Text(
                  nextPiece != null ? 'Next: ${nextPiece!.displayName}' : 'Last one: cap the roof!',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0288D1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),

          // Lives / Hak column
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'LIVES',
                style: TextStyle(
                  fontSize: 8.0,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 3.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(maxFallen, (index) {
                  final isLost = index < fallenCount;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: Icon(
                      Icons.circle,
                      size: 7.0,
                      color: isLost ? const Color(0xFFE53935) : const Color(0xFF2E7D32),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PieceThumbnailPainter extends CustomPainter {
  final PieceDefinition piece;
  final LevelTheme theme;

  _PieceThumbnailPainter({required this.piece, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final aspect = piece.width / piece.height;
    double w, h;
    if (aspect >= 1.0) {
      w = size.width;
      h = size.width / aspect;
    } else {
      h = size.height;
      w = size.height * aspect;
    }
    final rect = Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: w, height: h);
    PiecePainter.drawPiece(canvas: canvas, rect: rect, type: piece.type, theme: theme);
  }

  @override
  bool shouldRepaint(covariant _PieceThumbnailPainter oldDelegate) {
    return oldDelegate.piece != piece || oldDelegate.theme != theme;
  }
}
