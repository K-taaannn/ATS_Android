import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiCelebration extends StatefulWidget {
  final Widget child;
  final bool isPlaying;
  final VoidCallback? onFinished;

  const ConfettiCelebration({
    super.key,
    required this.child,
    this.isPlaying = false,
    this.onFinished,
  });

  @override
  State<ConfettiCelebration> createState() => _ConfettiCelebrationState();
}

class _ConfettiCelebrationState extends State<ConfettiCelebration> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ConfettiParticle> _particles = [];
  final List<_FloatingEmoji> _floatingEmojis = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _controller.addListener(() {
      setState(() {
        for (var p in _particles) {
          p.update();
        }
        for (var e in _floatingEmojis) {
          e.update();
        }
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFinished?.call();
      }
    });

    if (widget.isPlaying) {
      _startBurst();
    }
  }

  @override
  void didUpdateWidget(covariant ConfettiCelebration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _startBurst();
    }
  }

  void _startBurst() {
    _particles.clear();
    _floatingEmojis.clear();

    const colors = [
      Color(0xFFFF006E),
      Color(0xFF3A86FF),
      Color(0xFFFFBE0B),
      Color(0xFFFB5607),
      Color(0xFF8338EC),
      Color(0xFF06D6A0),
      Color(0xFFFF5400),
      Color(0xFFFF0054),
      Color(0xFF3F37C9),
      Color(0xFF4CC9F0),
    ];

    // 1. Meriam Kiri Bawah (Left Cannon blasting upwards-right)
    for (int i = 0; i < 70; i++) {
      _particles.add(
        _ConfettiParticle(
          x: 0.05 + (_random.nextDouble() * 0.1),
          y: 0.95,
          vx: _random.nextDouble() * 0.022 + 0.008,
          vy: -(_random.nextDouble() * 0.038 + 0.025),
          size: _random.nextDouble() * 8 + 6,
          color: colors[_random.nextInt(colors.length)],
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 0.4,
          shape: _ParticleShape.values[_random.nextInt(_ParticleShape.values.length)],
        ),
      );
    }

    // 2. Meriam Kanan Bawah (Right Cannon blasting upwards-left)
    for (int i = 0; i < 70; i++) {
      _particles.add(
        _ConfettiParticle(
          x: 0.95 - (_random.nextDouble() * 0.1),
          y: 0.95,
          vx: -(_random.nextDouble() * 0.022 + 0.008),
          vy: -(_random.nextDouble() * 0.038 + 0.025),
          size: _random.nextDouble() * 8 + 6,
          color: colors[_random.nextInt(colors.length)],
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 0.4,
          shape: _ParticleShape.values[_random.nextInt(_ParticleShape.values.length)],
        ),
      );
    }

    // 3. Ledakan Tengah Atas (Center Fireworks burst)
    for (int i = 0; i < 60; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = _random.nextDouble() * 0.02 + 0.005;
      _particles.add(
        _ConfettiParticle(
          x: 0.5 + (_random.nextDouble() - 0.5) * 0.2,
          y: 0.35,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed - 0.01,
          size: _random.nextDouble() * 8 + 5,
          color: colors[_random.nextInt(colors.length)],
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 0.3,
          shape: _ParticleShape.values[_random.nextInt(_ParticleShape.values.length)],
        ),
      );
    }

    // 4. Balon & Emoji Pesta Melayang ke Atas (Floating Balloons & Festive Emojis)
    const festiveEmojis = ['🎈', '🎂', '🎉', '🎁', '✨', '🥳', '🍰', '🎈', '💖', '⭐'];
    for (int i = 0; i < 16; i++) {
      _floatingEmojis.add(
        _FloatingEmoji(
          emoji: festiveEmojis[_random.nextInt(festiveEmojis.length)],
          x: 0.08 + (_random.nextDouble() * 0.84),
          y: 1.05 + (_random.nextDouble() * 0.3),
          vx: (_random.nextDouble() - 0.5) * 0.004,
          vy: -(_random.nextDouble() * 0.009 + 0.006),
          size: _random.nextDouble() * 14 + 28,
        ),
      );
    }

    _controller.forward(from: 0.0);
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
        if (_controller.isAnimating) ...[
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _ConfettiPainter(particles: _particles),
              ),
            ),
          ),
          ..._floatingEmojis.map((e) {
            return Positioned(
              left: MediaQuery.of(context).size.width * e.x,
              top: MediaQuery.of(context).size.height * e.y,
              child: IgnorePointer(
                child: Text(
                  e.emoji,
                  style: TextStyle(fontSize: e.size),
                ),
              ),
            );
          }),
        ],
      ],
    );
  }
}

enum _ParticleShape { circle, rect, ribbon, star }

class _FloatingEmoji {
  final String emoji;
  double x;
  double y;
  double vx;
  double vy;
  final double size;

  _FloatingEmoji({
    required this.emoji,
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
  });

  void update() {
    x += vx;
    y += vy;
  }
}

class _ConfettiParticle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  Color color;
  double rotation;
  double rotationSpeed;
  _ParticleShape shape;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.rotation,
    required this.rotationSpeed,
    required this.shape,
  });

  void update() {
    x += vx;
    y += vy;
    vy += 0.0007; // gravity
    vx *= 0.985; // air resistance
    rotation += rotationSpeed;
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;

  _ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final px = p.x * size.width;
      final py = p.y * size.height;

      final paint = Paint()..color = p.color;

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(p.rotation);

      switch (p.shape) {
        case _ParticleShape.circle:
          canvas.drawCircle(Offset.zero, p.size / 2, paint);
          break;
        case _ParticleShape.rect:
          canvas.drawRect(
            Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.55),
            paint,
          );
          break;
        case _ParticleShape.ribbon:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset.zero, width: p.size * 1.5, height: p.size * 0.35),
              const Radius.circular(2),
            ),
            paint,
          );
          break;
        case _ParticleShape.star:
          _drawStar(canvas, Offset.zero, 5, p.size * 0.7, p.size * 0.35, paint);
          break;
      }

      canvas.restore();
    }
  }

  void _drawStar(Canvas canvas, Offset center, int points, double outerRadius, double innerRadius, Paint paint) {
    final path = Path();
    final step = pi / points;
    double angle = -pi / 2;

    for (int i = 0; i < points * 2; i++) {
      final r = (i % 2 == 0) ? outerRadius : innerRadius;
      final x = center.dx + cos(angle) * r;
      final y = center.dy + sin(angle) * r;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      angle += step;
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
