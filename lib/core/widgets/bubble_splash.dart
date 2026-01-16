import 'package:flutter/material.dart';
import 'dart:math' as math;

class BubbleSplash extends StatefulWidget {
  final Widget child;
  const BubbleSplash({super.key, required this.child});

  @override
  State<BubbleSplash> createState() => _BubbleSplashState();
}

class _BubbleSplashState extends State<BubbleSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Bubble> _bubbles = [];
  final Randomizer _random = Randomizer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Generate bubbles
    for (int i = 0; i < 20; i++) {
      _bubbles.add(Bubble(_random));
    }
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
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: BubblePainter(
                    bubbles: _bubbles,
                    animationValue: _controller.value,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class Bubble {
  late double x;
  late double y;
  late double size;
  late double speed;
  late double wobbleOffset;

  Bubble(Randomizer random) {
    reset(random);
    y = random.nextDouble(); // Start anywhere vertically initially
  }

  void reset(Randomizer random) {
    x = random.nextDouble();
    y = 1.2; // Start below screen
    size = random.nextDouble() * 20 + 5; // 5 to 25
    speed = random.nextDouble() * 0.01 + 0.002;
    wobbleOffset = random.nextDouble() * 2 * math.pi;
  }
}

class Randomizer {
  final math.Random _rnd = math.Random();
  double nextDouble() => _rnd.nextDouble();
}

class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;
  final double animationValue;
  final Randomizer _random = Randomizer();

  BubblePainter({required this.bubbles, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(50)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white.withAlpha(100)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (var bubble in bubbles) {
      // Update position
      bubble.y -= bubble.speed;

      // Reset if moves off screen
      if (bubble.y < -0.2) {
        bubble.reset(_random);
      }

      final x = bubble.x * size.width +
          math.sin(animationValue * 2 * math.pi + bubble.wobbleOffset) * 10;
      final y = bubble.y * size.height;

      final bubbleCenter = Offset(x, y);

      canvas.drawCircle(bubbleCenter, bubble.size, paint);

      // Draw shine
      canvas.drawArc(
        Rect.fromCircle(center: bubbleCenter, radius: bubble.size),
        math.pi * 1.25,
        math.pi * 0.5,
        false,
        strokePaint,
      );
    }
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) => true;
}
