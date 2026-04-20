import 'package:flutter/material.dart';
import 'dart:math';

import 'package:kpf/screens/kpf.dart';

class ContinueScreen extends StatefulWidget {
  const ContinueScreen({super.key});

  @override
  State<ContinueScreen> createState() => _ContinueScreenState();
}

class _ContinueScreenState extends State<ContinueScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _cardController;
  late AnimationController _confettiController;
  late AnimationController _buttonController;

  late Animation<double> _checkDraw;
  late Animation<double> _ringScale;
  late Animation<double> _cardSlide;
  late Animation<double> _cardFade;
  late Animation<double> _buttonBounce;

  final List<ConfettiParticle> _particles = [];

  @override
  void initState() {
    super.initState();

    // Card entrance
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _cardSlide = Tween<double>(begin: 80, end: 0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutCubic),
    );
    _cardFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );

    // Checkmark draw
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _ringScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
    );
    _checkDraw = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.easeOut),
    );

    // Confetti
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Button bounce
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _buttonBounce = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    // Generate confetti particles
    final rng = Random();
    for (int i = 0; i < 60; i++) {
      _particles.add(ConfettiParticle(
        x: rng.nextDouble(),
        delay: rng.nextDouble() * 1.5,
        speed: 0.3 + rng.nextDouble() * 0.7,
        size: 5 + rng.nextDouble() * 7,
        color: [
          const Color(0xFF4CAF50),
          const Color(0xFF2196F3),
          const Color(0xFFFFC107),
          const Color(0xFFE91E63),
          const Color(0xFF9C27B0),
          const Color(0xFF00BCD4),
        ][rng.nextInt(6)],
        isCircle: rng.nextBool(),
        rotSpeed: rng.nextDouble() * 4 - 2,
      ));
    }

    // Sequence animations
    _cardController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _checkController.forward();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      _confettiController.forward();
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _cardController.dispose();
    _confettiController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F6),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE8F5E9),
                  Color(0xFFF5F9F6),
                  Color(0xFFE3F2FD),
                ],
              ),
            ),
          ),

          // Confetti layer
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, _) {
              return CustomPaint(
                painter: ConfettiPainter(
                  particles: _particles,
                  progress: _confettiController.value,
                ),
                child: const SizedBox.expand(),
              );
            },
          ),

          // Main content
          Center(
            child: AnimatedBuilder(
              animation: _cardController,
              builder: (context, child) {
                return Opacity(
                  opacity: _cardFade.value,
                  child: Transform.translate(
                    offset: Offset(0, _cardSlide.value),
                    child: child,
                  ),
                );
              },
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Card
                    Container(
                      padding: const EdgeInsets.fromLTRB(28, 40, 28, 36),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4CAF50).withOpacity(0.12),
                            blurRadius: 40,
                            spreadRadius: 2,
                            offset: const Offset(0, 16),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Animated checkmark
                          AnimatedBuilder(
                            animation: _checkController,
                            builder: (context, _) {
                              return Transform.scale(
                                scale: _ringScale.value,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Outer glow ring
                                    Container(
                                      width: 110,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF4CAF50)
                                            .withOpacity(0.08),
                                      ),
                                    ),
                                    // Main circle
                                    Container(
                                      width: 88,
                                      height: 88,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF66BB6A),
                                            Color(0xFF2E7D32),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF4CAF50)
                                                .withOpacity(0.4),
                                            blurRadius: 20,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: CustomPaint(
                                        painter: CheckPainter(
                                          progress: _checkDraw.value,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 28),

                          // Title
                          const Text(
                            'Your Order Placed',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A2E),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF4CAF50), Color(0xFF00897B)],
                            ).createShader(bounds),
                            child: const Text(
                              'Successfully! 🎉',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Shukriya! Aapka order confirm ho gaya hai.\nJald hi deliver kiya jaye ga.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.grey[500],
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Order badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color:
                                    const Color(0xFF4CAF50).withOpacity(0.25),
                              ),
                            ),
                            child: const Text(
                              'Order #ORD-2026-84721',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E7D32),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Divider
                          Divider(color: Colors.grey[100], thickness: 1.5),

                          const SizedBox(height: 20),

                          // Steps list
                          ..._buildSteps(),

                          const SizedBox(height: 32),

                          // Continue Shopping Button
                          AnimatedBuilder(
                            animation: _buttonBounce,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, -_buttonBounce.value * 0.3),
                                child: child,
                              );
                            },
                            child: SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigate to home page
                                  Navigator.of(context).pushAndRemoveUntil(
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 500),
                                      pageBuilder: (_, animation, __) =>
                                          FadeTransition(
                                        opacity: animation,
                                        child:
                                            const Kpf(), // <-- Replace with your HomePage
                                      ),
                                    ),
                                    (route) => false,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ).copyWith(
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.white.withOpacity(0.1)),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4CAF50),
                                        Color(0xFF00897B),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF4CAF50)
                                            .withOpacity(0.4),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Continue Shopping',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSteps() {
    final steps = [
      'Order confirm kar liya gaya',
      'Payment successfully process hui',
      'Warehouse ko notify kar diya gaya',
      '2–4 din mein deliver ho ga',
    ];
    return steps
        .map(
          (s) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF4CAF50),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withOpacity(0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  s,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}

// ─── Check Painter ────────────────────────────────────────────────────────────
class CheckPainter extends CustomPainter {
  final double progress;
  CheckPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;

    final path = Path()
      ..moveTo(cx - 16, cy)
      ..lineTo(cx - 4, cy + 12)
      ..lineTo(cx + 16, cy - 12);

    final metrics = path.computeMetrics().first;
    final extracted = metrics.extractPath(0, metrics.length * progress);
    canvas.drawPath(extracted, paint);
  }

  @override
  bool shouldRepaint(CheckPainter old) => old.progress != progress;
}

// ─── Confetti Particle ────────────────────────────────────────────────────────
class ConfettiParticle {
  final double x;
  final double delay;
  final double speed;
  final double size;
  final Color color;
  final bool isCircle;
  final double rotSpeed;

  ConfettiParticle({
    required this.x,
    required this.delay,
    required this.speed,
    required this.size,
    required this.color,
    required this.isCircle,
    required this.rotSpeed,
  });
}

// ─── Confetti Painter ─────────────────────────────────────────────────────────
class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = ((progress - p.delay / 3) * p.speed).clamp(0.0, 1.0);
      if (t <= 0) continue;

      final x = p.x * size.width + sin(t * pi * 3) * 30;
      final y = -20 + t * (size.height + 60);
      final opacity = t < 0.8 ? 1.0 : (1.0 - t) / 0.2;

      final paint = Paint()..color = p.color.withOpacity(opacity.clamp(0, 1));

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t * pi * p.rotSpeed * 4);

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
              center: Offset.zero, width: p.size, height: p.size * 0.6),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter old) => old.progress != progress;
}
