import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Clean, minimalist scanner button with Apple-like pulse animation
class BioSonarScanner extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isScanning;

  const BioSonarScanner({
    super.key,
    this.onTap,
    this.isScanning = false,
  });

  @override
  State<BioSonarScanner> createState() => _BioSonarScannerState();
}

class _BioSonarScannerState extends State<BioSonarScanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _triggerPulse() {
    _pulseController.forward(from: 0.0);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    const double size = 180;

    return GestureDetector(
      onTap: widget.isScanning ? null : _triggerPulse,
      child: SizedBox(
        width: size + 40,
        height: size + 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Pulse Ring (expands outward on tap)
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryLight.withAlpha(
                          (_opacityAnimation.value * 255).toInt(),
                        ),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Main Button Circle
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryMedium.withAlpha(180),
                    AppColors.primaryDark.withAlpha(220),
                  ],
                ),
                boxShadow: [
                  // Subtle outer glow
                  BoxShadow(
                    color: AppColors.primaryLight.withAlpha(60),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                  // Inner shadow for depth
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withAlpha(30),
                  width: 1.5,
                ),
              ),
              child: widget.isScanning
                  ? _buildScanningIndicator()
                  : _buildCameraIcon(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.camera_alt_rounded,
          size: 56,
          color: Colors.white.withAlpha(230),
        ),
        const SizedBox(height: 8),
        Text(
          'SCAN',
          style: TextStyle(
            color: Colors.white.withAlpha(200),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.5,
          ),
        ),
      ],
    );
  }

  Widget _buildScanningIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withAlpha(200),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'SCANNING...',
          style: TextStyle(
            color: Colors.white.withAlpha(180),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
