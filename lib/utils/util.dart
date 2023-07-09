import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/presentation/screens/screens.dart';
import 'package:talent_app/services/services.dart';
import 'package:talent_app/presentation/style/styles.dart';
import 'package:talent_app/utils/utils.dart';

class Util {
  static String adaptNumFollow(double value) {
    String string;
    if (value > 0) {
      if (value >= 1000000) {
        if (value < 100000000) {
          string = '${(value / 1000000)}';
          string =
              '${string.split('.')[0]}.${string.split('.')[1].substring(0, 1)} M';
          // string = '${(value / 1000000).toStringAsFixed(1)} M ';
        } else {
          string = '${(value / 1000000).truncate()} M ';
        }
      } else {
        if (value < 100000) {
          if (value < 1000) {
            string = '${value.truncate()}';
          } else {
            string = '${(value / 1000)}';
            print(string);
            string =
                '${string.split('.')[0]}.${string.split('.')[1].substring(0, 1)} K';
            // string = '${(value / 1000).toStringAsFixed(1)} K ';
          }
        } else {
          string = '${(value / 1000).truncate()} K ';
        }
      }
    } else {
      if (value == 0) {
        string = '0';
      } else {
        string = '';
      }
    }

    return string;
  }

  static String postTimestamp(Timestamp timestamp) {
    String string = '';
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    DateTime dateTimeNow = DateTime.now();
    if (dateTimeNow.difference(dateTime).inHours < 1) {
      string = 'Hace ${dateTimeNow.difference(dateTime).inMinutes} minutos';
    } else {
      if (dateTimeNow.difference(dateTime).inHours < 24) {
        string = 'Hace ${dateTimeNow.difference(dateTime).inHours} horas';
      } else {
        if (dateTimeNow.difference(dateTime).inHours < 48) {
          string = 'Ayer';
        } else {
          string = '${dateTime.day}-${dateTime.month}-${dateTime.year}';
        }
      }
    }
    return string;
  }

  static String messageDateTimeToString(DateTime dateTime) {
    DateTime dateTimeNow = DateTime.now();

    if (dateTime.day == dateTimeNow.day &&
        dateTime.month == dateTimeNow.month &&
        dateTime.year == dateTimeNow.year) return 'Hoy';
    print(dateTimeNow.subtract(const Duration(days: 1)));
    DateTime dateTimeYesterday = dateTimeNow.subtract(const Duration(days: 1));
    if (dateTime.day == dateTimeYesterday.day &&
        dateTime.month == dateTimeYesterday.month &&
        dateTime.year == dateTimeYesterday.year) {
      return 'Ayer';
    }
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
  }

  // static double stringHeight(String string) {
  //   TextPainter textPainter = TextPainter()
  //     ..text = TextSpan(text: string)
  //     ..textDirection = TextDirection.ltr
  //     ..layout(minWidth: 0, maxWidth: double.infinity);

  //   return textPainter.size.height;
  // }

  static double stringWidth(String string) {
    TextPainter textPainter = TextPainter()
      ..text = TextSpan(text: string)
      ..textDirection = TextDirection.ltr
      ..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.size.width;
  }

  static Future<dynamic> showLoadingDialog({
    required BuildContext context,
    Widget? child,
    List<Widget>? actions,
  }) {
    if (Platform.isIOS) {
      return showCupertinoDialog(
          context: context,
          builder: (context) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: CupertinoAlertDialog(
                content: Container(
                  height: 100,
                  width: 100,
                  constraints: const BoxConstraints(minWidth: 0, maxWidth: 10),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blueColor,
                      strokeWidth: 4,
                    ),
                  ),
                ),
              ),
            );
          });
    }
    return showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            content: Container(
              height: 200,
              width: 200,
              constraints: const BoxConstraints(minWidth: 0, maxWidth: 10),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.blueColor,
                  strokeWidth: 4,
                ),
              ),
            ),
            backgroundColor: AppColors.blackColor,
          ),
        );
      },
    );
  }

  static Future<dynamic> showCustomDialog({
    required BuildContext context,
    Widget? child,
    List<Widget>? actions,
  }) {
    return showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final Responsive responsive = Responsive.of(context);

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            title: Text(
              Localization.of(context).string("common_notice"),
              style: AppThemes.darkTextTheme.bodyLarge!.copyWith(
                fontSize: responsive.diagonalPercent(3),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: child,
            backgroundColor: AppColors.blackColor,
            actions: actions,
          ),
        );
      },
    );
  }

  static String generateRandomString(int length) {
    final random = Random.secure();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  //Este metodo solo puede llamarse desde la capa de presentacion (presentation)
  //Podria ser mejor opcion meterlo en una clase de utilidades dentro de
  //la carpeta presentation
  static Future<void> operationsBeforeChatScreen(
    BuildContext context,
    ChatsService chatsService,
    Chat chat,
    UserApp loggedUserApp,
  ) async {
    chatsService.activeChat = chat;
    await chatsService.readMessages(chat, loggedUserApp);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(chat: chat),
      ),
    );
  }
}
