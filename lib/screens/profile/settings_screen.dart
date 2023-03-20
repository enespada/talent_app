import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talent_app/screens/screens.dart';
import 'package:talent_app/services/auth_service.dart';
import 'package:talent_app/services/posts_service.dart';
import 'package:talent_app/services/services.dart';

import 'package:talent_app/style/app_colors.dart';
import 'package:talent_app/style/app_styles.dart';
import 'package:talent_app/utils/utils.dart';
import '../../widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = 'settings_screen';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // final _viewModel = inject<AuthViewModel>();

  @override
  void initState() {
    super.initState();

    // _viewModel.signOutState.stream.listen((state) {
    //   switch (state) {
    //     case true:
    //       context.navigatePopReplacing(const SplashPage());
    //       break;
    //     default:
    //       break;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    final PostsService postsService = Provider.of<PostsService>(
      context,
      listen: false,
    );
    final UserService userService = Provider.of<UserService>(
      context,
      listen: false,
    );
    final ChatsService chatsService = Provider.of<ChatsService>(
      context,
      listen: false,
    );
    final Responsive responsive = Responsive.of(context);
    final double spaceBetweenOptions = responsive.heightPercent(2.5);

    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      //------------------------------appBar------------------------------------
      appBar: CustomAppBar(
        title: Localization.of(context).string('wall_settings_title'),
        style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
          fontSize: responsive.diagonalPercent(3),
          fontWeight: FontWeight.bold,
          color: AppColors.greyscale5,
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: AppColors.blueColor,
            size: responsive.heightPercent(3),
          ),
        ),
      ),

      //-------------------------------body-------------------------------------
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: responsive.heightPercent(6)),

                  //-----------------------Opciones ajustes-------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        _SettingOption(
                          title: Localization.of(context)
                              .string('wall_settings_configuration'),
                          onTap: () {
                            // context.navigateTo(const WallConfigurationPage());
                          },
                          iconData: Icons.settings_outlined,
                        ),
                        SizedBox(height: spaceBetweenOptions),
                        _SettingOption(
                          title: Localization.of(context)
                              .string('wall_settings_help'),
                          onTap: () {},
                          iconData: Icons.info_outline_rounded,
                        ),
                        SizedBox(height: spaceBetweenOptions),
                        _SettingOption(
                          title: Localization.of(context)
                              .string('wall_settings_policy'),
                          onTap: () {},
                          iconData: Icons.policy_outlined,
                        ),
                        SizedBox(height: spaceBetweenOptions),
                        _SettingOption(
                          title: Localization.of(context)
                              .string('wall_settings_logOut'),
                          onTap: () async {
                            //TODO: cerrar sesion
                            // _viewModel.signOut();
                            await authService.logOut();
                            postsService.reset();
                            // userService.userApp = null;
                            // userService.followers.clear();
                            // userService.following.clear();
                            // userService.profileUrlImage == null;
                            // userService.userPosts.clear();
                            userService.reset();
                            // chatsService.chats?.clear();
                            // chatsService.chats = null;
                            chatsService.reset();

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              SplashScreen.routeName,
                              (route) => false,
                            );
                          },
                          iconData: Icons.logout,
                          logOut: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      //-------------------------CustomBottomNavigationBar------------------------
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 4,
      ),
    );
  }
}

class _SettingOption extends StatelessWidget {
  final String title;
  final IconData iconData;
  final void Function()? onTap;
  final bool? logOut;

  const _SettingOption({
    Key? key,
    required this.title,
    required this.iconData,
    required this.onTap,
    this.logOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Icon(
          iconData,
          // size: responsive.widthPercent(10),
          size: (responsive.widthPercent(8) > 35)
              ? 35
              : responsive.widthPercent(8),
          color: AppColors.greyscale5,
        ),
        title: Text(
          title,
          style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
            fontSize: responsive.diagonalPercent(2.5),
            color: AppColors.greyscale5,
          ),
        ),
        trailing: (logOut != null && logOut == true)
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.greyscale1,
              ),
      ),
    );
  }
}
