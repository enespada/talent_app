import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserApp userAppFromJson(String str) => UserApp.fromJson(json.decode(str));

String userAppToJson(UserApp data) => json.encode(data.toJson());

class UserApp {
  String? id;
  String? type;
  String? fullname;
  String? email;
  String? phone;
  String? country;
  DocumentReference? sportType;
  DocumentReference? modality;
  String? imgSrc;
  String? userName;
  String? birthday;
  String? bio;
  bool? isProfileCompleted;
  int? challengesNumber;

  UserApp({
    this.id,
    this.type,
    this.fullname,
    this.email,
    this.phone,
    this.country,
    this.sportType,
    this.modality,
    this.imgSrc,
    this.userName,
    this.birthday,
    this.bio,
    this.isProfileCompleted,
    this.challengesNumber = 0,
  });

  factory UserApp.fromJson(Map<String, dynamic> json) => UserApp(
        id: json["id"],
        type: json["type"],
        fullname: json["fullname"],
        email: json["email"],
        phone: json["phone"],
        country: json["country"],
        sportType: json["sportType"],
        modality: json["modality"],
        imgSrc: json["imgSrc"],
        userName: json["userName"],
        birthday: json["birthday"],
        bio: json["bio"],
        isProfileCompleted: json["isProfileCompleted"],
        challengesNumber: json["challengesNumber"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "fullname": fullname,
        "email": email,
        "phone": phone,
        "country": country,
        "sportType": sportType,
        "modality": modality,
        "imgSrc": imgSrc,
        "userName": userName,
        "birthday": birthday,
        "bio": bio,
        "isProfileCompleted": isProfileCompleted,
        "challengesNumber": challengesNumber,
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
