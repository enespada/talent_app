import 'package:flutter/material.dart';

import 'package:talent_app/presentation/screens/style/styles.dart';

class TalentCard extends StatelessWidget {
  const TalentCard({
    Key? key,
    required this.content,
    this.color = AppColors.lightGrey,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  final Widget content;
  final Color color;

  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: (borderRadius != null)
            ? borderRadius!
            : const BorderRadius.all(Radius.circular(20)),
      ),
      elevation: 0,
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: content,
      ),
    );
  }
}
