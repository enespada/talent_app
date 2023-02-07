import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talent_app/models/models.dart';

abstract class Publication {
  late String? id;
  late DocumentReference? userId;
  late UserApp? userApp; // Don't put on toJson()/fromJson()

  Publication({
    this.id,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['user'] = userId;

    return data;
  }

  Publication.fromJson(Map<String, dynamic> json) {
    userId = json['user'];
  }
}
