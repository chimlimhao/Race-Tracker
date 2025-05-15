import 'package:flutter/material.dart';

enum ButtonType { start, stop, add }

class RaceButton extends StatelessWidget {
  final ButtonType type;
  final VoidCallback? onPressed;
  final Color? bgcolor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? iconSize;

  const RaceButton({
    super.key,
    this.type = ButtonType.start,
    this.onPressed,
    this.bgcolor,
    this.textColor,
    this.borderColor,
    this.width,
    this.height,
    this.fontSize,
    this.iconSize,
  });

  // Get button text based on type
  String _getButtonText() {
    return switch (type) {
      ButtonType.start => 'Start',
      ButtonType.stop => 'Stop',
      ButtonType.add => 'Add',
    };
  }

  // Get button icon based on type
  IconData _getButtonIcon() {
    return switch (type) {
      ButtonType.start => Icons.play_arrow_outlined,
      ButtonType.stop => Icons.stop_outlined,
      ButtonType.add => Icons.add_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    // Determine colors based on enabled/disabled state
    final effectiveBgColor =
        onPressed == null
            ? (bgcolor ?? Colors.white).withOpacity(0.6)
            : bgcolor ?? Colors.white;

    final effectiveBorderColor =
        onPressed == null
            ? (borderColor ?? Colors.black).withOpacity(0.4)
            : borderColor ?? Colors.black;

    final effectiveTextColor =
        onPressed == null
            ? (textColor ?? Colors.black).withOpacity(0.5)
            : textColor ?? Colors.black;

    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            width: width,
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: effectiveBgColor,
              border: Border.all(color: effectiveBorderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildButtonContent(effectiveTextColor),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(_getButtonIcon(), size: iconSize ?? 16, color: textColor),
        const SizedBox(width: 4),
        Text(
          _getButtonText(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: fontSize ?? 16,
          ),
        ),
      ],
    );
  }
}
