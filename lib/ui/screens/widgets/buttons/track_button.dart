import 'package:flutter/material.dart';

class TrackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isTracked;
  final String status;
  final String bib;

  // Added customization properties
  final Color? activeBackgroundColor;
  final Color? inactiveBackgroundColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;
  final Color? activeStatusColor;
  final Color? inactiveBorderColor;

  const TrackButton({
    super.key,
    required this.isTracked,
    required this.onTap,
    required this.status,
    required this.bib,
    this.activeBackgroundColor,
    this.inactiveBackgroundColor,
    this.activeTextColor,
    this.inactiveTextColor,
    this.activeStatusColor,
    this.inactiveBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    // Determine colors based on state
    final backgroundColor =
        isTracked
            ? (activeBackgroundColor ?? Colors.white)
            : (inactiveBackgroundColor ?? Colors.black);

    final textColor =
        isTracked
            ? (activeTextColor ?? Colors.black)
            : (inactiveTextColor ?? Colors.white);

    final statusColor =
        isTracked
            ? (activeStatusColor ?? const Color(0xff3CFF00))
            : (inactiveTextColor ?? Colors.white);

    final borderColor =
        isTracked
            ? Colors.grey.shade300
            : (inactiveBorderColor ?? Colors.transparent);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: _buildButtonContent(textColor, statusColor),
        ),
      ),
    );
  }

  Widget _buildButtonContent(Color textColor, Color statusColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBibNumber(textColor),
        const SizedBox(height: 4),
        _buildStatusText(statusColor),
      ],
    );
  }

  Widget _buildBibNumber(Color textColor) {
    return Flexible(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          bib,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusText(Color statusColor) {
    return Flexible(
      child: Text(
        status,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
