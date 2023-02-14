import 'package:flutter/material.dart';
import 'package:talent_app/utils/responsive.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextStyle? style;
  final Color? iconColor;
  final double? height;
  final void Function()? onTap;

  @override
  final Size preferredSize;
  // @override
  // TODO: implement preferredSize
  // Size get preferredSize => preferredSize;

  const CustomAppBar({
    Key? key,
    required this.style,
    required this.iconColor,
    required this.title,
    this.height,
    this.onTap,
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
        child: Row(
          children: [
            GestureDetector(
              onTap: (onTap != null)
                  ? onTap
                  : () {
                      Navigator.of(context).pop();
                    },
              child: Icon(
                Icons.arrow_back,
                color: iconColor,
                size: responsive.heightPercent(3),
              ),
            ),
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
