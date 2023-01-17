import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:talent_app/style/app_colors.dart';

class EditPictureButton extends StatelessWidget {
  final Widget child;
  final double size;
  final void Function()? onPressed;

  const EditPictureButton({
    Key? key,
    required this.child,
    required this.size,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   height: size,
    //   width: size,
    //   decoration: const BoxDecoration(
    //     color: AppColors.brandYellow,
    //     shape: BoxShape.circle,
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black26,
    //         blurRadius: 10,
    //         offset: Offset(5, 5),
    //       ),
    //     ],
    //   ),
    //   child: Center(child: child),
    // );

    return CupertinoButton(
      // minSize: 30,
      onPressed: onPressed,
      child: Container(
        height: size,
        width: size,
        decoration: const BoxDecoration(
          color: AppColors.brandYellow,
          shape: BoxShape.circle,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black26,
          //     blurRadius: 10,
          //     offset: Offset(5, 5),
          //   ),
          // ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
