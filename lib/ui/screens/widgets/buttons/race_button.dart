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
    switch (type) {
      case ButtonType.start:
        return 'Start';
      case ButtonType.stop:
        return 'Stop';
      case ButtonType.add:
        return 'Add';
    }
  }

  // Get button icon based on type
  IconData _getButtonIcon() {
    switch (type) {
      case ButtonType.start:
        return Icons.play_arrow_outlined;
      case ButtonType.stop:
        return Icons.stop_outlined;
      case ButtonType.add:
        return Icons.add_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            width: width,
            height: height,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: bgcolor ?? Colors.white,
              border: Border.all(color: borderColor ?? Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getButtonIcon(),
                  size: iconSize ?? 16,
                  color: textColor ?? Colors.black,
                ),
                SizedBox(width: 4),
                Text(
                  _getButtonText(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor ?? Colors.black,
                    fontSize: fontSize ?? 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
