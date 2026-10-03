import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/game_constants.dart';
import '../../game/renderers/piece_painter.dart';
import '../../models/level_data.dart';
import '../../models/piece_data.dart';
import 'glass_container.dart';

class BlueprintPreviewCard extends StatefulWidget {
  final LevelDefinition level;
  final bool showHeader;
  final double width;
  final double height;

  const BlueprintPreviewCard({
    super.key,
    required this.level,
    this.showHeader = true,
    this.width = 106.0,
    this.height = 165.0,
  });

  @override
  State<BlueprintPreviewCard> createState() => _BlueprintPreviewCardState();
}

class _BlueprintPreviewCardState extends State<BlueprintPreviewCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    if (!widget.showHeader) {
      // Direct standalone blueprint box without headers (perfect for level select cards)
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11.0),
          child: CustomPaint(
            painter: BlueprintPainter(
              requiredPieces: widget.level.requiredPieces,
              theme: widget.level.theme,
            ),
          ),
        ),
      );
    }

    if (!_isExpanded) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _isExpanded = true),
        child: GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          borderRadius: 14.0,
          backgroundColor: const Color(0xF0FFFFFF),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.level.icon,
                size: 15.0,
                color: const Color(0xFFE65100),
              ),
              const SizedBox(width: 4.0),
              const Text(
                'Plan',
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GlassContainer(
      padding: const EdgeInsets.all(8.0),
      borderRadius: 16.0,
      width: widget.width,
      backgroundColor: const Color(0xF2FFFFFF),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      widget.level.icon,
                      size: 13.0,
                      color: const Color(0xFFE65100),
                    ),
                    const SizedBox(width: 3.0),
                    Flexible(
                      child: Text(
                        widget.level.title.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 9.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _isExpanded = false),
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.close_rounded,
                    size: 15.0,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Container(
            width: widget.width - 16.0,
            height: widget.height - 48.0,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9.0),
              child: CustomPaint(
                painter: BlueprintPainter(
                  requiredPieces: widget.level.requiredPieces,
                  theme: widget.level.theme,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            '${widget.level.targetHeight.toStringAsFixed(1)}m Goal',
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0288D1),
            ),
          ),
        ],
      ),
    );
  }
}

class BlueprintPainter extends CustomPainter {
  final List<PieceType> requiredPieces;
  final dynamic theme;

  BlueprintPainter({
    required this.requiredPieces,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (requiredPieces.isEmpty) return;

    final centerX = size.width / 2;

    // 1. Calculate physical dimensions of the whole building including foundation
    final pieceDefs = requiredPieces.map((type) => PieceDefinition.byType(type)).toList();
    double totalPiecesHeight = 0.0;
    for (final p in pieceDefs) {
      totalPiecesHeight += p.height;
    }
    final totalMetersHeight = totalPiecesHeight + GameConstants.foundationHeight;
    final totalMetersWidth = GameConstants.foundationWidth;

    // 2. Uniform scale factor to guarantee 1:1 true physical aspect ratio (zero distortion)
    final availableWidth = size.width - 10.0;
    final availableHeight = size.height - 12.0;

    final scale = math.min(
      availableWidth / (totalMetersWidth * 1.06),
      availableHeight / totalMetersHeight,
    );

    final baseWidth = GameConstants.foundationWidth * scale;
    final baseHeight = GameConstants.foundationHeight * scale;

    // 3. Vertically center the entire building + foundation within size.height
    final totalRenderH = totalMetersHeight * scale;
    final topY = (size.height - totalRenderH) / 2;
    final foundationTopY = topY + (totalPiecesHeight * scale);
    final foundationCenterY = foundationTopY + (baseHeight / 2);

    // 4. Ground stone foundation block (identically matching FoundationComponent)
    final baseRect = Rect.fromCenter(
      center: Offset(centerX, foundationCenterY),
      width: baseWidth,
      height: baseHeight,
    );
    final baseRRect = RRect.fromRectAndRadius(baseRect, const Radius.circular(3.5));

    // Base fill
    canvas.drawRRect(
      baseRRect,
      Paint()
        ..color = (theme?.groundColor ?? const Color(0xFF475569))
        ..style = PaintingStyle.fill,
    );

    // Masonry joints
    final jointPaint = Paint()
      ..color = (theme?.groundAccent ?? const Color(0xFF334155))
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    final halfW = baseWidth / 2;
    final halfH = baseHeight / 2;

    // Horizontal seam
    canvas.drawLine(
      Offset(centerX - halfW, foundationCenterY),
      Offset(centerX + halfW, foundationCenterY),
      jointPaint,
    );
    // Vertical seams
    canvas.drawLine(
      Offset(centerX - halfW * 0.5, foundationCenterY - halfH),
      Offset(centerX - halfW * 0.5, foundationCenterY),
      jointPaint,
    );
    canvas.drawLine(
      Offset(centerX + halfW * 0.2, foundationCenterY - halfH),
      Offset(centerX + halfW * 0.2, foundationCenterY),
      jointPaint,
    );
    canvas.drawLine(
      Offset(centerX - halfW * 0.1, foundationCenterY),
      Offset(centerX - halfW * 0.1, foundationCenterY + halfH),
      jointPaint,
    );
    canvas.drawLine(
      Offset(centerX + halfW * 0.6, foundationCenterY),
      Offset(centerX + halfW * 0.6, foundationCenterY + halfH),
      jointPaint,
    );

    // Top slab highlight
    final topSlabPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(centerX - halfW, foundationCenterY - halfH + 1.0),
      Offset(centerX + halfW, foundationCenterY - halfH + 1.0),
      topSlabPaint,
    );

    // Outline
    canvas.drawRRect(
      baseRRect,
      Paint()
        ..color = const Color(0xFF1E293B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );

    // 5. Draw each piece stacked bottom-to-top with 100% true physical proportions!
    double currentY = foundationTopY;
    for (final piece in pieceDefs) {
      final pieceW = piece.width * scale;
      final pieceH = piece.height * scale;
      final pieceCenterY = currentY - (pieceH / 2);

      final rect = Rect.fromCenter(
        center: Offset(centerX, pieceCenterY),
        width: pieceW,
        height: pieceH,
      );

      PiecePainter.drawPiece(
        canvas: canvas,
        rect: rect,
        type: piece.type,
        theme: theme,
        opacity: 0.98,
      );

      currentY -= pieceH;
    }
  }

  @override
  bool shouldRepaint(covariant BlueprintPainter oldDelegate) {
    return oldDelegate.requiredPieces != requiredPieces || oldDelegate.theme != theme;
  }
}
