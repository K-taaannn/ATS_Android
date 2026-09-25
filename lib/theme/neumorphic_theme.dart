import 'package:flutter/material.dart';

class NeuTheme {
  final bool isDark;

  const NeuTheme({this.isDark = false});

  // Base background and surface color (100% opaque)
  Color get baseColor => isDark ? const Color(0xFF23272E) : const Color(0xFFE8EEF5);

  // Dual shadows for extruded / elevated Neumorphic effect
  Color get lightShadowColor => isDark 
      ? const Color(0xFF2E343E).withValues(alpha: 0.8) 
      : const Color(0xFFFFFFFF).withValues(alpha: 0.9);

  Color get darkShadowColor => isDark 
      ? const Color(0xFF14171C).withValues(alpha: 0.85) 
      : const Color(0xFFA0B2C6).withValues(alpha: 0.55);

  // Inset / pressed / sunken colors
  Color get insetDarkShadow => isDark 
      ? const Color(0xFF14161A).withValues(alpha: 0.6) 
      : const Color(0xFFB5C3D4).withValues(alpha: 0.5);

  Color get insetLightShadow => isDark 
      ? const Color(0xFF2C323B).withValues(alpha: 0.5) 
      : const Color(0xFFFFFFFF).withValues(alpha: 0.7);

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
  // spreadRadius diatur ke 0 agar tidak terjadi glitch / kotak patah pada GPU shader Android
  List<BoxShadow> get raisedShadows => [
    BoxShadow(
      color: lightShadowColor,
      offset: const Offset(-4, -4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: darkShadowColor,
      offset: const Offset(4, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  // Subtle raised shadow for small elements
  List<BoxShadow> get softRaisedShadows => [
    BoxShadow(
      color: lightShadowColor,
      offset: const Offset(-2.5, -2.5),
      blurRadius: 5,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: darkShadowColor,
      offset: const Offset(2.5, 2.5),
      blurRadius: 5,
      spreadRadius: 0,
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
      color: lightShadowColor.withValues(alpha: 0.45),
      offset: const Offset(-2, -2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
}
