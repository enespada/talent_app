import 'package:flutter/material.dart';

import 'package:talent_app/presentation/style/styles.dart';
import 'package:talent_app/utils/utils.dart';

class YellowTextButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color? backgroundDisabled, foregroundDisabled;
  const YellowTextButton(
      {Key? key,
      required this.title,
      this.onPressed,
      this.backgroundDisabled,
      this.foregroundDisabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        elevation: 0,
        disabledBackgroundColor:
            backgroundDisabled ?? AppColors.softYellowColor,
        disabledForegroundColor: foregroundDisabled ?? AppColors.greyscale0,
        backgroundColor: AppColors.yellowColor,
        foregroundColor: AppColors.greyscale5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppColors.greyscale5,
              fontSize: responsive.widthPercent(5),
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
