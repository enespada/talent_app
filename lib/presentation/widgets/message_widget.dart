import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/presentation/screens/style/styles.dart';
import 'package:talent_app/utils/utils.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final AnimationController animationController;

  const MessageWidget({
    Key? key,
    required this.message,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final UserService userService =
        Provider.of<UserService>(context, listen: false);

    const double margenMensajePantalla = 5;
    // final double margenMensajeContrario = responsive.widthPercent(25);
    const double radius = 20;

    final bool myMessage = (message.userId == userService.userApp!.id);

    bool oneLineMessage = false;
    double contentWidth = Util.stringWidth(message.content!);
    double maxWidth = responsive.widthPercent(70);

    if (contentWidth < responsive.widthPercent(50)) {
      oneLineMessage = true;
      if (myMessage) {
        maxWidth = contentWidth + responsive.widthPercent(22);
      } else {
        maxWidth = contentWidth + responsive.widthPercent(18);
      }
      // if (contentWidth < responsive.widthPercent(20)) {
      //   maxWidth = responsive.widthPercent(20);
      // } else {
      //   maxWidth = contentWidth + contentWidth * 0.5;
      // }
    }

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut,
        ),
        child: Align(
          alignment: myMessage ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(
              // left: myMessage ? margenMensajeContrario : margenMensajePantalla,
              // right: myMessage ? margenMensajePantalla : margenMensajeContrario,
              left: myMessage ? 0 : margenMensajePantalla,
              right: myMessage ? margenMensajePantalla : 0,
              bottom: 7,
            ),
            constraints: BoxConstraints(minWidth: 0, maxWidth: maxWidth),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: myMessage
                  ? AppColors.greyscale5
                  : AppColors.greyscale1.withOpacity(0.5),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: (!oneLineMessage)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.content ?? '',
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: myMessage
                                  ? AppColors.whiteColor
                                  : AppColors.blackColor,
                              fontSize: responsive.widthPercent(3.8),
                            ),
                      ),
                      const SizedBox(width: 5),
                      _HourAndTick(
                        message: message,
                        myMessage: myMessage,
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message.content ?? '',
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: myMessage
                                  ? AppColors.whiteColor
                                  : AppColors.blackColor,
                              fontSize: responsive.widthPercent(3.8),
                            ),
                      ),
                      const SizedBox(width: 5),
                      _HourAndTick(
                        message: message,
                        myMessage: myMessage,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _HourAndTick extends StatelessWidget {
  final Message message;
  final bool myMessage;

  const _HourAndTick({
    Key? key,
    required this.message,
    required this.myMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        message.timestamp!.millisecondsSinceEpoch);
    String hourString =
        '${dateTime.hour}:${(dateTime.minute < 10) ? '0${dateTime.minute}' : dateTime.minute}';
    Icon? stateIcon;

    double iconSize = (responsive.diagonalPercent(2) >= 15)
        ? responsive.diagonalPercent(2)
        : 15;
    switch (message.messageStatus!) {
      case MessageStatus.Sending:
        stateIcon = Icon(
          Icons.done,
          color: AppColors.greyscale2,
          size: iconSize,
        );
        break;
      case MessageStatus.Sent:
        stateIcon = Icon(
          Icons.done_all,
          color: AppColors.greyscale2,
          size: iconSize,
        );
        break;
      case MessageStatus.Read:
        stateIcon = Icon(
          Icons.done_all,
          color: AppColors.blueColor,
          size: iconSize,
        );
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          hourString,
          style: TextStyle(
            fontSize: responsive.diagonalPercent(1.5),
            color: AppColors.greyscale2,
          ),
        ),
        if (myMessage) const SizedBox(width: 2),
        if (myMessage) stateIcon,
      ],
    );
  }
}
