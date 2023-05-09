import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talent_app/models/models.dart';

class Chat {
  DocumentReference? id;
  List<DocumentReference>? users;
  List<Message>? messages;
  String? name;
  //Parametros que no estan en firebase
  String? urlImage;

  Chat({
    this.id,
    this.users,
    this.messages,
    this.name,
    this.urlImage,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    users = [];
    for (dynamic aux in json['users']) {
      if (aux != null) users?.add(aux as DocumentReference);
    }
    messages = [];
    for (dynamic messageData in json['messages']) {
      messages!.add(Message.fromJson(messageData));
    }
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['id'] = id;
    data['users'] = users;
    data['messages'] = messages;
    data['name'] = name;

    return data;
  }
}
