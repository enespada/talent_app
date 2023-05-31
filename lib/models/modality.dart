import 'package:cloud_firestore/cloud_firestore.dart';

class Modality {
  DocumentReference? id;
  String? name;
  DocumentReference? sport;

  Modality({this.id, this.name, this.sport});

  Modality.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sport = json['sport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['sport'] = sport;
    return data;
  }
}
