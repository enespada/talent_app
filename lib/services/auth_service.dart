import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:talent_app/models/models.dart';

class AuthService extends ChangeNotifier {
  UserApp? userApp;
  static const String _baseStorageUrl = 'gs://talent-app-f191f.appspot.com';

  Future<String> urlImag(String id) async {
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
