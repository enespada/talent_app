import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class CustomWillPopScope extends StatelessWidget {
  final Widget child;
  final bool onWillPop;
  final VoidCallback action;

  const CustomWillPopScope({
    required this.child,
    this.onWillPop = false,
    Key? key,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? GestureDetector(
            onPanEnd: (details) {
              if (details.velocity.pixelsPerSecond.dx < 0 ||
                  details.velocity.pixelsPerSecond.dx > 0) {
                if (onWillPop) {
                  Navigator.maybePop(context);
                }
              }
            },
            child: WillPopScope(
              onWillPop: () async {
                action();
                return onWillPop;
              },
              child: child,
            ),
          )
        : WillPopScope(
            child: child,
            onWillPop: () async {
              action();
              return onWillPop;
            },
          );
  }
}
