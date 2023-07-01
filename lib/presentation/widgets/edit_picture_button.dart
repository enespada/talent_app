import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditPictureButton extends StatelessWidget {
  final Widget child;
  final double size;
  final void Function()? onPressed;
  final Color? color;

  const EditPictureButton({
    Key? key,
    required this.child,
    required this.size,
    required this.onPressed,
    this.color,
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
        decoration: BoxDecoration(
          color: (color != null) ? color : Colors.blue,
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
