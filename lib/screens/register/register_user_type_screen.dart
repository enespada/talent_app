import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talent_app/screens/screens.dart';

import 'package:talent_app/services/services.dart';
import 'package:talent_app/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

class RegisterUserTypeScreen extends StatefulWidget {
  static const String routeName = 'register_user_type_screen';
  // final PageController pageController;

  const RegisterUserTypeScreen({
    Key? key,
    // required this.pageController,
  }) : super(key: key);

  @override
  State<RegisterUserTypeScreen> createState() => _RegisterUserTypeScreenState();
}

class _RegisterUserTypeScreenState extends State<RegisterUserTypeScreen> {
  // static const String routeName = 'profile_other_page';

  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
    final Responsive responsive = Responsive.of(context);
    final AuthService authService = Provider.of<AuthService>(context);

    List<String> type = ["athlete", "scouter", "manager"];

    final List<String> respuestasPosibles = [
      Localization.of(context).string('register_type_athlete'),
      Localization.of(context).string('register_type_scouter'),
      Localization.of(context).string('register_type_manager'),
    ];

    return Scaffold(
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            height: responsive.height,
            width: responsive.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.asset('assets/images/background_lineas.png').image,
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //------------------------Boton atras----------------------------
                  CustomBackButton(onTap: () => Navigator.pop(context)),
                  SizedBox(height: responsive.heightPercent(2)),

                  //---------------------------Titulo----------------------------
                  Text(
                    Localization.of(context)
                        .string('register_profile_type_title'),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: responsive.diagonalPercent(5),
                        ),
                  ),
                  SizedBox(height: responsive.heightPercent(3)),

                  //------------------------Subtitulo----------------------------
                  Text(
                    Localization.of(context)
                        .string('register_profile_type_subtitle'),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: responsive.diagonalPercent(2.3),
                        ),
                  ),
                  SizedBox(height: responsive.heightPercent(3)),

                  //-----------------------Tipo de usuario------------------------
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: respuestasPosibles.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _selectedIndex = index;
                          // widget.user?.type = type[index];
                          // authService.userApp?.type = type[index];
                          setState(() {});
                        },
                        child: CustomCheck(
                          title: "Soy ${respuestasPosibles[index]}",
                          currentIndex: index,
                          textStyle:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: (_selectedIndex == index)
                                        ? AppColors.whiteColor
                                        : AppColors.greyscale4,
                                    fontWeight: FontWeight.w600,
                                    // fontSize: 15,
                                  ),
                          color: (_selectedIndex == index)
                              ? AppColors.greyscale4
                              : AppColors.lightGrey,
                          check: (_selectedIndex == index)
                              ? const Icon(
                                  Icons.check,
                                  color: AppColors.whiteColor,
                                )
                              : Container(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: responsive.heightPercent(14)),
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: YellowTextButton(
                      title: Localization.of(context).string('btn_next'),
                      backgroundDisabled: AppColors.greyscale1,
                      foregroundDisabled: AppColors.greyscale4,
                      onPressed: (_selectedIndex != -1)
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(
                                    userType: type[_selectedIndex],
                                  ),
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
