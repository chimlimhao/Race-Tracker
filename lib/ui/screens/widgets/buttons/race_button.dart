import 'package:flutter/material.dart';

enum ButtonType { start, stop, add }

class RaceButton extends StatelessWidget {
  final ButtonType type;
  final VoidCallback? onPressed;

  const RaceButton({super.key, this.type = ButtonType.start, this.onPressed});

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
        return Icons.play_arrow;
      case ButtonType.stop:
        return Icons.stop;
      case ButtonType.add:
        return Icons.add;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getButtonIcon(), size: 16),
            SizedBox(width: 4),
            Text(
              _getButtonText(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
