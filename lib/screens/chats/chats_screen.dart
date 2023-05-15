import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/screens/screens.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

// enum MessagesHomeMenu { example1, example2 }

// enum MessagesHomeChatMenu { markRead, delete }

class ChatsScreen extends StatelessWidget {
  static const String routeName = 'chats_screen';

  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatsService chatsService = Provider.of<ChatsService>(
      context,
      listen: true,
    );

    final Responsive responsive = Responsive.of(context);

    // Widget body;
    // if (chatsService.isLoadingChats) {
    //   body = const Center(
    //     child: CircularProgressIndicator(color: AppColors.blueColor),
    //   );
    // } else {
    //   body = ListView.builder(
    //     physics: const BouncingScrollPhysics(),
    //     itemCount: chatsService.chats!.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return Container(
    //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //         child: ChatWidget(chat: chatsService.chats![index]),
    //       );
    //     },
    //   );
    // }

    return Scaffold(
      //--------------------------------appBar----------------------------------
      appBar: CustomAppBar(
        title: Localization.of(context).string("chats_screen_title"),
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: responsive.diagonalPercent(3),
              fontWeight: FontWeight.bold,
            ),
      ),

      //--------------------------------body----------------------------------
      body: SafeArea(
        child: (chatsService.isLoadingChats)
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.blueColor),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: chatsService.chats!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: _ChatWidget(chat: chatsService.chats![index]),
                  );
                },
              ),
      ),

      //----------------------CustomBottomNavigationBar--------------------------
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 3,
      ),
    );
  }
}

// class ChatsListWidget extends StatelessWidget {
//   const ChatsListWidget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final Responsive responsive = Responsive.of(context);
//     final ChatsService chatsService = Provider.of<ChatsService>(context);

//     if (chatsService.isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(color: AppColors.blueColor),
//       );
//     } else {
//       return ListView.builder(
//         physics: const BouncingScrollPhysics(),
//         itemCount: chatsService.chats!.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             child: ChatWidget(chat: chatsService.chats![index]),
//           );
//         },
//       );
//     }
//   }
// }

class _ChatWidget extends StatefulWidget {
  final Chat chat;

  const _ChatWidget({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  State<_ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<_ChatWidget> {
  //TODO: Change these variables for chat entity
  final int newMessagesNumber = 0;
  final bool isOnline = false;
  UserApp? userApp;

  Future<void> bringUser(UserService userService) async {
    //Si es un grupo (widget.chat.users!.length > 2)
    if (widget.chat.name != null) {
      //TODO GRUPOS: Traer imagen del grupo del Storage y el nombre del grupo
    } else {
      for (DocumentReference userId in widget.chat.users!) {
        if (userId != userService.userApp!.id) {
          // userApp = await userId.get();
          userId.get().then((DocumentSnapshot<Object?> value) {
            userApp = UserApp.fromJson(value.data() as Map<String, dynamic>);
            setState(() {});
            return;
          });
          break;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final UserService userService =
          Provider.of<UserService>(context, listen: false);
      bringUser(userService);
    });
    //TODO: Comprobar si hay mensajes nuevos
  }

  @override
  Widget build(BuildContext context) {
    final UserService userService = Provider.of<UserService>(context);
    final ChatsService chatsService = Provider.of<ChatsService>(context);

    final Responsive responsive = Responsive.of(context);

    Widget? stateIcon;
    if (widget.chat.messages!.isNotEmpty &&
        widget.chat.messages!.last.userId == userService.userApp!.id) {
      switch (widget.chat.messages!.last.messageStatus!) {
        case MessageStatus.Sending:
          stateIcon = const Icon(
            Icons.done,
            color: AppColors.greyscale2,
            size: 15,
          );
          break;
        case MessageStatus.Sent:
          stateIcon = const Icon(
            Icons.done_all,
            color: AppColors.greyscale2,
            size: 15,
          );
          break;
        case MessageStatus.Read:
          stateIcon = const Icon(
            Icons.done_all,
            color: AppColors.blueColor,
            size: 15,
          );
          break;
      }
    }

    return InkWell(
      onTap: () async {
        chatsService.chatsScreenSS?.pause();
        await chatsService.setUpChatStreamSubscription(
          widget.chat,
          userService.userApp!,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chat: widget.chat,
              userApp: userApp,
            ),
          ),
        );
      },
      child: Container(
        height: responsive.heightPercent(11),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            FutureBuilder(
              future: chatsService.getChatImageURL(
                chat: widget.chat,
                loguedUserApp: userService.userApp!,
              ),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Container(
                  height: responsive.diagonalPercent(7.5),
                  width: responsive.diagonalPercent(7.5),
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.chat.name ?? userApp?.fullName ?? '',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppColors.greyscale5,
                                    fontSize: responsive.diagonalPercent(1.8),
                                    fontWeight: FontWeight.bold,
                                  ),
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                      if (userApp != null)
                        SizedBox(width: responsive.widthPercent(3.8)),
                      if (userApp != null)
                        TalentCard(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          color: AppColors.blueColor.withOpacity(0.15),
                          content: Text(
                            userApp?.type ?? '',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: AppColors.blueColor,
                                      fontSize: responsive.diagonalPercent(1.8),
                                    ),
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      if (stateIcon != null) stateIcon,
                      if (stateIcon != null) const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.chat.messages!.isEmpty
                              ? ''
                              : widget.chat.messages!.last.content ?? '',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppColors.greyscale5,
                                    fontSize: responsive.diagonalPercent(1.8),
                                  ),
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
                // if (newMessagesNumber > 0)
                //   TalentCard(
                //     color: AppColors.blueColor,
                //     padding: const EdgeInsets.symmetric(horizontal: 10),
                //     content: Text(
                //       newMessagesNumber.toString(),
                //       style: AppStyles.darkTextTheme.bodyLarge,
                //     ),
                //   )
              ],
            ),
          ],
        ),
      ),
      // onLongPressStart: (LongPressStartDetails details) {
      //   showMenu(
      //       context: context,
      //       color: AppColors.shadowGrey,
      //       shape: const RoundedRectangleBorder(
      //         borderRadius: BorderRadius.all(Radius.circular(15)),
      //       ),
      //       position: _getRelativeRect(details.globalPosition),
      //       items: <PopupMenuEntry<MessagesHomeChatMenu>>[
      //         PopupMenuItem<MessagesHomeChatMenu>(
      //           value: MessagesHomeChatMenu.markRead,
      //           child: Row(
      //             children: [
      //               SvgPicture.asset(
      //                 'assets/images/icon_check.svg',
      //                 color: AppColors.whiteColor,
      //               ),
      //               const SizedBox(width: 10),
      //               Text(
      //                 Localization.of(context)
      //                     .string('messages_home_chat_mark_read'),
      //                 style: AppStyles.darkTextTheme.bodyLarge,
      //               ),
      //             ],
      //           ),
      //         ),
      //         PopupMenuItem<MessagesHomeChatMenu>(
      //           value: MessagesHomeChatMenu.delete,
      //           child: Row(
      //             children: [
      //               SvgPicture.asset(
      //                 'assets/images/icon_delete.svg',
      //                 color: AppColors.whiteColor,
      //               ),
      //               const SizedBox(width: 10),
      //               Text(
      //                 Localization.of(context)
      //                     .string('messages_home_chat_delete'),
      //                 style: AppStyles.darkTextTheme.bodyLarge,
      //               ),
      //             ],
      //           ),
      //         ),
      //       ]).then((value) {
      //     if (value == null) return;

      //     switch (value) {
      //       case MessagesHomeChatMenu.markRead:
      //         if (widget.chatObject != null) {
      //           // widget.viewModel.markAsReaded(widget.chatObject!);
      //         }
      //         break;
      //       case MessagesHomeChatMenu.delete:
      //         if (widget.chatObject != null) {
      //           // widget.viewModel.removeChat(
      //           //     widget.chatObject!); // Remove current user from chat
      //         }
      //         break;
      //     }
      //   });
      // },
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
