import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:talent_app/models/models.dart';

class Post extends Publication {
  String? description;
  List<String>? locations;
  List<String>? files;
  Timestamp? datetime;
  DocumentReference? sportType;
  DocumentReference? modality;
  bool? youLiked; // Don't put on toJson()/fromJson()

  Post({
    String? id,
    DocumentReference? user,
    required this.description,
    required this.locations,
    required this.files,
    required this.datetime,
    required this.sportType,
    required this.modality,
  }) : super(id: id, userId: user);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['description'] = description;
    // data['locations'] = locations;
    data['files'] = files;
    data['datetime'] = datetime;
    data['sportType'] = sportType;
    data['modality'] = modality;
    data['user'] = userId;

    return data;
  }

  Post.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    // locations = [];
    // for (String location in json['locations']) {
    //   locations.add(location);
    // }
    files = [];
    for (String file in json['files']) {
      files!.add(file);
    }
    datetime = json['datetime'];
    sportType = json['sportType'];
    modality = json['modality'];
    userId = json['user'];
  }
}
