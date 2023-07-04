import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/presentation/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/presentation/widgets/widgets.dart';

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

      //----------------------------------body-----------------------------------
      body: (chatsService.isLoadingChats)
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.blueColor),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: chatsService.chats!.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: (index == chatsService.chats!.length - 1)
                      ? null
                      : const EdgeInsets.only(bottom: 7),
                  child: _ChatWidget(chat: chatsService.chats![index]),
                );
              },
            ),

      //----------------------CustomBottomNavigationBar--------------------------
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 3,
      ),
    );
  }
}

class _ChatWidget extends StatefulWidget {
  final Chat chat;

  const _ChatWidget({Key? key, required this.chat}) : super(key: key);

  @override
  State<_ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<_ChatWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserService userService = Provider.of<UserService>(
      context,
      listen: false,
    );
    final ChatsService chatsService = Provider.of<ChatsService>(
      context,
      listen: true,
    );

    final Responsive responsive = Responsive.of(context);

    Widget? stateIcon;
    int? pendingMessages;
    if (widget.chat.messages!.isNotEmpty) {
      if (widget.chat.messages!.last.userId == userService.userApp!.id) {
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
      } else {
        int n = widget.chat.messages!.length;
        int i = n - 1;
        bool end = false;
        while (i >= 0 && !end) {
          switch (widget.chat.messages![i].messageStatus!) {
            case MessageStatus.Sending:
              end = true;
              break;
            case MessageStatus.Sent:
              pendingMessages ??= 0;
              pendingMessages = pendingMessages + 1;
              break;
            case MessageStatus.Read:
              end = false;
              break;
          }
          i--;
        }
      }
    }

    return InkWell(
      onTap: () async {
        // for (StreamSubscription<QuerySnapshot<Map<String, dynamic>>> element
        //     in chatsService.chatsScreenSS ?? []) {
        //   if (!element.isPaused) element.pause();
        // }
        // await chatsService.setUpChatStreamSubscription(
        //   widget.chat,
        //   userService.userApp!,
        // );
        await Util.operationsBeforeChatScreen(
          context,
          chatsService,
          widget.chat,
          userService.userApp!,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        // height: responsive.heightPercent(11),
        child: Row(
          children: [
            FutureBuilder(
              future: chatsService.getChatImageURL(
                chat: widget.chat,
                loggedUserApp: userService.userApp!,
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
            SizedBox(width: responsive.widthPercent(5.5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //-------------------Nombre y TalentCard-------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: responsive.widthPercent(34),
                        child: Text(
                          widget.chat.name ??
                              widget.chat.userApp?.fullName ??
                              '',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppColors.greyscale5,
                                    fontSize: responsive.diagonalPercent(1.8),
                                    fontWeight: FontWeight.bold,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.chat.userApp != null)
                        TalentCard(
                          color: AppColors.blueColor.withOpacity(0.15),
                          content: Text(
                            widget.chat.userApp?.type ?? '',
                            style: AppThemes.lightTextTheme.bodyLarge!.copyWith(
                              color: AppColors.blueColor,
                              fontSize: responsive.diagonalPercent(1.8),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: responsive.heightPercent(1.3)),

                  //----------------(Tick) Mensaje y numero-----------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (stateIcon != null) stateIcon,
                          if (stateIcon != null) const SizedBox(width: 5),
                          SizedBox(
                            width: responsive.widthPercent(55),
                            child: Text(
                              widget.chat.messages!.isEmpty
                                  ? ''
                                  : widget.chat.messages!.last.content ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: AppColors.greyscale5,
                                    fontSize: responsive.diagonalPercent(1.8),
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // if (pendingMessages != null)
                          //   SizedBox(width: responsive.widthPercent(25)),
                        ],
                      ),
                      if (pendingMessages != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.blueColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$pendingMessages',
                            style: AppThemes.darkTextTheme.bodyLarge!.copyWith(
                              fontSize: responsive.diagonalPercent(1.4),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
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
