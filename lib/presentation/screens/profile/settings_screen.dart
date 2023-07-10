import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/presentation/screens/screens.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/presentation/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/presentation/widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = 'settings_screen';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _tecPassword = TextEditingController();
  bool _passwordHidden = true;

  @override
  void initState() {
    super.initState();
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
      backgroundColor: AppColors.lightBackground,
      //------------------------------appBar------------------------------------
      appBar: CustomAppBar(
        title: Localization.of(context).string('wall_settings_title'),
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: responsive.diagonalPercent(3),
              fontWeight: FontWeight.bold,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    //-----------------------Ayuda---------------------------
                    _SettingOption(
                      title:
                          Localization.of(context).string('wall_settings_help'),
                      onTap: () {},
                      iconData: Icons.info_outline_rounded,
                    ),
                    SizedBox(height: spaceBetweenOptions),

                    //----------------Politica de privacidad-----------------
                    _SettingOption(
                      title: Localization.of(context)
                          .string('wall_settings_policy'),
                      onTap: () {},
                      iconData: Icons.policy_outlined,
                    ),
                    SizedBox(height: spaceBetweenOptions),

                    //-------------------Cerrar sesion----------------------
                    _SettingOption(
                      title: Localization.of(context)
                          .string('wall_settings_logOut'),
                      onTap: () async {
                        await authService.logOut();
                        postsService.reset();
                        userService.reset();
                        chatsService.reset();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          SplashScreen.routeName,
                          (route) => false,
                        );
                      },
                      iconData: Icons.logout,
                    ),
                    SizedBox(height: spaceBetweenOptions),

                    //------------------Eliminar cuenta-----------------------
                    _SettingOption(
                      title: Localization.of(context).string(
                        'delete_account',
                      ),
                      onTap: () {
                        Util.showCustomDialog(
                          context: context,
                          child: WillPopScope(
                            onWillPop: () async {
                              _tecPassword.clear();
                              return true;
                            },
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    Localization.of(context).string(
                                      'delete_account_message',
                                    ),
                                    style: AppThemes.darkTextTheme.bodyLarge!
                                        .copyWith(
                                      fontSize: responsive.diagonalPercent(2),
                                    ),
                                  ),
                                  SizedBox(height: responsive.heightPercent(2)),
                                  StatefulBuilder(
                                    builder: (BuildContext context, setState) {
                                      return TextField(
                                        controller: _tecPassword,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        obscureText: _passwordHidden,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontSize: responsive
                                                  .diagonalPercent(2.1),
                                            ),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 14.0,
                                            horizontal: 25.0,
                                          ),
                                          filled: true,
                                          fillColor: AppColors.lightGrey,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          hintText:
                                              Localization.of(context).string(
                                            'sign_in_password',
                                          ),
                                          suffixIcon: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            onTap: () {
                                              _passwordHidden =
                                                  !_passwordHidden;
                                              setState(() {});
                                            },
                                            child: Icon(
                                              _passwordHidden
                                                  ? Icons
                                                      .visibility_off_outlined
                                                  : Icons.visibility_outlined,
                                              color: AppColors.blackColor,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            MaterialButton(
                              onPressed: () async {
                                if (_tecPassword.text.isNotEmpty) {
                                  if (await authService.deleteUser(
                                    userService.userApp!,
                                    _tecPassword.text,
                                  )) {
                                    postsService.reset();
                                    userService.reset();
                                    chatsService.reset();
                                    Navigator.popUntil(
                                      context,
                                      (route) {
                                        return route ==
                                            ModalRoute.withName(
                                                SettingsScreen.routeName);
                                      },
                                    );
                                    Navigator.pushNamed(
                                      context,
                                      SplashScreen.routeName,
                                    );
                                    // Navigator.pushNamedAndRemoveUntil(
                                    //   context,
                                    //   SplashScreen.routeName,
                                    //   (route) => false,
                                    // );
                                  }
                                }
                              },
                              elevation: 0.0,
                              textColor: AppColors.whiteColor,
                              child: Text(
                                Localization.of(context).string(
                                  "common_yes",
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () => Navigator.pop(context),
                              elevation: 0.0,
                              textColor: AppColors.whiteColor,
                              child: Text(
                                Localization.of(context).string(
                                  "common_no",
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      iconData: Icons.delete_rounded,
                    ),
                  ],
                ),
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

  const _SettingOption({
    Key? key,
    required this.title,
    required this.iconData,
    required this.onTap,
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
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: responsive.diagonalPercent(2.5),
                color: AppColors.greyscale5,
              ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.greyscale1,
        ),
      ),
    );
  }
}
