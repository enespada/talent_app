import 'package:cloud_firestore/cloud_firestore.dart';

class Sport {
  DocumentReference? id;
  String? name;

  Sport({this.id, this.name});

  Sport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
