import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:talent_app/models/models.dart';

class UserService extends ChangeNotifier {
  UserApp? userApp;
  DocumentSnapshot<Map<String, dynamic>>? userAppData;
  static const String _baseStorageUrl = 'gs://talent-app-f191f.appspot.com';
  bool isLoading = false;

  Future<UserApp?> getUser() async {
    final fbFirestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    final snapshot = await fbFirestore.collection("users").doc(user?.uid).get();

    userAppData = snapshot;
    userApp = UserApp.fromJson(snapshot.data()!);
    return userApp;
  }

  Future<void> updateUser(UserApp userAppToUpdate) async {
    if (userApp == null) return;
    if (isLoading) return;
    isLoading = true;
    notifyListeners();

    final fbFirestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    final fbUser = await fbFirestore.collection("users").doc(user?.uid);

    final Map<String, dynamic> data = {};
    if (userApp!.bio != userAppToUpdate.bio) {
      data.addAll({"bio": userAppToUpdate.bio});
      userApp!.bio = userAppToUpdate.bio;
    }
    if (userApp!.userName != userAppToUpdate.userName) {
      data.addAll({"userName": userAppToUpdate.userName});
      userApp!.userName = userAppToUpdate.userName;
    }
    if (userApp!.fullName != userAppToUpdate.fullName) {
      data.addAll({"fullName": userAppToUpdate.fullName});
      userApp!.fullName = userAppToUpdate.fullName;
    }
    if (userApp!.phone != userAppToUpdate.phone) {
      data.addAll({"phone": userAppToUpdate.phone});
      userApp!.phone = userAppToUpdate.phone;
    }
    if (data.isNotEmpty) {
      await fbFirestore
          .collection("users")
          .doc(user?.uid)
          .set(data, SetOptions(merge: true));
    }

    //Actualizamos nuestra lista de seguidos
    if (userApp!.modality != userAppToUpdate.modality) {
      await fbUser.update({
        "modality": FieldValue.arrayUnion([userAppToUpdate.modality]),
      });
      userApp!.modality = userAppToUpdate.modality;
    }
    if (userApp!.sport != userAppToUpdate.sport) {
      await fbUser.update({
        "sport": FieldValue.arrayUnion([userAppToUpdate.sport]),
      });
      userApp!.sport = userAppToUpdate.sport;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String> profileImageURL(String id) async {
    try {
      if (id == '') return '';

      final storageRef = await FirebaseStorage.instance
          .refFromURL("$_baseStorageUrl/$id/profile.png")
          .getDownloadURL();
      return storageRef.toString();
    } catch (e) {
      // final storageRef = await FirebaseStorage.instance
      //     .refFromURL(
      //         "gs://talentapp-dev-c0fad.appspot.com/default_images/profile.png")
      //     .getDownloadURL();
      // return storageRef.toString();
      return '';
    }
  }
}
