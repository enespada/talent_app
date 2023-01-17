import 'package:flutter/material.dart';
import 'package:talent_app/style/app_colors.dart';

class BlueTextButton extends StatelessWidget {
  final double fontSize;
  final String title;
  final void Function()? onPressed;

  const BlueTextButton({
    Key? key,
    required this.fontSize,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: AppColors.blueColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0,
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.whiteColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
