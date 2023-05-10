import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talent_app/style/styles.dart';
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

    return AppBar(
      elevation: 0,
      title: Text(title),
      titleTextStyle: style,
      centerTitle: false,
      leading: leading ?? Container(),
      leadingWidth: leading == null ? 0 : null,
    );

    // return SafeArea(
    //   child: Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //     color: Colors.red,
    //     child: Row(
    //       children: [
    //         if (leading != null) leading!,
    //         Text(title, style: style),
    //       ],
    //     ),
    //   ),
    // );
  }
}
