import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool small;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? padding;
  final double? borderRadius;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.small = false,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? theme.colorScheme.primary,
        foregroundColor: textColor ?? Colors.white,
        padding:
            padding ??
            (small
                ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                : const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
        elevation: 2,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: small ? 14 : 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
