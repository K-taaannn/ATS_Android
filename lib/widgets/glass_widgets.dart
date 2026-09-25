import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';

/// Kontainer Glassmorphism utama dengan BackdropFilter blur dan border kaca semi-transparan
class GlassContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final GlassTheme theme;
  final double blur;
  final Border? border;
  final List<Color>? customGradientColors;
  final List<BoxShadow>? customShadows;

  const GlassContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    required this.theme,
    this.blur = 16.0,
    this.border,
    this.customGradientColors,
    this.customShadows,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = shape == BoxShape.circle ? BorderRadius.circular(9999) : (borderRadius ?? BorderRadius.circular(24));
    final gradientColors = customGradientColors ?? theme.glassGradientColors;
    final effectiveBorder = border ??
        Border.all(
          color: theme.glassBorderColor,
          width: 1.2,
        );

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : effectiveRadius,
        boxShadow: customShadows ?? theme.glassShadows,
      ),
      child: ClipRRect(
        borderRadius: shape == BoxShape.circle ? BorderRadius.circular(9999) : effectiveRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              shape: shape,
              borderRadius: shape == BoxShape.circle ? null : effectiveRadius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              border: effectiveBorder,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Tombol Glassmorphism interaktif dengan efek tekan lembut
class GlassButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final GlassTheme theme;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Color? activeColor;
  final bool isSelected;

  const GlassButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.theme,
    this.width,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.borderRadius,
    this.activeColor,
    this.isSelected = false,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(18);
    final accent = widget.activeColor ?? widget.theme.primaryAccent;

    return GestureDetector(
      onTapDown: (_) {
        if (widget.onPressed != null) setState(() => _isDown = true);
      },
      onTapUp: (_) {
        if (widget.onPressed != null) {
          setState(() => _isDown = false);
          widget.onPressed?.call();
        }
      },
      onTapCancel: () {
        if (widget.onPressed != null) setState(() => _isDown = false);
      },
      child: AnimatedScale(
        scale: _isDown ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.35),
                      blurRadius: 16,
                      spreadRadius: -2,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                padding: widget.padding,
                decoration: BoxDecoration(
                  borderRadius: radius,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.isSelected
                        ? [
                            accent.withValues(alpha: 0.35),
                            accent.withValues(alpha: 0.15),
                          ]
                        : (_isDown
                            ? widget.theme.pressedGlassGradientColors
                            : widget.theme.glassGradientColors),
                  ),
                  border: Border.all(
                    color: widget.isSelected
                        ? accent.withValues(alpha: 0.7)
                        : widget.theme.glassBorderColor,
                    width: widget.isSelected ? 1.5 : 1.1,
                  ),
                ),
                child: Center(child: widget.child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tombol Icon Melingkar Bergaya Glassmorphism
class GlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final GlassTheme theme;
  final double size;
  final double iconSize;
  final Color? iconColor;
  final String? tooltip;
  final bool isSelected;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.theme,
    this.size = 46,
    this.iconSize = 22,
    this.iconColor,
    this.tooltip,
    this.isSelected = false,
  });

  @override
  State<GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<GlassIconButton> {
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.iconColor ??
        (widget.isSelected ? widget.theme.primaryAccent : widget.theme.textPrimary);

    Widget button = GestureDetector(
      onTapDown: (_) => setState(() => _isDown = true),
      onTapUp: (_) {
        setState(() => _isDown = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isDown = false),
      child: AnimatedScale(
        scale: _isDown ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.isSelected
                        ? [
                            widget.theme.primaryAccent.withValues(alpha: 0.35),
                            widget.theme.primaryAccent.withValues(alpha: 0.15),
                          ]
                        : widget.theme.glassGradientColors,
                  ),
                  border: Border.all(
                    color: widget.isSelected
                        ? widget.theme.primaryAccent.withValues(alpha: 0.7)
                        : widget.theme.glassBorderColor,
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: Icon(widget.icon, size: widget.iconSize, color: color),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }
    return button;
  }
}

/// Kolom Input Teks Bergaya Glassmorphism
class GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final GlassTheme theme;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final bool readOnly;
  final String? Function(String?)? validator;

  const GlassTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.theme,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.readOnly = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.14),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(color: theme.glassBorderColor, width: 1.1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboardType,
            validator: validator,
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                color: theme.textMuted,
                fontSize: 14,
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: theme.textSecondary, size: 20)
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }
}

/// Badge Glassmorphism
class GlassBadge extends StatelessWidget {
  final String text;
  final GlassTheme theme;
  final Color? color;
  final IconData? icon;

  const GlassBadge({
    super.key,
    required this.text,
    required this.theme,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? theme.primaryAccent;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: effectiveColor.withValues(alpha: 0.45),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 12, color: effectiveColor),
                const SizedBox(width: 4),
              ],
              Text(
                text,
                style: TextStyle(
                  color: effectiveColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Progress Bar Kaca dengan Neon Glowing Fill
class GlassProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final GlassTheme theme;
  final double height;
  final Color? activeColor;

  const GlassProgressBar({
    super.key,
    required this.progress,
    required this.theme,
    this.height = 10,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveProgress = progress.clamp(0.0, 1.0);
    final color = activeColor ?? theme.primaryAccent;

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(height / 2),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 0.8,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * effectiveProgress,
                    height: height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.7),
                          color,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(height / 2),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.6),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Latar Belakang Gradasi + Ambient Glowing Orbs yang bersinar di balik kaca
class GlassBackground extends StatelessWidget {
  final Widget child;
  final GlassTheme theme;

  const GlassBackground({
    super.key,
    required this.child,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: theme.backgroundGradient,
        ),
      ),
      child: Stack(
        children: [
          // Glowing Orb 1 (Top Right)
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.orbColor1,
                    theme.orbColor1.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // Glowing Orb 2 (Middle Left)
          Positioned(
            top: 240,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.orbColor2,
                    theme.orbColor2.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // Glowing Orb 3 (Bottom Right)
          Positioned(
            bottom: 40,
            right: -70,
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.orbColor3,
                    theme.orbColor3.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // Content
          child,
        ],
      ),
    );
  }
}
