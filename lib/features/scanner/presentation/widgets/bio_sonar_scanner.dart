import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';

class BioSonarScanner extends StatefulWidget {
  final bool isScanning;
  final double width;
  final double height;

  const BioSonarScanner({
    super.key,
    required this.isScanning,
    required this.width,
    required this.height,
  });

  @override
  State<BioSonarScanner> createState() => _BioSonarScannerState();
}

class _BioSonarScannerState extends State<BioSonarScanner>
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _gridController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    _gridController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isScanning) return const SizedBox.shrink();

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          // Hexagon Grid Overlay
          AnimatedBuilder(
            animation: _gridController,
            builder: (context, child) {
              return CustomPaint(
                painter: HexagonGridPainter(
                  animationValue: _gridController.value,
                  color: AppColors.primaryLight.withAlpha(30),
                ),
                size: Size(widget.width, widget.height),
              );
            },
          ),

          // Scanning Beam
          AnimatedBuilder(
            animation: _scanController,
            builder: (context, child) {
              return CustomPaint(
                painter: ScannerBeamPainter(
                  position: _scanController.value,
                  color: AppColors.accentCoral,
                ),
                size: Size(widget.width, widget.height),
              );
            },
          ),

          // High-Tech Corners
          const CornerBrackets(),
        ],
      ),
    );
  }
}

class ScannerBeamPainter extends CustomPainter {
  final double position; // 0.0 to 1.0
  final Color color;

  ScannerBeamPainter({required this.position, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withAlpha(0),
          color.withAlpha(150),
          color.withAlpha(255),
          color.withAlpha(150),
          color.withAlpha(0),
        ],
        stops: const [0.0, 0.45, 0.5, 0.55, 1.0],
      ).createShader(
          Rect.fromLTWH(0, position * size.height - 20, size.width, 40));

    // Draw the main beam
    canvas.drawRect(
      Rect.fromLTWH(0, position * size.height - 2, size.width, 4),
      Paint()
        ..color = color.withAlpha(200)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // Draw the gradient glow
    canvas.drawRect(
      Rect.fromLTWH(0, position * size.height - 30, size.width, 60),
      paint,
    );
  }

  @override
  bool shouldRepaint(ScannerBeamPainter oldDelegate) =>
      oldDelegate.position != position;
}

class HexagonGridPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  HexagonGridPainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const double hexSize = 30.0;
    const double width = hexSize * 2; // Approximate width of a point-up hexagon
    const double vertDist = hexSize * 1.5; // Vertical distance between centers

    for (double y = 0; y < size.height + hexSize; y += vertDist) {
      bool offsetRow = (y ~/ vertDist) % 2 == 1;
      for (double x = offsetRow ? width * 0.5 : 0;
          x < size.width + hexSize;
          x += width) {
        // Randomly "flicker" hexagons based on animation
        final noise = math.sin(x * y * animationValue);
        if (noise > 0.5) {
          _drawHexagon(canvas, Offset(x, y), hexSize,
              paint..color = color.withAlpha((noise * 100).toInt()));
        }
      }
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (60 * i + 30) * math.pi / 180; // +30 for pointy top
      final x = center.dx + size * math.cos(angle);
      final y = center.dy + size * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(HexagonGridPainter oldDelegate) =>
      true; // Constant animation
}

class CornerBrackets extends StatelessWidget {
  const CornerBrackets({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top Left
        Positioned(left: 0, top: 0, child: _buildBracket(0)),
        // Top Right
        Positioned(right: 0, top: 0, child: _buildBracket(90)),
        // Bottom Right
        Positioned(right: 0, bottom: 0, child: _buildBracket(180)),
        // Bottom Left
        Positioned(left: 0, bottom: 0, child: _buildBracket(270)),
      ],
    );
  }

  Widget _buildBracket(double angle) {
    return Transform.rotate(
      angle: angle * math.pi / 180,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.primaryLight, width: 3),
            left: BorderSide(color: AppColors.primaryLight, width: 3),
          ),
        ),
      ),
    );
  }
}
