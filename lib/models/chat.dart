import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talent_app/models/models.dart';

class Chat {
  DocumentReference? id;
  List<DocumentReference>? users;
  List<Message>? messages;

  Chat({
    this.id,
    this.users,
    this.messages,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    users = [];
    for (dynamic aux in json['users']) {
      if (aux != null) users?.add(aux as DocumentReference);
    }
    messages = [];
    for (dynamic messageData in json['messages']) {
      messages!.add(Message.fromJson(messageData));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['users'] = users;
    data['messages'] = messages;

    return data;
  }
}
