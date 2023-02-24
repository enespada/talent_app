import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:talent_app/models/models.dart';

class AuthService extends ChangeNotifier {
  UserApp? userApp;
  bool isLoading = false;

  Future<bool> login(String user, String password) async {
    if (isLoading) return false;
    isLoading = true;
    notifyListeners();
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user,
        password: password,
      );
      final token = await userCredential.user?.getIdToken(true);
      const storage = FlutterSecureStorage();
      await storage.write(key: 'acces_token', value: token);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<String?> signUp(String user, String password) async {
    final UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: user,
      password: password,
    );
    final token = await userCredential.user?.getIdToken(true);
    const storage = FlutterSecureStorage();
    await storage.write(key: 'acces_token', value: token);
    return userCredential.user?.uid;
  }

  DocumentReference newUserReference(String uid) {
    FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    return fbFirestore.collection("users").doc(uid);
  }

  Future<void> newUserRefcmToken(UserApp userApp) async {
    FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    userApp.fcmToken = await FirebaseMessaging.instance.getToken();
  }

  Future<bool> isAuthenticated() async {
    const storage = FlutterSecureStorage();
    String accesToken = await storage.read(key: 'acces_token') ?? '';
    return accesToken.isNotEmpty;
  }
}
