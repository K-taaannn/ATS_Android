import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';
import 'glass_widgets.dart';

/// Popup selebrasi Glassmorphism yang muncul sekilas dan menutup secara otomatis
class CelebrationDialog extends StatefulWidget {
  final GlassTheme theme;
  final String name;

  const CelebrationDialog({
    super.key,
    required this.theme,
    required this.name,
  });

  @override
  State<CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<CelebrationDialog> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _animController.forward();

    // Otomatis menutup popup setelah 2.2 detik (muncul hanya sekilas)
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.of(context).maybePop();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),
      child: Material(
        color: Colors.black.withValues(alpha: 0.25),
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: GlassContainer(
                theme: theme,
                blur: 20,
                margin: const EdgeInsets.symmetric(horizontal: 28),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GlassContainer(
                      theme: theme,
                      shape: BoxShape.circle,
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        '🎂',
                        style: TextStyle(fontSize: 44, decoration: TextDecoration.none),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Selamat Ulang Tahun',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.secondaryAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${widget.name} 🎉',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.4,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
