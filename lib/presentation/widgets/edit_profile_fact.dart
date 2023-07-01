import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/presentation/providers/providers.dart';
import 'package:talent_app/presentation/screens/style/styles.dart';
import 'package:talent_app/utils/utils.dart';

class EditProfileFact extends StatefulWidget {
  final String text;
  final TextEditingController? textEditingController;
  final bool? isbirthdate;

  const EditProfileFact({
    Key? key,
    this.text = '',
    this.textEditingController,
    this.isbirthdate = false,
  }) : super(key: key);

  @override
  State<EditProfileFact> createState() => _EditProfileFactState();
}

class _EditProfileFactState extends State<EditProfileFact> {
  @override
  Widget build(BuildContext context) {
    final EditProfileProvider editProfileProvider =
        Provider.of<EditProfileProvider>(context);

    final Responsive responsive = Responsive.of(context);

    return Row(
      children: [
        SizedBox(
          width: responsive.widthPercent(20),
          child: Text(
            widget.text,
            style: const TextStyle(color: AppColors.greyscale2),
          ),
        ),
        SizedBox(width: responsive.widthPercent(8)),
        if (!widget.isbirthdate!)
          Expanded(
            child: TextField(
              controller: widget.textEditingController,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: responsive.diagonalPercent(2.1),
                  ),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              onChanged: (String newValue) {
                setState(() {});
              },
            ),
          ),
        if (widget.isbirthdate!)
          InkWell(
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: editProfileProvider.birthdate ?? DateTime.now(),
                firstDate: DateTime.now().subtract(
                  const Duration(seconds: 60 * 60 * 24 * 365 * 100),
                ),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: AppThemes.darkTheme.copyWith(
                      // colorScheme: ColorScheme.fromSeed(
                      //   seedColor: AppColors.brandColor,
                      //   primary: AppColors.brandColor,
                      //   onSurface: AppColors.whiteColor,
                      // ),
                      highlightColor: AppColors.brandColor,
                      canvasColor: AppColors.blueColor,
                      dialogBackgroundColor: AppColors.greyscale5,
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                editProfileProvider.birthdate = pickedDate;
                editProfileProvider.tecbirthdate.text =
                    '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                setState(() {});
              }
            },
            child: Text(
              editProfileProvider.tecbirthdate.text,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: responsive.diagonalPercent(2.1),
                  ),
            ),
          ),
      ],
    );
  }
}
