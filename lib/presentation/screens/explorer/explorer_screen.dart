// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/presentation/screens/screens.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/presentation/screens/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/presentation/widgets/widgets.dart';

//ExplorerHomeScreen
class ExplorerScreen extends StatelessWidget {
  static const String routeName = 'explorer_screen';

  const ExplorerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final SearchService searchService = Provider.of<SearchService>(context);
    final PostsService postsService = Provider.of<PostsService>(context);

    final Responsive responsive = Responsive.of(context);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Localization.of(context).string("explorer"),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: responsive.diagonalPercent(3),
                fontWeight: FontWeight.bold,
              ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: (postsService.isLoadingAll)
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blueColor,
                    ),
                  )
                : Column(
                    children: [
                      //----------------------------Buscar--------------------------------
                      // Container(
                      //   height: responsive.heightPercent(7.2),
                      //   width: responsive.width,
                      //   padding: const EdgeInsets.symmetric(horizontal: 15),
                      //   child: Row(
                      //     children: [
                      //       GestureDetector(
                      //         onTap: () => FocusScope.of(context)
                      //             .requestFocus(searchService.focusNode),
                      //         child: Icon(
                      //           Icons.search,
                      //           size: responsive.widthPercent(7),
                      //         ),
                      //       ),
                      //       SizedBox(width: responsive.widthPercent(3.5)),
                      //       SizedBox(
                      //         height: responsive.heightPercent(7.2),
                      //         width: responsive.widthPercent(67),
                      //         child: Center(
                      //           child: TextField(
                      //             controller: searchService.tec,
                      //             focusNode: searchService.focusNode,
                      //             cursorColor: AppColors.greyscale5,
                      //             decoration: InputDecoration(
                      //               isDense: true,
                      //               hintText: Localization.of(context)
                      //                   .string('explorer_screen_search'),
                      //               hintStyle: const TextStyle(
                      //                 color: AppColors.greyscale3,
                      //               ),
                      //               labelStyle: const TextStyle(
                      //                 overflow: TextOverflow.ellipsis,
                      //               ),
                      //               border: InputBorder.none,
                      //               enabledBorder: InputBorder.none,
                      //               focusedBorder: InputBorder.none,
                      //             ),
                      //             onTap: () {
                      //               FocusScope.of(context)
                      //                   .requestFocus(searchService.focusNode);
                      //             },
                      //             onChanged: (String value) {
                      //               // tec.text = value;
                      //               searchService.suggestUsers();
                      //             },
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(height: responsive.heightPercent(4)),

                      //--------------------------Lista---------------------------------
                      if (!postsService.isLoadingAll)
                        Expanded(
                          child: PublicationsGrid(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostsListScreen(
                                    title: Localization.of(context)
                                        .string('home_screen_title'),
                                    posts: postsService.allUsersPosts!,
                                  ),
                                ),
                              );
                            },
                            posts: postsService.allUsersPosts!,
                          ),
                        ),
                    ],
                  ),
          ),
        ),
        //----------------------CustomBottomNavigationBar--------------------------
        bottomNavigationBar: const CustomBottomNavigationBar(
          selectedIndex: 1,
        ),
      ),
    );
  }
}

class _ExplorerHomeAppBar extends StatelessWidget {
  const _ExplorerHomeAppBar({
    Key? key,
    required this.title,
    required this.responsive,
  }) : super(key: key);

  final String title;
  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: responsive.heightPercent(2),
        left: responsive.widthPercent(4),
        right: responsive.widthPercent(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            // style: AppStyles.darkTextTheme.displayMedium,
          ),
          Row(
            children: [
              GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.filter_alt_outlined,
                    size: 30,
                    color: AppColors.whiteColor,
                  ),
                ),
                onTap: () {
                  // context.navigateTo(ExplorerFiltersPage());
                },
              ),
              const SizedBox(width: 10),
              GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.notifications_outlined,
                    size: 30,
                    color: AppColors.whiteColor,
                  ),
                ),
                onTap: () {
                  // context.navigateTo(NotificationsPage());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
