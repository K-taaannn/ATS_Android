import 'package:flutter/material.dart';

class GlassTheme {
  final bool isDark;

  const GlassTheme({this.isDark = true});

  // Background gradient colors
  List<Color> get backgroundGradient => isDark
      ? const [
          Color(0xFF0F0C20),
          Color(0xFF1B143F),
          Color(0xFF2C194D),
          Color(0xFF110B24),
        ]
      : const [
          Color(0xFF4A00E0),
          Color(0xFF8E2DE2),
          Color(0xFF7F00FF),
          Color(0xFFE100FF),
        ];

  // Glowing orb colors in background to create rich frosted blur effects
  Color get orbColor1 => isDark ? const Color(0xFF7928CA).withValues(alpha: 0.5) : const Color(0xFFFF007A).withValues(alpha: 0.45);
  Color get orbColor2 => isDark ? const Color(0xFF0070F3).withValues(alpha: 0.45) : const Color(0xFF00DFD8).withValues(alpha: 0.45);
  Color get orbColor3 => isDark ? const Color(0xFFFF0080).withValues(alpha: 0.35) : const Color(0xFF7928CA).withValues(alpha: 0.4);

  // Glass surface colors (semi-transparent gradient)
  List<Color> get glassGradientColors => [
        Colors.white.withValues(alpha: 0.18),
        Colors.white.withValues(alpha: 0.05),
      ];

  // Inset / pressed glass gradient
  List<Color> get pressedGlassGradientColors => [
        Colors.white.withValues(alpha: 0.08),
        Colors.white.withValues(alpha: 0.02),
      ];

  // Border colors (frosted glass edge highlight)
  Color get glassBorderColor => Colors.white.withValues(alpha: 0.28);
  Color get pressedBorderColor => Colors.white.withValues(alpha: 0.15);

  // Accent & functional colors (vibrant neon glow)
  Color get primaryAccent => const Color(0xFF00F5D4);
  Color get secondaryAccent => const Color(0xFFFF3366);
  Color get goldAccent => const Color(0xFFFFD166);
  Color get purpleAccent => const Color(0xFFB5179E);

  // Text colors
  Color get textPrimary => Colors.white;
  Color get textSecondary => Colors.white.withValues(alpha: 0.75);
  Color get textMuted => Colors.white.withValues(alpha: 0.45);

  // Glass shadows
  List<BoxShadow> get glassShadows => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 24,
          spreadRadius: -4,
          offset: const Offset(0, 12),
        ),
      ];
}
