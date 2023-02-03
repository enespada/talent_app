import 'package:flutter/material.dart';
import 'package:talent_app/style/styles.dart';
import 'package:talent_app/utils/utils.dart';

class EditProfileFact extends StatefulWidget {
  final String text;
  final TextEditingController? textEditingController;

  const EditProfileFact({
    Key? key,
    this.text = '',
    this.textEditingController,
  }) : super(key: key);

  @override
  State<EditProfileFact> createState() => _EditProfileFactState();
}

class _EditProfileFactState extends State<EditProfileFact> {
  @override
  Widget build(BuildContext context) {
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
        Expanded(
          child: TextFormField(
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
      ],
    );
  }
}
