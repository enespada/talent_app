// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talent_app/screens/profile/posts_list_screen.dart';
import 'package:talent_app/services/posts_service.dart';
import 'package:talent_app/services/search_service.dart';
import 'package:talent_app/style/app_colors.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

//ExplorerHomeScreen
class ExplorerScreen extends StatelessWidget {
  static const String routeName = 'explorer_screen';

  final pageController = new PageController();
  final List<Widget> _pages = [
    // const ExplorerHomeChallengesGrid(),
    // const ExplorerHomePublicationsGrid(),
    // const ExplorerHomePublicationsGrid(),
    //TODO: Use publications grid but with both types
  ];
  final values = {'selectedPageIndex': 0};

  ExplorerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchService searchService = Provider.of<SearchService>(context);
    final PostsService postsService = Provider.of<PostsService>(context);

    final Responsive responsive = Responsive.of(context);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
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
                      Container(
                        height: responsive.heightPercent(7.2),
                        width: responsive.width,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => FocusScope.of(context)
                                  .requestFocus(searchService.focusNode),
                              child: Icon(
                                Icons.search,
                                size: responsive.widthPercent(7),
                              ),
                            ),
                            SizedBox(width: responsive.widthPercent(3.5)),
                            SizedBox(
                              height: responsive.heightPercent(7.2),
                              width: responsive.widthPercent(67),
                              child: Center(
                                child: TextField(
                                  controller: searchService.tec,
                                  focusNode: searchService.focusNode,
                                  cursorColor: AppColors.greyscale5,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: Localization.of(context)
                                        .string('explorer_screen_search'),
                                    hintStyle: const TextStyle(
                                      color: AppColors.greyscale3,
                                    ),
                                    labelStyle: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(searchService.focusNode);
                                  },
                                  onChanged: (String value) {
                                    // tec.text = value;
                                    searchService.suggestUsers();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: responsive.heightPercent(4)),

                      //--------------------------Lista---------------------------------
                      // Expanded(
                      //   child: ListView.builder(
                      //     itemCount: searchService.suggestedUsers.length,
                      //     itemBuilder: (context, index) {
                      //       return ListTile(
                      //         title: Text('Hola $index'),
                      //       );
                      //     },
                      //   ),
                      // ),
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
      // padding: const EdgeInsets.symmetric(horizontal: AppDimens.bigMargin, vertical: AppDimens.semiBigMargin),
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

// class _ExplorerHomeNavigationBar extends StatefulWidget {
//   const _ExplorerHomeNavigationBar({
//     Key? key,
//     required this.pageController,
//     required this.values,
//     required this.responsive,
//   }) : super(key: key);

//   final PageController pageController;
//   final Map values;
//   final Responsive responsive;

//   @override
//   State<_ExplorerHomeNavigationBar> createState() =>
//       _ExplorerHomeNavigationBarState();
// }

// class _ExplorerHomeNavigationBarState
//     extends State<_ExplorerHomeNavigationBar> {
//   @override
//   Widget build(BuildContext context) {
//     final bool challengesSelected = widget.values['selectedPageIndex'] == 0;
//     final bool publicationsSelected = widget.values['selectedPageIndex'] == 1;
//     final bool allSelected = widget.values['selectedPageIndex'] == 2;

//     return Container(
//       padding: EdgeInsets.only(
//         top: widget.responsive.heightPercent(2),
//         left: widget.responsive.widthPercent(4),
//         right: widget.responsive.widthPercent(4),
//       ),
//       child: Row(
//         children: [
//           TalentCustomButton(
//             backgroundColor:
//                 challengesSelected ? AppColors.darkGrey : AppColors.shadowGrey,
//             padding: const EdgeInsets.symmetric(
//               vertical: AppDimens.smallMargin,
//               horizontal: AppDimens.mediumMargin,
//             ),
//             borderRadius: const BorderRadius.all(
//               Radius.circular(AppDimens.extraSmallMargin),
//             ),
//             borderSide: (challengesSelected)
//                 ? const BorderSide(color: AppColors.brandColor)
//                 : null,
//             child: Text(
//               'Retos',
//               style: AppStyles.darkTextTheme.bodyLarge!.copyWith(
//                   color: AppColors.whiteColor,
//                   fontSize: 13,
//                   fontWeight: FontWeight.normal),
//             ),
//             onPressed: () {
//               setState(() {
//                 widget.values['selectedPageIndex'] = 0;
//                 widget.pageController.jumpToPage(0);
//               });
//             },
//           ),
//           const SizedBox(
//             width: AppDimens.mediumMargin,
//           ),
//           TalentCustomButton(
//             backgroundColor: publicationsSelected
//                 ? AppColors.darkGrey
//                 : AppColors.shadowGrey,
//             padding: const EdgeInsets.symmetric(
//               vertical: AppDimens.smallMargin,
//               horizontal: AppDimens.mediumMargin,
//             ),
//             borderRadius: const BorderRadius.all(
//               Radius.circular(AppDimens.extraSmallMargin),
//             ),
//             borderSide: (publicationsSelected)
//                 ? const BorderSide(color: AppColors.brandColor)
//                 : null,
//             child: Text(
//               'Publicaciones',
//               style: AppStyles.darkTextTheme.bodyLarge!.copyWith(
//                   color: AppColors.whiteColor,
//                   fontSize: 13,
//                   fontWeight: FontWeight.normal),
//             ),
//             onPressed: () {
//               setState(() {
//                 widget.values['selectedPageIndex'] = 1;
//                 widget.pageController.jumpToPage(1);
//               });
//             },
//           ),
//           const SizedBox(
//             width: AppDimens.mediumMargin,
//           ),
//           TalentCustomButton(
//             backgroundColor:
//                 allSelected ? AppColors.darkGrey : AppColors.shadowGrey,
//             padding: const EdgeInsets.symmetric(
//               vertical: AppDimens.smallMargin,
//               horizontal: AppDimens.mediumMargin,
//             ),
//             borderRadius: const BorderRadius.all(
//               Radius.circular(AppDimens.extraSmallMargin),
//             ),
//             borderSide: (allSelected)
//                 ? const BorderSide(color: AppColors.brandColor)
//                 : null,
//             child: Text(
//               'Todos',
//               style: AppStyles.darkTextTheme.bodyLarge!.copyWith(
//                   color: AppColors.whiteColor,
//                   fontSize: 13,
//                   fontWeight: FontWeight.normal),
//             ),
//             onPressed: () {
//               setState(() {
//                 widget.values['selectedPageIndex'] = 2;
//                 widget.pageController.jumpToPage(2);
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
