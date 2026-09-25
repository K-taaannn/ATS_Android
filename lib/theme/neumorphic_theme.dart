import 'package:flutter/material.dart';

class NeuTheme {
  final bool isDark;

  const NeuTheme({this.isDark = false});

  // Base background and surface color
  Color get baseColor => isDark ? const Color(0xFF23272E) : const Color(0xFFE8EEF5);

  // Dual shadows for extruded / elevated Neumorphic effect
  Color get lightShadowColor => isDark 
      ? const Color(0xFF2E343E).withValues(alpha: 0.8) 
      : const Color(0xFFFFFFFF).withValues(alpha: 0.95);

  Color get darkShadowColor => isDark 
      ? const Color(0xFF171A1F).withValues(alpha: 0.9) 
      : const Color(0xFFA6B6C8).withValues(alpha: 0.65);

  // Inset / pressed / sunken colors
  Color get insetDarkShadow => isDark 
      ? const Color(0xFF14161A).withValues(alpha: 0.7) 
      : const Color(0xFFB5C3D4).withValues(alpha: 0.6);

  Color get insetLightShadow => isDark 
      ? const Color(0xFF2C323B).withValues(alpha: 0.6) 
      : const Color(0xFFFFFFFF).withValues(alpha: 0.8);

  // Accent & functional colors
  Color get primaryAccent => isDark ? const Color(0xFF64B5F6) : const Color(0xFF3A86FF);
  Color get secondaryAccent => isDark ? const Color(0xFFFF758F) : const Color(0xFFFF006E);
  Color get successColor => isDark ? const Color(0xFF4EBA6F) : const Color(0xFF38B000);
  Color get warningColor => isDark ? const Color(0xFFFFB703) : const Color(0xFFFB8500);

  // Text colors
  Color get textPrimary => isDark ? const Color(0xFFF0F4F8) : const Color(0xFF263238);
  Color get textSecondary => isDark ? const Color(0xFF90A4AE) : const Color(0xFF78909C);
  Color get textMuted => isDark ? const Color(0xFF607280) : const Color(0xFFA0B2C6);

  // Box shadow list for extruded (raised) elements
  List<BoxShadow> get raisedShadows => [
    BoxShadow(
      color: lightShadowColor,
      offset: const Offset(-5, -5),
      blurRadius: 9,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: darkShadowColor,
      offset: const Offset(5, 5),
      blurRadius: 9,
      spreadRadius: 1,
    ),
  ];

  // Subtle raised shadow for small elements
  List<BoxShadow> get softRaisedShadows => [
    BoxShadow(
      color: lightShadowColor,
      offset: const Offset(-3, -3),
      blurRadius: 6,
      spreadRadius: 0.5,
    ),
    BoxShadow(
      color: darkShadowColor,
      offset: const Offset(3, 3),
      blurRadius: 6,
      spreadRadius: 0.5,
    ),
  ];

  // Box shadow list for pressed / recessed elements
  List<BoxShadow> get pressedShadows => [
    BoxShadow(
      color: darkShadowColor.withValues(alpha: 0.35),
      offset: const Offset(2, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: lightShadowColor.withValues(alpha: 0.4),
      offset: const Offset(-2, -2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
}
