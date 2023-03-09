import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserApp userAppFromJson(String str) => UserApp.fromJson(json.decode(str));

String userAppToJson(UserApp data) => json.encode(data.toJson());

class UserApp {
  DocumentReference? id;
  String? type;
  String? fullName;
  String? email;
  String? phone;
  String? country;
  String? fcmToken;
  DocumentReference? sport;
  DocumentReference? modality;
  String? userName;
  DateTime? birthday;
  String? bio;
  List<DocumentReference?>? followers;
  List<DocumentReference?>? following;

  UserApp({
    this.id,
    this.type,
    this.fullName,
    this.email,
    this.phone,
    this.country,
    this.fcmToken,
    this.sport,
    this.modality,
    this.userName,
    this.birthday,
    this.bio,
    this.followers,
    this.following,
  });

  // factory UserApp.fromJson(Map<String, dynamic> json) => UserApp(
  //       id: json["id"],
  //       type: json["type"],
  //       fullname: json["fullname"],
  //       email: json["email"],
  //       phone: json["phone"],
  //       country: json["country"],
  //       sportType: json["sportType"],
  //       modality: json["modality"],
  //       imgSrc: json["imgSrc"],
  //       userName: json["userName"],
  //       birthday: json["birthday"].toString(),
  //       bio: json["bio"],
  //       isProfileCompleted: json["isProfileCompleted"],
  //       challengesNumber: json["challengesNumber"] ?? 0,
  //     );

  UserApp.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    type = json["type"];
    fullName = json["fullName"];
    email = json["email"];
    phone = json["phone"];
    country = json["country"];
    fcmToken = json["fcmToken"];
    sport = json["sport"];
    modality = json["modality"];
    userName = json["userName"];
    birthday = DateTime.fromMillisecondsSinceEpoch(
      (json["birthday"] as Timestamp).millisecondsSinceEpoch,
    );
    bio = json["bio"];
    // challengesNumber = json["challengesNumber"] ?? 0;
    followers = [];
    for (dynamic aux in json['followers']) {
      if (aux != null) followers?.add(aux as DocumentReference);
    }
    following = [];
    for (dynamic aux in json['following']) {
      if (aux != null) following?.add(aux as DocumentReference);
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "fullName": fullName,
        "email": email,
        "phone": phone,
        "country": country,
        "fcmToken": fcmToken,
        "sport": sport,
        "modality": modality,
        "userName": userName,
        "birthday": birthday,
        "bio": bio,
        "followers": followers,
        "following": following,
      };
}

// class SportType {
//   String? name;
//   List<String>? modalities;
//
//   SportType({this.name, this.modalities});
//
//   SportType.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     modalities = json['modalities'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     data['modalities'] = modalities;
//     return data;
//   }
// }
