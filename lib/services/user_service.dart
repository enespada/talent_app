import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:talent_app/models/models.dart';

class UserService extends ChangeNotifier {
  UserApp? userApp;
  DocumentSnapshot<Map<String, dynamic>>? userAppData;
  static const String _baseStorageUrl = 'gs://talent-app-f191f.appspot.com';

  Future<UserApp?> getUser() async {
    final fbFirestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    final snapshot = await fbFirestore.collection("users").doc(user?.uid).get();

    userAppData = snapshot;
    userApp = UserApp.fromJson(snapshot.data()!);
    return userApp;
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
