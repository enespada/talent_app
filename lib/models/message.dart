import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? id;
  String? content;
  Timestamp? dateTime;
  DocumentReference? userId;

  Message({
    this.id,
    this.content,
    this.dateTime,
    this.userId,
  });

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    dateTime = json['dateTime'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['dateTime'] = dateTime;
    data['userId'] = userId;

    return data;
  }
}
