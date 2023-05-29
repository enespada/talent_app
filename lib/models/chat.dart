import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:talent_app/models/models.dart';

class Chat {
  DocumentReference? id;
  String? name;
  List<DocumentReference>? users;
  String? urlImage;
  List<Message>? messages;
  //Parametros que no estan en firebase
  UserApp? userApp;

  Chat({
    this.name,
    this.users,
    this.messages,
    this.urlImage,
    this.userApp,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    users = [];
    for (dynamic aux in json['users']) {
      if (aux != null) users?.add(aux as DocumentReference);
    }
    messages = json['messages'];
    // messages = [];
    // for (dynamic messageData in json['messages']) {
    //   messages!.add(Message.fromJson(messageData));
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['users'] = users;
    data['messages'] = messages;
    // data['messages'] = messages;

    return data;
  }
}
