import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:talent_app/models/models.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/talent_card.dart';
import 'package:talent_app/widgets/widgets.dart';

enum MessagesHomeMenu { example1, example2 }

enum MessagesHomeChatMenu { markRead, delete }

List<Map<String, dynamic>>? _chatObjects;

class ChatsScreen extends StatefulWidget {
  static const String routeName = 'chats_screen';

  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController searchFieldController = TextEditingController();
  // final _chatViewModel = inject<ChatViewModel>();
  // final _userViewModel = inject<UserViewModel>();

  @override
  void initState() {
    super.initState();

    searchFieldController.addListener(() {
      setState(() {});
    });

    // _userViewModel.getUserListState.stream.listen((state) {
    //   switch (state.status) {
    //     case Status.LOADING:
    //       LoadingOverlay.of(context).show();
    //       break;
    //     case Status.COMPLETED:
    //       LoadingOverlay.of(context).hide();
    //       users = state.data;
    //       setState(() {});
    //       break;
    //     case Status.ERROR:
    //       LoadingOverlay.of(context).hide();
    //       ErrorOverlay.of(context).show(state.error);
    //       break;
    //     default:
    //       LoadingOverlay.of(context).hide();
    //       break;
    //   }
    // });

    // _chatViewModel.removeChatState.stream.listen((state) {
    //   if (state.status == Status.COMPLETED) {
    //     setState(() {});
    //   }
    // });

    // _userViewModel.getUserList();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final UserService userService = Provider.of<UserService>(context);

    return Scaffold(
      backgroundColor: AppColors.greyscale0,

      //--------------------------------appBar----------------------------------
      appBar: CustomAppBar(
        title: Localization.of(context).string("chats_screen_title"),
        style: AppStyles.ligthTextTheme.bodyLarge!.copyWith(
          fontSize: responsive.diagonalPercent(3),
        ),
      ),

      //--------------------------------body----------------------------------
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ChatsListWidget(
                  // users: users,
                  ),
            ),
          ],
        ),
      ),

      //----------------------CustomBottomNavigationBar--------------------------
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 3,
      ),
    );
  }

  @override
  void dispose() {
    // _chatViewModel.dispose();
    // _userViewModel.dispose();
    super.dispose();
  }
}

class ChatsListWidget extends StatefulWidget {
  const ChatsListWidget({
    Key? key,
    // required this.viewModel,
    // required this.searchFieldController,
  }) : super(key: key);

  // final ChatViewModel viewModel;
  // final TextEditingController searchFieldController;

  @override
  State<ChatsListWidget> createState() => _ChatsListWidgetState();
}

class _ChatsListWidgetState extends State<ChatsListWidget> {
  @override
  void initState() {
    super.initState();
    // widget.viewModel.fetchChatList();
    // widget.viewModel.chatListState.stream.listen((state) {
    //   if (state.status == Status.COMPLETED) {
    //     _chatObjects = state.data;
    //     setState(() {});
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final ChatsService chatsService = Provider.of<ChatsService>(context);

    return Container(
      padding: EdgeInsets.only(
        top: responsive.heightPercent(2),
        left: responsive.widthPercent(4),
        right: responsive.widthPercent(4),
      ),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: chatsService.chats!.length,
        itemBuilder: (BuildContext context, int index) {
          final item = chatsService.chats![index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ChatWidget(
                // chatObject: item,
                // user: getContactUser(item),
                // viewModel: widget.viewModel,
                ),
          );
        },
      ),
    );
  }

  DocumentSnapshot? getContactUser(Map<String, dynamic> chat) {
    // final currentUser = UserViewModel.user;

    // final chatUserId = (chat['users'] as List).firstWhereOrNull(
    //     (element) => element != UserViewModel.userData?.reference);

    // return widget.users
    //     .firstWhereOrNull((element) => element?.reference == chatUserId);
  }
}

class ChatWidget extends StatefulWidget {
  final Map<String, dynamic>? chatObject;
  final DocumentSnapshot? user;
  // final ChatViewModel viewModel;

  const ChatWidget({
    Key? key,
    this.chatObject,
    this.user,
    // required this.viewModel,
  }) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  //TODO: Change these variables for chat entity
  final int newMessagesNumber = 0;
  final bool isOnline = false;
  // If true : Online icon bottom right
  final bool sent = false;
  UserApp? userApp;

  @override
  void initState() {
    super.initState();
    // userApp = UserApp.fromJson(
    //     (widget.user?.data() ?? <String, dynamic>{}) as Map<String, dynamic>);
    //TODO: Traer al usuario del chat que no es el logueado
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final UserService userService = Provider.of<UserService>(context);

    return GestureDetector(
      onTap: () async {
        // context.navigateTo(MessagesChatPage(
        //     chatId: item['id'] ?? '', user: getContactUser(item)));
      },
      onLongPressStart: (LongPressStartDetails details) {
        showMenu(
            context: context,
            color: AppColors.shadowGrey,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            position: _getRelativeRect(details.globalPosition),
            items: <PopupMenuEntry<MessagesHomeChatMenu>>[
              PopupMenuItem<MessagesHomeChatMenu>(
                value: MessagesHomeChatMenu.markRead,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/icon_check.svg',
                      color: AppColors.whiteColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      Localization.of(context)
                          .string('messages_home_chat_mark_read'),
                      style: AppStyles.darkTextTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              PopupMenuItem<MessagesHomeChatMenu>(
                value: MessagesHomeChatMenu.delete,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/icon_delete.svg',
                      color: AppColors.whiteColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      Localization.of(context)
                          .string('messages_home_chat_delete'),
                      style: AppStyles.darkTextTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ]).then((value) {
          if (value == null) return;

          switch (value) {
            case MessagesHomeChatMenu.markRead:
              if (widget.chatObject != null) {
                // widget.viewModel.markAsReaded(widget.chatObject!);
              }
              break;
            case MessagesHomeChatMenu.delete:
              if (widget.chatObject != null) {
                // widget.viewModel.removeChat(
                //     widget.chatObject!); // Remove current user from chat
              }
              break;
          }
        });
      },
      child: Container(
        height: 74,
        padding: const EdgeInsets.all(15),
        decoration: (newMessagesNumber > 0)
            ? const BoxDecoration(boxShadow: [
                BoxShadow(color: AppColors.lightGrey, blurRadius: 12.0),
                BoxShadow(color: AppColors.whiteColor),
              ])
            : null,
        child: Row(
          children: [
            FutureBuilder(
              future: userService.getProfileImageURL(
                  usersToShow[index].id!.path.split('/')[1]),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Container(
                  height: responsive.heightPercent(16),
                  width: responsive.widthPercent(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: (snapshot.hasData)
                        ? DecorationImage(
                            image: CachedNetworkImageProvider(snapshot.data!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                );
              },
            ),
            // SizedBox(
            //   height: 52,
            //   width: 52,
            //   child: Stack(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.all(5),
            //         child: ClipRRect(
            //           borderRadius: BorderRadius.circular(12.0),
            //           child: (widget.user?.id ?? '').isNotEmpty
            //               ? FutureBuilder(
            //                   future: userService
            //                       .getProfileImageURL(userApp!.id!.id),
            //                   builder: (_, AsyncSnapshot<String> snapshot) {
            //                     if (snapshot.hasData) {
            //                       return Image(
            //                         image: CachedNetworkImageProvider(
            //                             snapshot.data!),
            //                         fit: BoxFit.cover,
            //                         width: double.infinity,
            //                         height: double.infinity,
            //                       );
            //                     } else {
            //                       return const Image(
            //                         image:
            //                             AssetImage('assets/images/profile.png'),
            //                         fit: BoxFit.cover,
            //                         width: double.infinity,
            //                         height: double.infinity,
            //                       );
            //                     }
            //                   },
            //                 )
            //               : Image.asset(
            //                   'assets/images/profile_pic_',
            //                   fit: BoxFit.cover,
            //                   width: double.infinity,
            //                   height: double.infinity,
            //                 ),
            //         ),
            //       ),
            //       if (isOnline)
            //         Align(
            //           alignment: Alignment.bottomRight,
            //           child: SvgPicture.asset('assets/images/icon_online.svg'),
            //         ),
            //     ],
            //   ),
            // ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          userApp?.fullName ?? 'Usuari@',
                          style: AppStyles.ligthTextTheme.bodyMedium?.copyWith(
                            color: AppColors.darkGrey,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                      const SizedBox(width: 15),
                      TalentCard(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        color: AppColors.brandColor.withOpacity(0.15),
                        content: Text(
                          userApp?.type ?? '',
                          style: AppStyles.ligthTextTheme.bodyMedium
                              ?.copyWith(color: AppColors.blueColor),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (widget.chatObject?['messages'].isNotEmpty &&
                          widget.chatObject?['messages']?.last?['userId'] ==
                              userService.userApp!.id)
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(
                            widget.chatObject?['messages']?.last?['read'] ==
                                    true
                                ? Icons.done_all
                                : Icons.done,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          widget.chatObject?['messages'].isEmpty
                              ? ''
                              : widget.chatObject?['messages']?.last['content'],
                          style: AppStyles.ligthTextTheme.bodyMedium
                              ?.copyWith(color: AppColors.greyscale5),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Text(
                //   widget.chatObject?['messages'].isEmpty
                //       ? ''
                //       : AdvancedDateFormatter(Localization.of(context))
                //           .getVerboseDateTimeRepresentation(
                //               DateTime.fromMillisecondsSinceEpoch((widget
                //                       .chatObject?['messages']
                //                       .last['date'] as Timestamp)
                //                   .millisecondsSinceEpoch)),
                //   style: AppStyles.ligthTextTheme.bodyMedium?.copyWith(
                //     color: AppColors.darkGrey,
                //     fontSize: AppDimens.textSemiMedium,
                //   ),
                // ),
                if (newMessagesNumber > 0)
                  TalentCard(
                    color: AppColors.brandColor,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    content: Text(newMessagesNumber.toString(),
                        style: AppStyles.darkTextTheme.bodyLarge),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  RelativeRect _getRelativeRect(Offset offset) {
    double left = offset.dx;
    double top = offset.dy;

    return RelativeRect.fromLTRB(left, top, left + 20, top + 20);
  }
}

// class _MessagesSearchInput extends StatelessWidget {
//   const _MessagesSearchInput({
//     required this.formKey,
//     required this.searchFieldController,
//     required this.responsive,
//     Key? key,
//   }) : super(key: key);

//   final GlobalKey<FormState> formKey;
//   final TextEditingController searchFieldController;
//   final Responsive responsive;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         top: responsive.heightPercent(2),
//         left: responsive.widthPercent(4),
//         right: responsive.widthPercent(4),
//       ),
//       child: Form(
//         key: formKey,
//         child: Column(
//           children: [
//             Theme(
//               data: Theme.of(context).copyWith(
//                   colorScheme: ColorScheme.fromSwatch()
//                       .copyWith(primary: AppColors.brandColor),
//                   textTheme: const TextTheme(
//                       subtitle1: TextStyle(
//                     color: Colors.black,
//                   ))),
//               child: TextFormField(
//                 controller: searchFieldController,
//                 keyboardType: TextInputType.text,
//                 style: AppStyles.ligthTextTheme.labelSmall,
//                 decoration: InputDecoration(
//                   contentPadding: const EdgeInsets.symmetric(
//                       vertical: 14.0, horizontal: 25.0),
//                   filled: true,
//                   fillColor: AppColors.whiteColor,
//                   enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: AppColors.lightGrey),
//                       borderRadius: BorderRadius.circular(10)),
//                   focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: AppColors.brandColor),
//                       borderRadius: BorderRadius.circular(10)),
//                   hintText: Localization.of(context)
//                       .string('messages_home_search_hint'),
//                   suffixIcon: const Icon(Icons.search),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
