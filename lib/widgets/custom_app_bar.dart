import 'package:flutter/material.dart';
import 'package:talent_app/utils/responsive.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    required this.style,
    required this.iconColor,
    required this.title,
  }) : super(key: key);

  final TextStyle? style;
  final Color? iconColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Padding(
      padding: EdgeInsets.only(
        top: responsive.heightPercent(2),
        left: responsive.widthPercent(4),
        right: responsive.widthPercent(4),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
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
    );
  }
}
