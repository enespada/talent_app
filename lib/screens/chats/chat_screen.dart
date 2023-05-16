import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/widgets/widgets.dart';

enum MessagesChatMenu { example1, example2 }

enum MessagesChatState { sending, sent, received }

class ChatScreen extends StatefulWidget {
  final Chat chat;
  final UserApp? userApp;

  const ChatScreen({
    Key? key,
    required this.chat,
    this.userApp,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  // final formKey = GlobalKey<FormState>();
  final TextEditingController tec = TextEditingController();
  Color iconColor = AppColors.greyscale2;

  @override
  void initState() {
    super.initState();
  }

  Future<void> sendMessage({
    required ChatsService chatsService,
    required UserService userService,
  }) async {
    if (tec.text.isEmpty) return;
    String text = tec.text;
    tec.clear();
    // _focusNode.requestFocus();

    // String messageId = Util.generateRandomString(22);

    Message newMessage = Message(
      // id: messageId,
      content: text,
      timestamp: Timestamp.now(),
      userId: userService.userApp!.id,
      messageStatus: MessageStatus.Sending,
    );
    final MessageWidget newMessageWidget = MessageWidget(
      message: newMessage,
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );
    widget.chat.messages!.add(newMessage);
    newMessageWidget.animationController.forward();
    await chatsService.uploadMessage(widget.chat, newMessage);
    // socketService.socket.emit('mensaje-personal', {
    //   'de': authService.usuario!.uid,
    //   'para': chatService.usuarioDestino.uid,
    //   'mensaje': text
    // });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final UserService userService = Provider.of<UserService>(context);
    final ChatsService chatsService = Provider.of<ChatsService>(context);

    final Responsive responsive = Responsive.of(context);

    String title = widget.chat.name ?? widget.userApp?.fullName ?? '';

    return WillPopScope(
      onWillPop: () async {
        for (StreamSubscription<QuerySnapshot<Map<String, dynamic>>> element
            in chatsService.chatsScreenSS ?? []) {
          element.resume();
        }
        // chatsService.chatsScreenSS?.resume();
        await chatsService.chatScreenSS?.cancel();
        return true;
      },
      child: Scaffold(
        //-------------------------------appBar-----------------------------------
        appBar: _ChatAppBar(
          title: title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: responsive.diagonalPercent(2.2),
              ),
          chat: widget.chat,
        ),

        //--------------------------------body-------------------------------------
        body: SafeArea(
          child: GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: Column(
              children: [
                //---------------------------Mensajes----------------------------------
                Expanded(
                  child: _MessagesList(chat: widget.chat),
                ),

                //-------------------------Escribe...--------------------------------
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: responsive.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: tec,
                            keyboardType: TextInputType.text,
                            keyboardAppearance: Brightness.light,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: AppColors.greyscale5,
                                    ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14.0,
                                horizontal: 25.0,
                              ),
                              filled: true,
                              fillColor: AppColors.lightGrey,
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    width: 0, style: BorderStyle.none),
                              ),
                              hintText: Localization.of(context)
                                  .string('messages_chat_type_hint'),
                              hintStyle:
                                  AppThemes.darkTextTheme.bodyLarge!.copyWith(
                                color: AppColors.greyscale2,
                              ),
                              suffixIcon: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () async {
                                  await sendMessage(
                                    chatsService: chatsService,
                                    userService: userService,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: SvgPicture.asset(
                                    'assets/images/icon_send.svg',
                                    color: iconColor,
                                  ),
                                ),
                              ),
                            ),
                            onChanged: (String text) {
                              iconColor = (text.isNotEmpty)
                                  ? AppColors.blueColor
                                  : AppColors.greyscale2;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _chatViewModel.dispose();
  }
}

class _MessagesList extends StatefulWidget {
  final Chat chat;

  const _MessagesList({Key? key, required this.chat}) : super(key: key);

  @override
  State<_MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<_MessagesList>
    with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  List<Widget> messageWidgets = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final Responsive responsive = Responsive.of(context);
    DateTime? dtPrevious;

    return ListView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      reverse: true,
      itemCount: widget.chat.messages!.length,
      itemBuilder: (context, index) {
        Message currentMessage =
            widget.chat.messages![widget.chat.messages!.length - index - 1];
        //=======================SI ES EL ULTIMO=========================
        if (index == widget.chat.messages!.length - 1) {
          String s2 = Util.messageDateTimeToString(
            DateTime.fromMillisecondsSinceEpoch(
              currentMessage.timestamp!.millisecondsSinceEpoch,
            ),
          );
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(s2),
              ),
              MessageWidget(
                animationController: AnimationController(
                  vsync: this,
                  duration: const Duration(milliseconds: 0),
                )..forward(),
                message: currentMessage,
              ),
            ],
          );
        }
        //C1: Mensaje actual es el primero
        if (dtPrevious == null) {
          dtPrevious = DateTime.fromMillisecondsSinceEpoch(
              currentMessage.timestamp!.millisecondsSinceEpoch);
          return MessageWidget(
            animationController: AnimationController(
              vsync: this,
              duration: const Duration(milliseconds: 0),
            )..forward(),
            message: currentMessage,
          );
        } else {
          DateTime dtCurrent = DateTime.fromMillisecondsSinceEpoch(
            currentMessage.timestamp!.millisecondsSinceEpoch,
          );
          //C2: Mensajes actual y anterior de fechas distintas
          if (dtPrevious!.day != dtCurrent.day ||
              dtPrevious!.month != dtCurrent.month ||
              dtPrevious!.year != dtCurrent.year) {
            String s = Util.messageDateTimeToString(dtPrevious!);
            dtPrevious = DateTime.fromMillisecondsSinceEpoch(
                currentMessage.timestamp!.millisecondsSinceEpoch);
            //=======================SI ES EL ULTIMO=========================
            if (index == widget.chat.messages!.length - 1) {
              String s2 = Util.messageDateTimeToString(
                DateTime.fromMillisecondsSinceEpoch(
                  currentMessage.timestamp!.millisecondsSinceEpoch,
                ),
              );
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(' quqeee $s2'),
                  ),
                  MessageWidget(
                    animationController: AnimationController(
                      vsync: this,
                      duration: const Duration(milliseconds: 0),
                    )..forward(),
                    message: currentMessage,
                  ),
                  Padding(padding: const EdgeInsets.all(8.0), child: Text(s)),
                ],
              );
            }
            return Column(
              children: [
                MessageWidget(
                  animationController: AnimationController(
                    vsync: this,
                    duration: const Duration(milliseconds: 0),
                  )..forward(),
                  message: currentMessage,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(s),
                ),
              ],
            );
          }
          //C3: Mensajes actual y anterior de fechas la misma fecha
          else {
            dtPrevious = DateTime.fromMillisecondsSinceEpoch(
                currentMessage.timestamp!.millisecondsSinceEpoch);
            //=======================SI ES EL ULTIMO=========================
            if (index == widget.chat.messages!.length - 1) {
              String s2 = Util.messageDateTimeToString(
                DateTime.fromMillisecondsSinceEpoch(
                  currentMessage.timestamp!.millisecondsSinceEpoch,
                ),
              );
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(s2),
                  ),
                  MessageWidget(
                    animationController: AnimationController(
                      vsync: this,
                      duration: const Duration(milliseconds: 0),
                    )..forward(),
                    message: currentMessage,
                  ),
                ],
              );
            }
            return MessageWidget(
              animationController: AnimationController(
                vsync: this,
                duration: const Duration(milliseconds: 0),
              )..forward(),
              message: currentMessage,
            );
          }
        }
      },
    );
  }
}

// class _MessagesTimestamp extends StatelessWidget {
//   const _MessagesTimestamp({
//     required this.text,
//     Key? key,
//   }) : super(key: key);

//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 25),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             text,
//             style: AppStyles.ligthTextTheme.bodyMedium
//                 ?.copyWith(color: AppColors.darkGrey),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _MessagesItemVisitor extends StatelessWidget {
//   const _MessagesItemVisitor({
//     required this.text,
//     required this.time,
//     Key? key,
//     required this.userContactId,
//   }) : super(key: key);

//   final String text;
//   final bool hideProfilePic = false;
//   final String time;
//   final String userContactId;

//   //TODO: Change these variables for chat entity
//   final int newMessagesNumber =
//       3; // If <= 0 : neither shadow border nor number circle
//   final bool isOnline = false; // If true : Online icon bottom right

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (hideProfilePic)
//           const SizedBox(
//             width: 52,
//           ),
//         if (!hideProfilePic)
//           SizedBox(
//             width: 52,
//             height: 52,
//             child: Stack(
//               children: [
//                 Padding(
//                     padding: const EdgeInsets.all(5),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12.0),
//                       child: FutureBuilder(
//                           future: Utils.profileImageURL(userContactId),
//                           builder: (_, AsyncSnapshot<String> snapshot) {
//                             if (snapshot.hasData) {
//                               return Image(
//                                 image:
//                                     CachedNetworkImageProvider(snapshot.data!),
//                                 fit: BoxFit.cover,
//                                 width: 36,
//                                 height: 36,
//                               );
//                             } else {
//                               return const Image(
//                                 image: AssetImage('assets/images/profile.png'),
//                                 fit: BoxFit.cover,
//                                 width: 36,
//                                 height: 36,
//                               );
//                             }
//                           }),
//                     )),
//                 if (isOnline)
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: SvgPicture.asset('assets/images/icon_online.svg'),
//                   )
//               ],
//             ),
//           ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: AppColors.lightGrey,
//               borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(12),
//                   bottomRight: Radius.circular(12),
//                   bottomLeft: Radius.circular(12)),
//               border: Border.all(color: AppColors.lightGrey),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   text,
//                   style: AppStyles.ligthTextTheme.bodyMedium
//                       ?.copyWith(color: AppColors.darkGrey),
//                 ),
//                 const SizedBox(width: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       time,
//                       style: AppStyles.ligthTextTheme.bodyMedium
//                           ?.copyWith(color: AppColors.darkGrey, fontSize: 11),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(width: 30),
//       ],
//     );
//   }
// }

// class _MessagesItemLocal extends StatelessWidget {
//   const _MessagesItemLocal({
//     required this.text,
//     required this.time,
//     Key? key,
//     required this.state,
//   }) : super(key: key);

//   final String text;

//   //TODO: Change these variables for chat entity
//   final int newMessagesNumber =
//       3; // If <= 0 : neither shadow border nor number circle
//   final bool isOnline = true; // If true : Online icon bottom right
//   final MessagesChatState state;
//   final String time;

//   @override
//   Widget build(BuildContext context) {
//     Widget stateIcon;

//     switch (state) {
//       case MessagesChatState.sending:
//         stateIcon = const Icon(Icons.access_time_outlined,
//             color: AppColors.whiteColor, size: 15);
//         break;
//       case MessagesChatState.sent:
//         stateIcon =
//             const Icon(Icons.done, color: AppColors.whiteColor, size: 15);
//         break;
//       case MessagesChatState.received:
//         stateIcon =
//             const Icon(Icons.done_all, color: AppColors.brandColor, size: 15);
//         break;
//     }

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(width: 100),
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.all(10),
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(12),
//                   bottomRight: Radius.circular(12),
//                   bottomLeft: Radius.circular(12)),
//               color: AppColors.greyscale5,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   text,
//                   style: AppStyles.ligthTextTheme.bodyMedium
//                       ?.copyWith(color: AppColors.whiteColor),
//                 ),
//                 const SizedBox(width: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       time,
//                       style: AppStyles.ligthTextTheme.bodyMedium
//                           ?.copyWith(color: AppColors.whiteColor, fontSize: 11),
//                     ),
//                     const SizedBox(width: 5),
//                     stateIcon,
//                   ],
//                 )
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextStyle? style;
  final Chat chat;
  @override
  final Size preferredSize;
  // @override
  // TODO: implement preferredSize
  // Size get preferredSize => preferredSize;

  const _ChatAppBar({
    Key? key,
    required this.title,
    required this.style,
    required this.chat,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserService userService = Provider.of<UserService>(context);
    final ChatsService chatsService = Provider.of<ChatsService>(context);

    final Responsive responsive = Responsive.of(context);

    return SafeArea(
      child: Container(
        // padding: EdgeInsets.only(
        //   top: responsive.heightPercent(2),
        //   left: responsive.widthPercent(4),
        //   right: responsive.widthPercent(4),
        //   bottom: responsive.heightPercent(2),
        // ),
        color: AppColors.whiteColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.blueColor,
                    size: responsive.diagonalPercent(4),
                  ),
                ),
                const SizedBox(width: 15),
                FutureBuilder(
                  future: chatsService.getChatImageURL(
                    chat: chat,
                    loguedUserApp: userService.userApp!,
                  ),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return Container(
                      height: responsive.diagonalPercent(4.5),
                      width: responsive.diagonalPercent(4.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: (snapshot.hasData)
                            ? DecorationImage(
                                image:
                                    CachedNetworkImageProvider(snapshot.data!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: style),
                    // Text(
                    //   chat.type ?? '',
                    //   style: AppStyles.ligthTextTheme.bodyMedium?.copyWith(
                    //     color: AppColors.darkGrey,
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
