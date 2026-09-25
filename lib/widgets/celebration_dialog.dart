import 'package:flutter/material.dart';
import '../models/birthday_item.dart';
import '../theme/neumorphic_theme.dart';
import 'neu_widgets.dart';

class CelebrationDialog extends StatefulWidget {
  final NeuTheme theme;
  final BirthdayItem item;
  final VoidCallback onRetriggerConfetti;

  const CelebrationDialog({
    super.key,
    required this.theme,
    required this.item,
    required this.onRetriggerConfetti,
  });

  @override
  State<CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<CelebrationDialog> with SingleTickerProviderStateMixin {
  bool _isCandleBlown = false;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleCandle() {
    setState(() {
      _isCandleBlown = !_isCandleBlown;
    });
    if (_isCandleBlown) {
      widget.onRetriggerConfetti();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final turningAge = widget.item.getTurningAge();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: NeuContainer(
        theme: theme,
        padding: const EdgeInsets.all(26),
        borderRadius: BorderRadius.circular(32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top close button
              Align(
                alignment: Alignment.topRight,
                child: NeuIconButton(
                  icon: Icons.close_rounded,
                  size: 38,
                  iconSize: 18,
                  theme: theme,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              // Bouncing Animated Birthday Cake & Candle
              ScaleTransition(
                scale: _scaleAnimation,
                child: NeuContainer(
                  theme: theme,
                  shape: BoxShape.circle,
                  padding: const EdgeInsets.all(22),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        _isCandleBlown ? '🎂' : '🎂',
                        style: const TextStyle(fontSize: 64),
                      ),
                      Positioned(
                        top: 2,
                        child: Text(
                          _isCandleBlown ? '💨' : '🕯️',
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Title
              Text(
                '🎉 HAPPY BIRTHDAY! 🎉',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.secondaryAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),

              // Name
              Text(
                widget.item.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Age Badge
              NeuBadge(
                text: 'Menuju Usia ke-$turningAge Tahun 🌟',
                theme: theme,
                color: theme.primaryAccent,
                icon: Icons.stars_rounded,
              ),
              const SizedBox(height: 16),

              // Wish message in inset container
              NeuContainer(
                theme: theme,
                isPressed: true,
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  children: [
                    Text(
                      _isCandleBlown
                          ? '✨ Lilin telah ditiup! Semoga semua impian dan harapanmu segera terwujud! 🎈'
                          : 'Semoga panjang umur, selalu diberikan kesehatan, kelancaran rezeki, serta kesuksesan dalam setiap langkah kehidupan! 🍰',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 13,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Interactive "Tiup Lilin" Button
              NeuButton(
                theme: theme,
                isSelected: true,
                activeColor: _isCandleBlown ? theme.primaryAccent : theme.secondaryAccent,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                onPressed: _toggleCandle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isCandleBlown ? Icons.local_fire_department_rounded : Icons.air_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isCandleBlown ? 'Nyalakan Lilin Kembali 🕯️' : 'Tiup Lilin Sekarang! 💨',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // "Tembakkan Confetti Lagi" button
              NeuButton(
                theme: theme,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                onPressed: widget.onRetriggerConfetti,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.celebration_rounded, color: theme.primaryAccent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Tembakkan Kembang Api! 🎆',
                      style: TextStyle(
                        color: theme.primaryAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
