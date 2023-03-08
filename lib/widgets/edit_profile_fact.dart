import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talent_app/providers/providers.dart';
import 'package:talent_app/style/styles.dart';
import 'package:talent_app/utils/utils.dart';

class EditProfileFact extends StatefulWidget {
  final String text;
  final TextEditingController? textEditingController;
  bool? isBirthday;

  EditProfileFact({
    Key? key,
    this.text = '',
    this.textEditingController,
    this.isBirthday,
  }) : super(key: key) {
    isBirthday ??= false;
  }

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
            style: const TextStyle(color: AppColors.mediunLightGrey),
          ),
        ),
        SizedBox(width: responsive.widthPercent(8)),
        if (!widget.isBirthday!)
          Expanded(
            child: TextField(
              controller: widget.textEditingController,
              style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
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
        if (widget.isBirthday!)
          InkWell(
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: editProfileProvider.birthday ?? DateTime.now(),
                firstDate: DateTime.now().subtract(
                  const Duration(seconds: 60 * 60 * 24 * 365 * 100),
                ),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: AppStyles.darkTheme.copyWith(
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: AppColors.brandColor,
                        primary: AppColors.brandColor,
                        onSurface: AppColors.whiteColor,
                      ),
                      highlightColor: AppColors.brandColor,
                      dialogBackgroundColor: AppColors.greyscale5,
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                editProfileProvider.birthday = pickedDate;
                editProfileProvider.tecBirthday.text =
                    '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                setState(() {});
              }
            },
            child: Text(
              editProfileProvider.tecBirthday.text,
              style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
                fontSize: responsive.diagonalPercent(2.1),
              ),
            ),
          ),
      ],
    );
  }
}
