import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talent_app/models/models.dart';

class Chat {
  DocumentReference? id;
  String? name;
  List<DocumentReference>? users;
  List<Message>? messages;
  //Parametros que no estan en firebase
  String? urlImage;

  Chat({
    // this.id,
    this.name,
    this.users,
    this.messages,
    this.urlImage,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    name = json['name'];
    users = [];
    for (dynamic aux in json['users']) {
      if (aux != null) users?.add(aux as DocumentReference);
    }
    // messages = [];
    // for (dynamic messageData in json['messages']) {
    //   messages!.add(Message.fromJson(messageData));
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['id'] = id;
    data['name'] = name;
    data['users'] = users;
    // data['messages'] = messages;

    return data;
  }
}
