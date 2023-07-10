import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/presentation/widgets/custom_will_pop_scope.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/presentation/style/styles.dart';
import 'package:talent_app/utils/utils.dart';
import 'package:talent_app/presentation/widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController tec = TextEditingController();
  Color iconColor = AppColors.greyscale2;
  bool willPopBool = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> sendMessage({
    required ChatsService chatsService,
    required UserService userService,
  }) async {
    if (tec.text.isEmpty) return;
    String text = tec.text;
    tec.clear();
    // _focusNode.requestFocus();
    Message newMessage = Message(
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
    // widget.chat.messages!.add(newMessage);
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

    String title = widget.chat.name ?? widget.chat.userApp?.fullName ?? '';

    return CustomWillPopScope(
      action: () async {
        // for (StreamSubscription<QuerySnapshot<Map<String, dynamic>>> element
        //     in chatsService.chatsScreenSS ?? []) {
        //   element.resume();
        // }
        // chatsService.chatsScreenSS?.resume();
        // await chatsService.chatScreenSS?.cancel();
        chatsService.activeChat = null;
        return;
      },
      onWillPop: true,
      child: Scaffold(
        //-------------------------------appBar-----------------------------------
        appBar: _ChatAppBar(
          title: title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: responsive.diagonalPercent(2.2),
              ),
          chat: widget.chat,
          onTap: () => Navigator.maybePop(context),
        ),

        //--------------------------------body-------------------------------------
        body: SafeArea(
          child: GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: Column(
              children: [
                //---------------------------Mensajes----------------------------------
                Expanded(child: _MessagesList(chat: widget.chat)),

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

    // return WillPopScope(
    //   onWillPop: () async {
    //     // for (StreamSubscription<QuerySnapshot<Map<String, dynamic>>> element
    //     //     in chatsService.chatsScreenSS ?? []) {
    //     //   element.resume();
    //     // }
    //     // chatsService.chatsScreenSS?.resume();
    //     // await chatsService.chatScreenSS?.cancel();
    //     chatsService.activeChat = null;
    //     return true;
    //   },
    //   // shouldAddCallback: true,
    //   child: Scaffold(
    //     //-------------------------------appBar-----------------------------------
    //     appBar: _ChatAppBar(
    //       title: title,
    //       style: Theme.of(context).textTheme.bodyLarge!.copyWith(
    //             fontSize: responsive.diagonalPercent(2.2),
    //           ),
    //       chat: widget.chat,
    //       onTap: () => Navigator.maybePop(context),
    //     ),

    //     //--------------------------------body-------------------------------------
    //     body: SafeArea(
    //       child: GestureDetector(
    //         onTap: FocusScope.of(context).unfocus,
    //         child: Column(
    //           children: [
    //             //---------------------------Mensajes----------------------------------
    //             Expanded(child: _MessagesList(chat: widget.chat)),

    //             //-------------------------Escribe...--------------------------------
    //             Align(
    //               alignment: Alignment.bottomCenter,
    //               child: Container(
    //                 padding: const EdgeInsets.all(10),
    //                 width: responsive.width,
    //                 child: Row(
    //                   children: [
    //                     Expanded(
    //                       child: TextField(
    //                         controller: tec,
    //                         keyboardType: TextInputType.text,
    //                         keyboardAppearance: Brightness.light,
    //                         style:
    //                             Theme.of(context).textTheme.bodyLarge!.copyWith(
    //                                   color: AppColors.greyscale5,
    //                                 ),
    //                         decoration: InputDecoration(
    //                           contentPadding: const EdgeInsets.symmetric(
    //                             vertical: 14.0,
    //                             horizontal: 25.0,
    //                           ),
    //                           filled: true,
    //                           fillColor: AppColors.lightGrey,
    //                           border: const OutlineInputBorder(
    //                             borderRadius:
    //                                 BorderRadius.all(Radius.circular(10)),
    //                             borderSide: BorderSide(
    //                                 width: 0, style: BorderStyle.none),
    //                           ),
    //                           hintText: Localization.of(context)
    //                               .string('messages_chat_type_hint'),
    //                           hintStyle:
    //                               AppThemes.darkTextTheme.bodyLarge!.copyWith(
    //                             color: AppColors.greyscale2,
    //                           ),
    //                           suffixIcon: InkWell(
    //                             borderRadius: BorderRadius.circular(50),
    //                             onTap: () async {
    //                               await sendMessage(
    //                                 chatsService: chatsService,
    //                                 userService: userService,
    //                               );
    //                             },
    //                             child: Padding(
    //                               padding: const EdgeInsets.all(10),
    //                               child: SvgPicture.asset(
    //                                 'assets/images/icon_send.svg',
    //                                 color: iconColor,
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                         onChanged: (String text) {
    //                           iconColor = (text.isNotEmpty)
    //                               ? AppColors.blueColor
    //                               : AppColors.greyscale2;
    //                           setState(() {});
    //                         },
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
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

class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextStyle? style;
  final Chat chat;
  final void Function()? onTap;
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
    required this.onTap,
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
                  onTap: onTap,
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
                    loggedUserApp: userService.userApp!,
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
