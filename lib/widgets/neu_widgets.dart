import 'package:flutter/material.dart';
import '../theme/neumorphic_theme.dart';

/// Kontainer Neumorphic dasar dengan bayangan terang di kiri-atas dan gelap di kanan-bawah
class NeuContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final bool isPressed;
  final NeuTheme theme;
  final Color? customColor;
  final Border? border;
  final Gradient? gradient;

  const NeuContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.isPressed = false,
    required this.theme,
    this.customColor,
    this.border,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = customColor ?? theme.baseColor;
    final effectiveRadius = shape == BoxShape.circle ? null : (borderRadius ?? BorderRadius.circular(20));

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveColor,
        shape: shape,
        borderRadius: effectiveRadius,
        border: border,
        gradient: gradient,
        boxShadow: isPressed ? theme.pressedShadows : theme.raisedShadows,
      ),
      child: child,
    );
  }
}

/// Tombol Neumorphic interaktif dengan efek tekan (tactile press effect)
class NeuButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final NeuTheme theme;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Color? activeColor;
  final bool isSelected;
  final bool isFilled;

  const NeuButton({
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
    this.isFilled = false,
  });

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> with SingleTickerProviderStateMixin {
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    final bool pressed = _isDown || widget.isSelected;
    final radius = widget.borderRadius ?? BorderRadius.circular(16);
    final theme = widget.theme;

    // Menentukan warna latar dan bayangan yang aman tanpa glitch GPU di HP
    Color backgroundColor;
    List<BoxShadow> shadows;
    Border? border;

    if (widget.isFilled) {
      final solidColor = widget.activeColor ?? theme.primaryAccent;
      backgroundColor = solidColor;
      border = null;
      shadows = [
        BoxShadow(
          color: solidColor.withValues(alpha: pressed ? 0.25 : 0.4),
          offset: pressed ? const Offset(0, 2) : const Offset(0, 4),
          blurRadius: pressed ? 4 : 8,
          spreadRadius: 0,
        ),
      ];
    } else {
      // Tombol Neumorphic harus SELALU memakai warna dasar yang 100% solid/opaque
      backgroundColor = theme.baseColor;
      if (widget.isSelected) {
        border = Border.all(
          color: widget.activeColor ?? theme.primaryAccent,
          width: 1.5,
        );
        shadows = theme.pressedShadows;
      } else {
        border = null;
        shadows = _isDown ? theme.pressedShadows : theme.raisedShadows;
      }
    }

    return GestureDetector(
      onTapDown: (_) {
        if (widget.onPressed != null) {
          setState(() => _isDown = true);
        }
      },
      onTapUp: (_) {
        if (widget.onPressed != null) {
          setState(() => _isDown = false);
          widget.onPressed?.call();
        }
      },
      onTapCancel: () {
        if (widget.onPressed != null) {
          setState(() => _isDown = false);
        }
      },
      child: AnimatedScale(
        scale: _isDown ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: widget.width,
          height: widget.height,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: radius,
            border: border,
            boxShadow: shadows,
          ),
          child: Center(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// Tombol Icon Neumorphic Melingkar (Circular Soft Button)
class NeuIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final NeuTheme theme;
  final double size;
  final double iconSize;
  final Color? iconColor;
  final String? tooltip;
  final bool isSelected;

  const NeuIconButton({
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
  State<NeuIconButton> createState() => _NeuIconButtonState();
}

class _NeuIconButtonState extends State<NeuIconButton> {
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    final pressed = _isDown || widget.isSelected;
    final color = widget.iconColor ?? (widget.isSelected ? widget.theme.primaryAccent : widget.theme.textPrimary);

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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.theme.baseColor,
            boxShadow: pressed ? widget.theme.pressedShadows : widget.theme.softRaisedShadows,
          ),
          child: Center(
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: color,
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }
    return button;
  }
}

/// Field Input Neumorphic dengan tampilan cekung (recessed/inset)
class NeuTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final NeuTheme theme;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final bool readOnly;
  final String? Function(String?)? validator;

  const NeuTextField({
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
    return Container(
      decoration: BoxDecoration(
        color: theme.baseColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: theme.pressedShadows,
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
              ? Icon(
                  prefixIcon,
                  color: theme.textSecondary,
                  size: 20,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

/// Badge Neumorphic untuk Relasi atau Kategori
class NeuBadge extends StatelessWidget {
  final String text;
  final NeuTheme theme;
  final Color? color;
  final IconData? icon;

  const NeuBadge({
    super.key,
    required this.text,
    required this.theme,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? theme.primaryAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: effectiveColor.withValues(alpha: 0.3),
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
            ),
          ),
        ],
      ),
    );
  }
}

/// Progress Bar Neumorphic untuk Menampilkan Persentase Perjalanan Menuju Ulang Tahun
class NeuProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final NeuTheme theme;
  final double height;
  final Color? activeColor;

  const NeuProgressBar({
    super.key,
    required this.progress,
    required this.theme,
    this.height = 12,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveProgress = progress.clamp(0.0, 1.0);
    final color = activeColor ?? theme.primaryAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: theme.baseColor,
            borderRadius: BorderRadius.circular(height / 2),
            boxShadow: theme.pressedShadows,
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
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
