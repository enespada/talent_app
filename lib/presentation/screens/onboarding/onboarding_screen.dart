import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:talent_app/presentation/screens/screens.dart';
import 'package:talent_app/presentation/screens/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/presentation/widgets/widgets.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = 'onboarding_screen';

  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  TabController? controller;
  int numSlides = 3;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: numSlides, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Scaffold(
      //-------------------------------appBar-----------------------------------
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        // toolbarTextStyle: AppThemes.darkTextTheme.bodyLarge!.copyWith(
        //   color: AppColors.whiteColor,
        // ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        toolbarHeight: 0,
      ),

      //---------------------------------body------------------------------------
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          //---------------------------Carrusel--------------------------------
          SizedBox(
            height: responsive.height,
            width: responsive.width,
            child: PageView(
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              onPageChanged: (selectedPage) {
                controller?.index = selectedPage;
                setState(() {});
              },
              children: [
                slide(responsive, 1),
                slide(responsive, 2),
                slide(responsive, 3),
              ],
            ),
          ),

          //-----------------------------Logo----------------------------------
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: responsive.heightPercent(6)),
              child: Image(
                image: const AssetImage('assets/images/logo_frame.png'),
                width: responsive.widthPercent(35),
              ),
            ),
          ),

          //---------------TabPageSelector, Sign Up y Sign In-------------------
          Positioned(
            bottom: responsive.heightPercent(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //---------------------TabPageSelector------------------------
                TabPageSelector(
                  controller: controller,
                  borderStyle: BorderStyle.none,
                  selectedColor: AppColors.brandColor,
                  color: AppColors.greyscale3,
                  indicatorSize: 8,
                ),
                SizedBox(height: responsive.heightPercent(2)),

                //-------------------------Sign Up----------------------------
                SizedBox(
                  width: responsive.widthPercent(90),
                  child: YellowTextButton(
                    title: Localization.of(context).string('btn_signup'),
                    onPressed: () {
                      // context.navigatePopReplacing(
                      //   RegisterContentPages(
                      //     assetImage: 'assets/images/background_lineas.png',
                      //     title: Localization.of(context)
                      //         .string('register_title'),
                      //     backgroundColor: AppColors.whiteColor,
                      //     indicatorValue: AppColors.indicatorColor,
                      //     indicatorBackground: AppColors.lightGrey,
                      //     // widget: Container(),
                      //   ),
                      // );

                      // Navigator.pushNamed(context, RegisterScreen.routeName);
                      Navigator.pushNamed(
                        context,
                        RegisterUserTypeScreen.routeName,
                      );
                    },
                  ),
                ),

                //-------------------------Sign In----------------------------
                TextButton(
                  child: Text(
                    Localization.of(context).string('sign_in'),
                    style: TextStyle(
                      color: AppColors.greyscale0,
                      fontSize: responsive.diagonalPercent(2.3),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                ),

                //---------------------Politica de privacidad-----------------------
                SizedBox(
                  width: responsive.widthPercent(90),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: Localization.of(context)
                          .string('onboarding_announcement'),
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: responsive.diagonalPercent(1.5),
                      ),
                      children: [
                        TextSpan(
                          text: Localization.of(context)
                              .string('onboarding_terms'),
                          style: const TextStyle(color: AppColors.brandColor),
                        ),
                        TextSpan(
                          text:
                              Localization.of(context).string('onboarding_our'),
                          style: TextStyle(
                            fontSize: responsive.diagonalPercent(1.5),
                          ),
                          children: [
                            TextSpan(
                              text: Localization.of(context)
                                  .string('onboarding_privacy_policy'),
                              style: const TextStyle(
                                color: AppColors.brandColor,
                              ),
                            ),
                            const TextSpan(text: ' y '),
                            TextSpan(
                              text: Localization.of(context)
                                  .string('onboarding_cookies'),
                              style: const TextStyle(
                                color: AppColors.brandColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox slide(Responsive responsive, int num) {
    List<Widget> children = [];
    switch (num) {
      case 1:
        children.addAll([
          _TextRow(
            text: Localization.of(context).string('onboarding_slide1_item1'),
          ),
          SizedBox(height: responsive.heightPercent(1.2)),
          _TextRow(
            text: Localization.of(context).string('onboarding_slide1_item2'),
          ),
          SizedBox(height: responsive.heightPercent(1.2)),
          _TextRow(
            text: Localization.of(context).string('onboarding_slide1_item3'),
          ),
        ]);
        break;
      case 2:
        children.addAll([
          _TextRow(
            text: Localization.of(context).string('onboarding_slide2_item1'),
          ),
          SizedBox(height: responsive.heightPercent(1.2)),
          _TextRow(
            text: Localization.of(context).string('onboarding_slide2_item2'),
          ),
        ]);
        break;
      case 3:
        children.addAll([
          _TextRow(
            text: Localization.of(context).string('onboarding_slide3_item1'),
          ),
          SizedBox(height: responsive.heightPercent(1.2)),
          _TextRow(
            text: Localization.of(context).string('onboarding_slide3_item2'),
          ),
        ]);
        break;
      default:
    }

    return SizedBox(
      height: responsive.height,
      width: responsive.width,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Image(
            image: AssetImage('assets/images/fondo_profile_$num.png'),
            height: responsive.height,
            width: responsive.width,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: responsive.heightPercent(30),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Localization.of(context)
                        .string('onboarding_slide${num}_title'),
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: responsive.diagonalPercent(2.3),
                    ),
                  ),
                  SizedBox(height: responsive.heightPercent(1.2)),
                  SizedBox(
                    height: responsive.heightPercent(22),
                    width: responsive.widthPercent(90),
                    child: ListView(children: children),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextRow extends StatelessWidget {
  final String text;

  const _TextRow({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Row(
      children: [
        const Icon(
          Icons.check_rounded,
          color: AppColors.greyscale0,
        ),
        SizedBox(width: responsive.widthPercent(3.5)),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: responsive.diagonalPercent(2),
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
