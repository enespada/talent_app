import 'package:flutter/material.dart';

import 'package:talent_app/presentation/style/styles.dart';
import 'package:talent_app/utils/utils.dart';

class CustomCheck extends StatelessWidget {
  final String? title;
  final int currentIndex;
  final Color? color;
  final Widget check;
  final TextStyle? textStyle;

  const CustomCheck({
    Key? key,
    required this.currentIndex,
    required this.color,
    required this.check,
    this.title,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: responsive.heightPercent(9),
      width: responsive.widthPercent(70),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? "",
            style: textStyle ??
                TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: responsive.diagonalPercent(2),
                ),
          ),
          check
        ],
      ),
    );
  }
}
