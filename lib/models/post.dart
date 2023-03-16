import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:talent_app/models/models.dart';

class Post {
  String? id;
  DocumentReference? userId;
  UserApp? userApp;
  String? description;
  // List<String>? locations;
  List<String>? files;
  Timestamp? timestamp;
  DocumentReference? sportType;
  DocumentReference? modality;

  Post({
    String? id,
    DocumentReference? userId,
    required this.description,
    // required this.locations,
    required this.files,
    required this.timestamp,
    required this.sportType,
    required this.modality,
  }) : super();

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = userId;
    data['description'] = description;
    // data['locations'] = locations;
    data['files'] = files;
    data['timestamp'] = timestamp;
    data['sportType'] = sportType;
    data['modality'] = modality;

    return data;
  }

  Post.fromJson(Map<String, dynamic> json) {
    userId = json['user'];
    description = json['description'];
    // locations = [];
    // for (String location in json['locations']) {
    //   locations.add(location);
    // }
    files = [];
    for (String file in json['files']) {
      files!.add(file);
    }
    timestamp = json['timestamp'];
    sportType = json['sportType'];
    modality = json['modality'];
  }
}
