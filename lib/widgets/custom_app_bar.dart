import 'package:flutter/material.dart';
import 'package:talent_app/style/app_colors.dart';
import 'package:talent_app/utils/responsive.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextStyle? style;
  final Widget? leading;

  @override
  final Size preferredSize;
  // @override
  // TODO: implement preferredSize
  // Size get preferredSize => preferredSize;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.style,
    this.leading,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          top: responsive.heightPercent(2),
          left: responsive.widthPercent(4),
          right: responsive.widthPercent(4),
          bottom: responsive.heightPercent(2),
        ),
        color: AppColors.whiteColor,
        child: Row(
          children: [
            if (leading != null) leading!,
            Container(
              margin: EdgeInsets.only(left: responsive.widthPercent(3)),
              child: Text(title, style: style),
            ),
          ],
        ),
      ),
    );
  }
}
