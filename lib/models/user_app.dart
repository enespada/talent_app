import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserApp userAppFromJson(String str) => UserApp.fromJson(json.decode(str));

String userAppToJson(UserApp data) => json.encode(data.toJson());

class UserApp {
  String? id;
  String? type;
  String? fullName;
  String? email;
  String? phone;
  String? country;
  DocumentReference? sport;
  DocumentReference? modality;
  String? imgSrc;
  String? userName;
  String? birthday;
  String? bio;
  bool? isProfileCompleted;
  List<DocumentReference?>? followers;
  List<DocumentReference?>? following;

  UserApp({
    this.id,
    this.type,
    this.fullName,
    this.email,
    this.phone,
    this.country,
    this.sport,
    this.modality,
    this.imgSrc,
    this.userName,
    this.birthday,
    this.bio,
    this.isProfileCompleted,
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
    // fcmToken = json["fcmToken"];
    sport = json["sport"];
    modality = json["modality"];
    imgSrc = json["imgSrc"];
    userName = json["userName"];
    birthday = json["birthday"].toString();
    bio = json["bio"];
    isProfileCompleted = json["isProfileCompleted"];
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
        "sport": sport,
        "modality": modality,
        "imgSrc": imgSrc,
        "userName": userName,
        "birthday": birthday,
        "bio": bio,
        "isProfileCompleted": isProfileCompleted,
        // "challengesNumber": challengesNumber,
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
