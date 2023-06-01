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

  Future<bool> deleteUser(UserApp loggedUserApp, String password) async {
    final FirebaseAuth fbAuth = FirebaseAuth.instance;
    final FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    //Si la contrasegna es valida reautenticamos y seguimos
    AuthCredential authCredential = EmailAuthProvider.credential(
      email: loggedUserApp.email!,
      password: password,
    );
    try {
      await fbAuth.currentUser!.reauthenticateWithCredential(authCredential);
    } catch (e) {
      return false;
    }
    //Borramos los archivos del usuario (foto de perfil y posts) del Storage
    _deleteFolderInFirebaseStorage(loggedUserApp.id!.id);
    //Borramos las posts del usuario de Firestore
    final data = await fbFirestore
        .collection('posts')
        .where('user', isEqualTo: loggedUserApp.id)
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
      await fbFirestore.collection('posts').doc(doc.reference.id).delete();
    }
    //Borramos los chats del usuario de Firestore
    final data2 = await fbFirestore
        .collection('chats')
        .where('users', arrayContains: loggedUserApp.id)
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
      await fbFirestore.collection('chats').doc(doc.reference.id).delete();
    }
    //Borramos el usuario de Firestore
    await fbFirestore.collection('users').doc(loggedUserApp.id!.id).delete();
    //Borramos el usuario de Auth
    await fbAuth.currentUser?.delete();
    //Borramos el token
    const storage = FlutterSecureStorage();
    await storage.delete(key: accessTokenKey);
    return true;
  }

  // Eliminar una carpeta y su contenido en Firebase Storage
  Future<void> _deleteFolderInFirebaseStorage(String nombreCarpeta) async {
    final FirebaseStorage fbStorage = FirebaseStorage.instance;
    final Reference deleteRef = fbStorage.ref().child(nombreCarpeta);

    try {
      await deleteRef.listAll().then((result) async {
        for (final element in result.items) {
          await element.delete();
        }
        for (final prefix in result.prefixes) {
          await _deleteFolderInFirebaseStorage(prefix.fullPath);
        }
      });

      // Eliminar la carpeta vacía
      await deleteRef.delete();
      print('Carpeta eliminada correctamente');
    } catch (e) {
      print('Error al eliminar la carpeta: $e');
    }
  }
}
