import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:talent_app/models/models.dart';

class Chat {
  DocumentReference? id;
  String? name;
  String? urlImage;
  List<DocumentReference>? users;
  List<Message>? messages;
  //Parametros que no estan en firebase
  //Usuario contrario al logueado
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
    urlImage = json['urlImage'];
    users = [];
    for (dynamic aux in json['users']) {
      if (aux != null) users?.add(aux as DocumentReference);
    }
    messages = [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['urlImage'] = urlImage;
    data['users'] = users;
    return data;
  }
}
