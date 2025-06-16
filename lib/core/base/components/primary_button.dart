import 'package:flight_sync_admin/core/styles/colors_theme.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final bool isUpperCase;
  final bool isEnabled;
  final double fontSize;
  final FontWeight fontWeight;
  final VoidCallback? onPressed;

  const PrimaryButton({
    Key? key,
    required this.title,
    this.isUpperCase = true,
    this.isEnabled = true,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.w500,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        backgroundColor: isEnabled ? ColorThemes.primaryColor : Colors.white,
        foregroundColor: isEnabled ? Colors.white : ColorThemes.primaryColor,
        side: isEnabled
            ? null
            : const BorderSide(color: ColorThemes.primaryColor, width: 1),
      ),
      child: Text(
        isUpperCase ? title.toUpperCase() : title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
