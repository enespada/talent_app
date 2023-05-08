import 'package:flutter/material.dart';

import 'package:talent_app/style/styles.dart';
import 'package:talent_app/utils/utils.dart';

class UploadTemplate extends StatefulWidget {
  final String title;
  final Widget action;
  final Widget body;
  final Widget? bottomNavigatorBar;

  const UploadTemplate({
    Key? key,
    required this.title,
    required this.action,
    required this.body,
    this.bottomNavigatorBar,
  }) : super(key: key);

  @override
  State<UploadTemplate> createState() => _UploadTemplateState();
}

class _UploadTemplateState extends State<UploadTemplate> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: AppColors.blueColor),
        ),
        title: Text(
          widget.title,
          style: AppThemes.darkTextTheme.bodyLarge!.copyWith(
            fontSize: responsive.diagonalPercent(3),
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: responsive.widthPercent(3)),
            child: widget.action,
          ),
        ],
      ),

      //--------------------------------body----------------------------------
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: AppColors.blackColor),
            widget.body,
            Align(
              alignment: Alignment.bottomCenter,
              child: widget.bottomNavigatorBar ?? Container(),
            ),
          ],
        ),
      ),
    );
  }
}
