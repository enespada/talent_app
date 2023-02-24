import 'package:flutter/material.dart';

import 'package:talent_app/templates/templates.dart';
import 'package:talent_app/utils/utils.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = 'register_screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RegLogTemplate(
      title: Localization.of(context).string('sign_up'),
      subtitle: Localization.of(context).string('register_profile_type_title'),
      isLogin: false,
    );
  }
}
