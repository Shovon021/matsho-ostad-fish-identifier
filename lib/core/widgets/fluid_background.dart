import 'package:flutter/material.dart';
import '../theme/app_colors.dart'; // Correct relative import from lib/core/widgets/
import 'dart:math' as math;

class FluidBackground extends StatefulWidget {
  final Widget? child;
  const FluidBackground({super.key, this.child});

  @override
  State<FluidBackground> createState() => _FluidBackgroundState();
}

class _FluidBackgroundState extends State<FluidBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.primaryDark),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: FluidMeshPainter(
                animationValue: _controller.value,
                color: AppColors.primaryMedium.withAlpha(50),
                frequency: 1.5,
                phase: 0.0,
              ),
              size: Size.infinite,
            );
          },
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: FluidMeshPainter(
                animationValue: _controller.value,
                color: AppColors.primaryLight.withAlpha(30),
                frequency: 2.0,
                phase: math.pi,
              ),
              size: Size.infinite,
            );
          },
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class FluidMeshPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final double frequency;
  final double phase;

  FluidMeshPainter({
    required this.animationValue,
    required this.color,
    required this.frequency,
    required this.phase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    final width = size.width;
    final height = size.height;

    path.moveTo(0, height);
    path.lineTo(0, height * 0.5);

    for (double i = 0; i <= width; i += 10) {
      final x = i;
      final y = height * 0.5 +
          (math.sin((x / width * 2 * math.pi * frequency) +
                  (animationValue * 2 * math.pi) +
                  phase) *
              50) +
          (math.cos((x / width * 4 * math.pi) + (animationValue * math.pi)) *
              30);

      path.lineTo(x, y);
    }

    path.lineTo(width, height);
    path.close();

    canvas.drawPath(
        path, paint..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80));
  }

  @override
  bool shouldRepaint(FluidMeshPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
