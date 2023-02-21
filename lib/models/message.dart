import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageStatus { Read, Sending, Sent }

class Message {
  String? id;
  String? content;
  Timestamp? dateTime;
  DocumentReference? userId;
  MessageStatus? messageStatus;

  Message({
    this.id,
    this.content,
    this.dateTime,
    this.userId,
    this.messageStatus,
  });

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    dateTime = json['dateTime'];
    userId = json['userId'];
    switch (json['messageStatus']) {
      case 'Read':
        messageStatus = MessageStatus.Read;
        break;
      // case 'Sending':
      //   messageStatus = MessageStatus.Sending;
      //   break;
      case 'Sent':
        messageStatus = MessageStatus.Sent;
        break;
      default:
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['dateTime'] = dateTime;
    data['userId'] = userId;
    data['messageStatus'] = messageStatus;

    return data;
  }
}
