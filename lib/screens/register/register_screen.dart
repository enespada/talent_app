import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/services/services.dart';
import 'package:talent_app/style/styles.dart';
import 'package:talent_app/templates/templates.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register_screen';

  final String userType;

  const RegisterScreen({Key? key, required this.userType}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return RegLogTemplate(
      title: Localization.of(context).string('sign_up'),
      subtitle: Localization.of(context).string('register_profile_type_title'),
      buttonText: Localization.of(context).string('sign_up'),
      userType: widget.userType,
    );

    // final AuthService authService = Provider.of<AuthService>(context);
    // final UserService userService = Provider.of<UserService>(context);
    // final PostsService postsService = Provider.of<PostsService>(context);

    // final Responsive responsive = Responsive.of(context);

    // RegLogTemplate regLogTemplate = RegLogTemplate(
    //   title: Localization.of(context).string('sign_up'),
    //   subtitle: Localization.of(context).string('register_profile_type_title'),
    //   isLogin: false,
    // );
    // List<Widget> pages = [
    //   regLogTemplate,
    //   const TypeUserWidget(),
    // ];

    // return Scaffold(
    //   body: GestureDetector(
    //     onTap: FocusScope.of(context).unfocus,
    //     child: SafeArea(
    //       child: SingleChildScrollView(
    //         physics: const BouncingScrollPhysics(),
    //         child: Container(
    //           padding: const EdgeInsets.symmetric(horizontal: 15),
    //           // height: responsive.height,
    //           // width: responsive.width,
    //           decoration: BoxDecoration(
    //             image: DecorationImage(
    //               image:
    //                   Image.asset('assets/images/background_lineas.png').image,
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //           //--------------------------Contenido------------------------------
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               //------------------------Boton atras----------------------------
    //               CustomBackButton(onTap: () => Navigator.pop(context)),
    //               SizedBox(height: responsive.heightPercent(2)),

    //               Container(
    //                 padding: const EdgeInsets.symmetric(horizontal: 25),
    //                 height: responsive.heightPercent(65),
    //                 width: responsive.width,
    //                 child: PageView.builder(
    //                   physics: const NeverScrollableScrollPhysics(),
    //                   allowImplicitScrolling: true,
    //                   itemCount: pages.length,
    //                   onPageChanged: (int value) {
    //                     selectedIndex = value;
    //                     setState(() {});
    //                   },
    //                   itemBuilder: (BuildContext context, int index) {
    //                     return pages[index];
    //                   },
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

class TypeUserWidget extends StatefulWidget {
  const TypeUserWidget({super.key});

  @override
  State<TypeUserWidget> createState() => _TypeUserWidgetState();
}

class _TypeUserWidgetState extends State<TypeUserWidget> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final AuthService authService = Provider.of<AuthService>(context);

    List<String> type = ["athlete", "scouter", "manager"];

    final List<String> respuestasPosibles = [
      Localization.of(context).string('register_type_athlete'),
      Localization.of(context).string('register_type_scouter'),
      Localization.of(context).string('register_type_manager'),
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              Localization.of(context).string('register_profile_type_title'),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: responsive.diagonalPercent(5),
                  ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 30),
            child: Text(
              Localization.of(context).string('register_profile_type_subtitle'),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: responsive.diagonalPercent(2),
                  ),
            ),
          ),
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
                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: YellowTextButton(
                title: Localization.of(context).string('btn_next'),
                backgroundDisabled: AppColors.greyscale1,
                foregroundDisabled: AppColors.greyscale4,
                onPressed: (_selectedIndex != -1)
                    ? () {
                        // widget.pageController.nextPage(
                        //   duration: const Duration(milliseconds: 800),
                        //   curve: Curves.easeInOut,
                        // );
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
