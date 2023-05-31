import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:talent_app/models/models.dart';

class AuthService extends ChangeNotifier {
  // UserApp? userApp;
  bool isLoading = false;

  static const refreshTokenKey = 'refresh_token';
  static const accessTokenKey = 'access_token';
  static const expiresInKey = 'expires_in';

  Future<String?> login(String user, String password) async {
    // if (isLoading) return '';
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
      return null;
    } on FirebaseAuthException catch (fae) {
      isLoading = false;
      notifyListeners();
      return fae.code;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return 'Error';
    }
  }

  Future<String?> signUp(String email, String password, String type) async {
    // if (isLoading) return '';
    isLoading = true;
    notifyListeners();
    try {
      final FirebaseAuth fbAuth = FirebaseAuth.instance;
      final UserCredential userCredential =
          await fbAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //token
      final token = await userCredential.user?.getIdToken(true);
      const storage = FlutterSecureStorage();
      await storage.write(key: accessTokenKey, value: token);
      final FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
      UserApp? auxUserApp = UserApp(
        email: email,
        followers: [],
        following: [],
        phone: '',
        birthdate: null,
        userName: '',
        fullName: '',
        bio: '',
        country: '',
        type: type,
      );
      auxUserApp.id = _newUserReference(userCredential.user?.uid ?? '');
      // await _newUserReffcmToken(userApp!);
      await fbFirestore
          .collection('users')
          .doc(auxUserApp.id!.id)
          .set(auxUserApp.toJson());
      isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (fae) {
      isLoading = false;
      notifyListeners();
      return fae.code;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return 'Error';
    }
  }

  DocumentReference _newUserReference(String uid) {
    FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    return fbFirestore.collection("users").doc(uid);
  }

  Future<bool> isAuthenticated() async {
    const storage = FlutterSecureStorage();
    String accessToken = await storage.read(key: accessTokenKey) ?? '';
    return accessToken.isNotEmpty;
  }

  // Future<void> _newUserReffcmToken(UserApp userApp) async {
  //   FirebaseMessaging fbMessaging = FirebaseMessaging.instance;
  //   userApp.fcmToken = await fbMessaging.getToken();
  // }

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
    // userApp = null;
  }

  Future<void> deleteUser(UserApp userApp) async {
    final FirebaseAuth fbAuth = FirebaseAuth.instance;
    final FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    final FirebaseStorage fbStorage = FirebaseStorage.instance;
    //Borramos los archivos del usuario (foto de perfil y posts) del Storage
    final Reference deleteRef = fbStorage.ref(userApp.id!.id);
    await deleteRef.delete();
    //Borramos las posts del usuario de Firestore
    final data = await fbFirestore
        .collection('posts')
        .where('user', isEqualTo: userApp.id)
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
      await fbFirestore.collection('posts').doc(doc.reference.id).delete();
    }
    //Borramos los chats del usuario de Firestore
    final data2 = await fbFirestore
        .collection('chats')
        .where('users', arrayContains: userApp.id)
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
      await fbFirestore.collection('chats').doc(doc.reference.id).delete();
    }
    //Borramos el usuario de Firestore
    await fbFirestore.collection('users').doc(userApp.id!.id).delete();
    //TODO: Borrar el usuario de Auth
    // await fbAuth.currentUser!.reauthenticateWithCredential(
    //   _authCredential!,
    // );
    await fbAuth.currentUser?.delete();
    //Borramos el token
    const storage = FlutterSecureStorage();
    await storage.delete(key: accessTokenKey);
  }
}
