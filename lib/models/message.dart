import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageStatus { Read, Sending, Sent }

class Message {
  DocumentReference? id;
  String? content;
  Timestamp? timestamp;
  DocumentReference? userId;
  MessageStatus? messageStatus;

  Message({
    this.id,
    this.content,
    this.timestamp,
    this.userId,
    this.messageStatus,
  });

  Message.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    timestamp = json['timestamp'];
    userId = json['userId'];
    switch (json['messageStatus']) {
      case 'Sending':
        messageStatus = MessageStatus.Sending;
        break;
      case 'Sent':
        messageStatus = MessageStatus.Sent;
        break;
      case 'Read':
        messageStatus = MessageStatus.Read;
        break;
      default:
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['timestamp'] = timestamp;
    data['userId'] = userId;
    switch (messageStatus) {
      case MessageStatus.Sending:
        data['messageStatus'] = 'Sending';
        break;
      case MessageStatus.Sent:
        data['messageStatus'] = 'Sent';
        break;
      case MessageStatus.Read:
        data['messageStatus'] = 'Read';
        break;
      default:
    }

    return data;
  }

  String messageStatusToString() {
    switch (messageStatus) {
      case MessageStatus.Sending:
        return 'Sending';
      case MessageStatus.Sent:
        return 'Sent';
      case MessageStatus.Read:
        return 'Read';
      default:
    }
    return '';
  }
}
