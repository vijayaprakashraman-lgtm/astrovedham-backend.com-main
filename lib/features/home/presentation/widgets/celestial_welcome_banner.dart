import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CelestialWelcomeBanner extends StatefulWidget {
  const CelestialWelcomeBanner({super.key});

  @override
  State<CelestialWelcomeBanner> createState() => _CelestialWelcomeBannerState();
}

class _CelestialWelcomeBannerState extends State<CelestialWelcomeBanner>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool disableAnimations = MediaQuery.of(context).disableAnimations;
    if (disableAnimations && _controller.isAnimating) {
      _controller.stop();
    } else if (!disableAnimations && !_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      if (_controller.isAnimating) {
        _controller.stop();
      }
    } else if (state == AppLifecycleState.resumed) {
      final bool disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
      if (!disableAnimations && !_controller.isAnimating) {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x59044D33),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color(0x26D97706),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: CelestialBannerPainter(
                progress: _controller.value,
              ),
              child: child,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 6),
                Text(
                  'welcome_title'.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.15,
                    letterSpacing: -0.5,
                    shadows: const [
                      Shadow(
                        color: Color(0x66FDE047),
                        blurRadius: 14,
                      ),
                      Shadow(
                        color: Color(0x59000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 340),
                  child: Text(
                    'welcome_subtitle'.tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFE2E8F0),
                      height: 1.45,
                      letterSpacing: 0.1,
                      shadows: const [
                        Shadow(
                          color: Color(0x66000000),
                          blurRadius: 6,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CelestialBannerPainter extends CustomPainter {
  final double progress;

  CelestialBannerPainter({required this.progress});

  static const List<_StarParticle> _stars = [
    // Top-left quadrant
    _StarParticle(anchorX: 0.08, anchorY: 0.18, radius: 2.0, minOpacity: 0.25, maxOpacity: 0.85, twinkleSpeed: 2.2, twinklePhase: 0.0, driftMaxX: 3.0, driftMaxY: 2.5, driftFreqX: 1.0, driftFreqY: 1.2, driftPhaseX: 0.2, driftPhaseY: 0.5),
    _StarParticle(anchorX: 0.15, anchorY: 0.35, radius: 3.5, minOpacity: 0.30, maxOpacity: 0.95, twinkleSpeed: 1.8, twinklePhase: 1.2, driftMaxX: 4.0, driftMaxY: 3.5, driftFreqX: 0.8, driftFreqY: 1.1, driftPhaseX: 1.0, driftPhaseY: 0.8, isSparkle: true),
    _StarParticle(anchorX: 0.22, anchorY: 0.12, radius: 1.6, minOpacity: 0.15, maxOpacity: 0.70, twinkleSpeed: 3.0, twinklePhase: 2.4, driftMaxX: 2.5, driftMaxY: 2.0, driftFreqX: 1.4, driftFreqY: 0.9, driftPhaseX: 1.5, driftPhaseY: 2.1),
    _StarParticle(anchorX: 0.28, anchorY: 0.28, radius: 2.2, minOpacity: 0.20, maxOpacity: 0.80, twinkleSpeed: 2.5, twinklePhase: 0.8, driftMaxX: 3.2, driftMaxY: 2.8, driftFreqX: 1.1, driftFreqY: 1.3, driftPhaseX: 0.5, driftPhaseY: 1.4),

    // Top-center quadrant
    _StarParticle(anchorX: 0.38, anchorY: 0.15, radius: 1.8, minOpacity: 0.20, maxOpacity: 0.75, twinkleSpeed: 2.8, twinklePhase: 3.1, driftMaxX: 2.8, driftMaxY: 2.2, driftFreqX: 1.2, driftFreqY: 1.0, driftPhaseX: 2.0, driftPhaseY: 0.3),
    _StarParticle(anchorX: 0.48, anchorY: 0.22, radius: 2.4, minOpacity: 0.30, maxOpacity: 0.85, twinkleSpeed: 1.9, twinklePhase: 1.7, driftMaxX: 3.5, driftMaxY: 3.0, driftFreqX: 0.9, driftFreqY: 1.2, driftPhaseX: 0.8, driftPhaseY: 1.9),
    _StarParticle(anchorX: 0.58, anchorY: 0.12, radius: 3.8, minOpacity: 0.35, maxOpacity: 0.95, twinkleSpeed: 1.6, twinklePhase: 4.0, driftMaxX: 4.2, driftMaxY: 3.8, driftFreqX: 0.7, driftFreqY: 1.0, driftPhaseX: 2.2, driftPhaseY: 0.7, isSparkle: true),

    // Top-right quadrant
    _StarParticle(anchorX: 0.68, anchorY: 0.25, radius: 2.0, minOpacity: 0.20, maxOpacity: 0.80, twinkleSpeed: 2.6, twinklePhase: 0.5, driftMaxX: 3.0, driftMaxY: 2.5, driftFreqX: 1.3, driftFreqY: 1.1, driftPhaseX: 1.1, driftPhaseY: 2.5),
    _StarParticle(anchorX: 0.78, anchorY: 0.14, radius: 1.7, minOpacity: 0.15, maxOpacity: 0.70, twinkleSpeed: 3.2, twinklePhase: 2.1, driftMaxX: 2.4, driftMaxY: 2.0, driftFreqX: 1.5, driftFreqY: 0.8, driftPhaseX: 0.4, driftPhaseY: 1.8),
    _StarParticle(anchorX: 0.86, anchorY: 0.28, radius: 3.6, minOpacity: 0.35, maxOpacity: 0.95, twinkleSpeed: 2.0, twinklePhase: 1.0, driftMaxX: 4.0, driftMaxY: 3.2, driftFreqX: 1.0, driftFreqY: 1.3, driftPhaseX: 1.8, driftPhaseY: 0.4, isSparkle: true),
    _StarParticle(anchorX: 0.94, anchorY: 0.18, radius: 1.9, minOpacity: 0.20, maxOpacity: 0.75, twinkleSpeed: 2.4, twinklePhase: 3.5, driftMaxX: 2.6, driftMaxY: 2.4, driftFreqX: 1.2, driftFreqY: 1.0, driftPhaseX: 2.5, driftPhaseY: 1.1),

    // Middle left & right sides
    _StarParticle(anchorX: 0.06, anchorY: 0.52, radius: 2.3, minOpacity: 0.25, maxOpacity: 0.80, twinkleSpeed: 2.1, twinklePhase: 4.2, driftMaxX: 3.2, driftMaxY: 2.8, driftFreqX: 0.9, driftFreqY: 1.2, driftPhaseX: 0.7, driftPhaseY: 2.0),
    _StarParticle(anchorX: 0.12, anchorY: 0.68, radius: 1.8, minOpacity: 0.18, maxOpacity: 0.72, twinkleSpeed: 2.9, twinklePhase: 1.9, driftMaxX: 2.5, driftMaxY: 2.2, driftFreqX: 1.3, driftFreqY: 0.9, driftPhaseX: 2.1, driftPhaseY: 0.6),
    _StarParticle(anchorX: 0.88, anchorY: 0.54, radius: 2.2, minOpacity: 0.22, maxOpacity: 0.82, twinkleSpeed: 2.3, twinklePhase: 0.3, driftMaxX: 3.0, driftMaxY: 2.6, driftFreqX: 1.1, driftFreqY: 1.4, driftPhaseX: 1.4, driftPhaseY: 1.7),
    _StarParticle(anchorX: 0.95, anchorY: 0.65, radius: 3.4, minOpacity: 0.30, maxOpacity: 0.90, twinkleSpeed: 1.7, twinklePhase: 2.8, driftMaxX: 3.8, driftMaxY: 3.4, driftFreqX: 0.8, driftFreqY: 1.0, driftPhaseX: 0.3, driftPhaseY: 2.3, isSparkle: true),

    // Center subtle area (light density so text remains crystal clear)
    _StarParticle(anchorX: 0.32, anchorY: 0.48, radius: 1.5, minOpacity: 0.15, maxOpacity: 0.65, twinkleSpeed: 3.4, twinklePhase: 1.5, driftMaxX: 2.0, driftMaxY: 2.0, driftFreqX: 1.4, driftFreqY: 1.1, driftPhaseX: 1.9, driftPhaseY: 0.2),
    _StarParticle(anchorX: 0.68, anchorY: 0.46, radius: 1.6, minOpacity: 0.15, maxOpacity: 0.68, twinkleSpeed: 3.1, twinklePhase: 3.8, driftMaxX: 2.2, driftMaxY: 2.0, driftFreqX: 1.2, driftFreqY: 1.3, driftPhaseX: 0.6, driftPhaseY: 1.5),

    // Bottom-left quadrant
    _StarParticle(anchorX: 0.08, anchorY: 0.85, radius: 3.6, minOpacity: 0.30, maxOpacity: 0.92, twinkleSpeed: 1.9, twinklePhase: 2.5, driftMaxX: 4.0, driftMaxY: 3.0, driftFreqX: 0.9, driftFreqY: 1.1, driftPhaseX: 1.7, driftPhaseY: 0.9, isSparkle: true),
    _StarParticle(anchorX: 0.18, anchorY: 0.82, radius: 2.0, minOpacity: 0.20, maxOpacity: 0.78, twinkleSpeed: 2.7, twinklePhase: 0.7, driftMaxX: 2.8, driftMaxY: 2.4, driftFreqX: 1.2, driftFreqY: 1.0, driftPhaseX: 0.2, driftPhaseY: 1.8),
    _StarParticle(anchorX: 0.26, anchorY: 0.90, radius: 1.7, minOpacity: 0.15, maxOpacity: 0.70, twinkleSpeed: 3.3, twinklePhase: 3.2, driftMaxX: 2.4, driftMaxY: 2.0, driftFreqX: 1.5, driftFreqY: 0.8, driftPhaseX: 2.3, driftPhaseY: 0.5),

    // Bottom-center quadrant
    _StarParticle(anchorX: 0.36, anchorY: 0.84, radius: 2.2, minOpacity: 0.22, maxOpacity: 0.80, twinkleSpeed: 2.4, twinklePhase: 1.1, driftMaxX: 3.0, driftMaxY: 2.6, driftFreqX: 1.0, driftFreqY: 1.2, driftPhaseX: 0.9, driftPhaseY: 2.1),
    _StarParticle(anchorX: 0.52, anchorY: 0.88, radius: 1.9, minOpacity: 0.20, maxOpacity: 0.75, twinkleSpeed: 2.8, twinklePhase: 2.0, driftMaxX: 2.6, driftMaxY: 2.2, driftFreqX: 1.3, driftFreqY: 0.9, driftPhaseX: 1.6, driftPhaseY: 0.7),
    _StarParticle(anchorX: 0.64, anchorY: 0.82, radius: 3.5, minOpacity: 0.32, maxOpacity: 0.92, twinkleSpeed: 1.8, twinklePhase: 0.2, driftMaxX: 3.8, driftMaxY: 3.2, driftFreqX: 0.8, driftFreqY: 1.1, driftPhaseX: 2.4, driftPhaseY: 1.3, isSparkle: true),

    // Bottom-right quadrant
    _StarParticle(anchorX: 0.76, anchorY: 0.88, radius: 2.1, minOpacity: 0.20, maxOpacity: 0.78, twinkleSpeed: 2.5, twinklePhase: 3.6, driftMaxX: 2.8, driftMaxY: 2.5, driftFreqX: 1.1, driftFreqY: 1.3, driftPhaseX: 0.5, driftPhaseY: 2.2),
    _StarParticle(anchorX: 0.84, anchorY: 0.78, radius: 1.8, minOpacity: 0.18, maxOpacity: 0.72, twinkleSpeed: 3.0, twinklePhase: 1.4, driftMaxX: 2.5, driftMaxY: 2.1, driftFreqX: 1.4, driftFreqY: 0.9, driftPhaseX: 1.2, driftPhaseY: 0.8),
    _StarParticle(anchorX: 0.92, anchorY: 0.86, radius: 2.3, minOpacity: 0.24, maxOpacity: 0.82, twinkleSpeed: 2.2, twinklePhase: 2.9, driftMaxX: 3.1, driftMaxY: 2.7, driftFreqX: 1.0, driftFreqY: 1.2, driftPhaseX: 2.0, driftPhaseY: 1.6),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    // 1. Base Emerald Gradient
    final Paint bgPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0.0, -0.1),
        radius: 1.2,
        colors: [
          Color(0xFF085439), // Lush emerald center
          Color(0xFF033322), // Deep forest green
          Color(0xFF012116), // Dark shadow edge
        ],
        stops: [0.0, 0.65, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    // 2. Subtle Soft Ambient Corner Glows
    final Paint goldGlowBR = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0.9, 0.9),
        radius: 0.75,
        colors: [
          Color(0x33F59E0B),
          Color(0x00000000),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, goldGlowBR);

    final Paint goldGlowTL = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.9, -0.9),
        radius: 0.7,
        colors: [
          Color(0x2EEAB308),
          Color(0x00000000),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, goldGlowTL);

    // 3. Faint Zodiac Orbit Lines with subtle shimmer
    final double wheelOpacity1 = 0.10 + 0.02 * math.sin(progress * 2 * math.pi);
    final double wheelOpacity2 = 0.08 + 0.02 * math.sin(progress * 2 * math.pi + 1.5);

    _drawFaintZodiacWheel(
      canvas: canvas,
      center: Offset(size.width * 0.90, size.height * 0.10),
      radius: size.height * 0.60,
      opacity: wheelOpacity1,
    );

    _drawFaintZodiacWheel(
      canvas: canvas,
      center: Offset(size.width * 0.08, size.height * 0.90),
      radius: size.height * 0.55,
      opacity: wheelOpacity2,
    );

    // 4. Animated Twinkling and Subtle Drifting Golden Stars
    _drawAnimatedStars(canvas, size);
  }

  void _drawFaintZodiacWheel({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double opacity,
  }) {
    final Color lineColor = const Color(0xFFFEF08A).withValues(alpha: opacity);
    final Paint linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = lineColor
      ..strokeWidth = 0.8;

    canvas.drawCircle(center, radius, linePaint);
    canvas.drawCircle(center, radius * 0.75, linePaint);
    canvas.drawCircle(center, radius * 0.20, linePaint);

    for (int i = 0; i < 12; i++) {
      final double angle = (i * 30) * math.pi / 180.0;
      final Offset start = Offset(
        center.dx + radius * 0.20 * math.cos(angle),
        center.dy + radius * 0.20 * math.sin(angle),
      );
      final Offset end = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(start, end, linePaint);
    }
  }

  void _drawAnimatedStars(Canvas canvas, Size size) {
    for (final star in _stars) {
      // 1. Subtle bounded drift position (±2-4.5 px offset around anchor position)
      final double driftXAngle = (progress * 2 * math.pi * star.driftFreqX) + star.driftPhaseX;
      final double driftYAngle = (progress * 2 * math.pi * star.driftFreqY) + star.driftPhaseY;

      final double offsetX = math.sin(driftXAngle) * star.driftMaxX;
      final double offsetY = math.cos(driftYAngle) * star.driftMaxY;

      final Offset pos = Offset(
        (star.anchorX * size.width) + offsetX,
        (star.anchorY * size.height) + offsetY,
      );

      // 2. Smooth Twinkle & Scale calculation
      final double twinkleAngle = (progress * 2 * math.pi * star.twinkleSpeed) + star.twinklePhase;
      final double rawTwinkle = (math.sin(twinkleAngle) + 1.0) / 2.0;
      final double twinkleFactor = math.pow(rawTwinkle, 1.2).toDouble();

      final double opacity = (star.minOpacity + (star.maxOpacity - star.minOpacity) * twinkleFactor).clamp(0.0, 1.0);
      final double scale = 0.85 + (0.30 * twinkleFactor);

      if (star.isSparkle) {
        _drawSingleSparkleStar(canvas, pos, star.radius, opacity, scale);
      } else {
        _drawSingleCircularStar(canvas, pos, star.radius, opacity, scale);
      }
    }
  }

  void _drawSingleCircularStar(Canvas canvas, Offset pos, double radius, double opacity, double scale) {
    final double currentRadius = radius * scale;

    // Soft outer celestial gold glow
    canvas.drawCircle(
      pos,
      currentRadius * 2.4,
      Paint()..color = const Color(0xFFF59E0B).withValues(alpha: opacity * 0.30),
    );

    // Inner bright golden-white core
    canvas.drawCircle(
      pos,
      currentRadius,
      Paint()..color = const Color(0xFFFEF08A).withValues(alpha: opacity),
    );

    // High-light center pin-point for brighter moments
    if (opacity > 0.6) {
      canvas.drawCircle(
        pos,
        currentRadius * 0.4,
        Paint()..color = Colors.white.withValues(alpha: (opacity - 0.6) / 0.4),
      );
    }
  }

  void _drawSingleSparkleStar(Canvas canvas, Offset center, double baseRadius, double opacity, double scale) {
    final double sparkleSize = baseRadius * 2.8 * scale;

    // Soft celestial ambient glow
    final Paint glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFEF08A).withValues(alpha: opacity * 0.75),
          const Color(0xFFF59E0B).withValues(alpha: opacity * 0.25),
          const Color(0x00000000),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: sparkleSize * 1.6));
    canvas.drawCircle(center, sparkleSize * 1.6, glowPaint);

    // 4-point diamond cross sparkle
    final double taper = sparkleSize * 0.16;
    final Path vertical = Path()
      ..moveTo(center.dx, center.dy - sparkleSize)
      ..lineTo(center.dx + taper, center.dy)
      ..lineTo(center.dx, center.dy + sparkleSize)
      ..lineTo(center.dx - taper, center.dy)
      ..close();

    final Path horizontal = Path()
      ..moveTo(center.dx - sparkleSize, center.dy)
      ..lineTo(center.dx, center.dy + taper)
      ..lineTo(center.dx + sparkleSize, center.dy)
      ..lineTo(center.dx - taper, center.dy)
      ..close();

    final Paint starPaint = Paint()..color = Colors.white.withValues(alpha: opacity);

    canvas.drawPath(vertical, starPaint);
    canvas.drawPath(horizontal, starPaint);

    // Center white core
    canvas.drawCircle(
      center,
      sparkleSize * 0.22,
      Paint()..color = Colors.white.withValues(alpha: opacity),
    );
  }

  @override
  bool shouldRepaint(covariant CelestialBannerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _StarParticle {
  final double anchorX;
  final double anchorY;
  final double radius;
  final double minOpacity;
  final double maxOpacity;
  final double twinkleSpeed;
  final double twinklePhase;
  final double driftMaxX;
  final double driftMaxY;
  final double driftFreqX;
  final double driftFreqY;
  final double driftPhaseX;
  final double driftPhaseY;
  final bool isSparkle;

  const _StarParticle({
    required this.anchorX,
    required this.anchorY,
    required this.radius,
    required this.minOpacity,
    required this.maxOpacity,
    required this.twinkleSpeed,
    required this.twinklePhase,
    this.driftMaxX = 3.0,
    this.driftMaxY = 3.0,
    this.driftFreqX = 1.0,
    this.driftFreqY = 1.2,
    this.driftPhaseX = 0.0,
    this.driftPhaseY = 1.0,
    this.isSparkle = false,
  });
}
