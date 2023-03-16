import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:talent_app/models/models.dart';

class AuthService extends ChangeNotifier {
  UserApp? userApp;
  bool isLoading = false;

  static const refreshTokenKey = 'refresh_token';
  static const accessTokenKey = 'access_token';
  static const expiresInKey = 'expires_in';

  Future<bool> login(String user, String password) async {
    if (isLoading) return false;
    isLoading = true;
    notifyListeners();
    try {
      final FirebaseAuth fbAuth = FirebaseAuth.instance;
      final UserCredential userCredential =
          await fbAuth.signInWithEmailAndPassword(
        email: user,
        password: password,
      );
      //token
      final token = await userCredential.user?.getIdToken(true);
      const storage = FlutterSecureStorage();
      await storage.write(key: accessTokenKey, value: token);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signUp(String user, String password) async {
    if (isLoading) return;
    isLoading = true;
    notifyListeners();

    final FirebaseAuth fbAuth = FirebaseAuth.instance;
    final UserCredential userCredential =
        await fbAuth.createUserWithEmailAndPassword(
      email: user,
      password: password,
    );
    //token
    final token = await userCredential.user?.getIdToken(true);
    const storage = FlutterSecureStorage();
    await storage.write(key: accessTokenKey, value: token);
    final FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    userApp!.id = _newUserReference(userCredential.user?.uid ?? '');
    await _newUserRefcmToken(userApp!);
    await fbFirestore
        .collection('users')
        .doc(userApp!.id!.id)
        .set(userApp!.toJson());

    isLoading = false;
    notifyListeners();
  }

  DocumentReference _newUserReference(String uid) {
    FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    return fbFirestore.collection("users").doc(uid);
  }

  Future<void> _newUserRefcmToken(UserApp userApp) async {
    FirebaseMessaging fbMessaging = FirebaseMessaging.instance;
    userApp.fcmToken = await fbMessaging.getToken();
  }

  Future<bool> isAuthenticated() async {
    const storage = FlutterSecureStorage();
    String accesToken = await storage.read(key: accessTokenKey) ?? '';
    return accesToken.isNotEmpty;
  }

  // Future<void> refreshToken() async {
  //   const storage = FlutterSecureStorage();
  //   final String refreshToken = await storage.read(key: refreshTokenKey) ?? '';
  //     final response = await Dio().post(
  //       NetworkEndpoints.refreshTokenUrl,
  //       data: {refreshTokenKey: refreshToken},
  //     );
  //     return accesToken.isNotEmpty;
  // }

  Future<void> logOut() async {
    //Borramos el token
    const storage = FlutterSecureStorage();
    await storage.delete(key: accessTokenKey);
    userApp = null;
  }

  Future<void> deleteUser() async {
    final FirebaseAuth fbAuth = FirebaseAuth.instance;
    final FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    //Borramos el usuario de Firestore
    await fbFirestore.collection('users').doc(userApp!.id!.id).delete();
    //TODO: Borrar el usuario de Auth
    // await fbAuth.currentUser!.reauthenticateWithCredential(
    //   _authCredential!,
    // );
    await FirebaseAuth.instance.currentUser?.delete();
    //Borramos el token
    const storage = FlutterSecureStorage();
    await storage.delete(key: accessTokenKey);
  }
}
