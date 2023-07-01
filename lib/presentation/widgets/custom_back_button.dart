import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:talent_app/presentation/screens/style/styles.dart';

class CustomBackButton extends StatelessWidget {
  final String? assetImage;
  final double? paddingVertical, paddingHorizontal, borderRadius;
  final Color? backgroundColor, iconColor;
  final void Function()? onTap;

  const CustomBackButton({
    Key? key,
    this.assetImage,
    this.paddingVertical,
    this.paddingHorizontal,
    this.borderRadius,
    this.backgroundColor,
    this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.lightGrey,
          borderRadius: BorderRadius.circular(borderRadius ?? 62.0),
        ),
        padding: EdgeInsets.symmetric(
          vertical: paddingVertical ?? 6.0,
          horizontal: paddingHorizontal ?? 27.0,
        ),
        child: SvgPicture.asset(
          assetImage ?? 'assets/images/arrow-back.svg',
          color: iconColor ?? AppColors.blackColor,
        ),
      ),
    );
  }
}
