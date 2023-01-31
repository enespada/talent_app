import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:talent_app/models/models.dart';

class AuthService extends ChangeNotifier {
  UserApp? userApp;
  bool loading = false;

  Future<bool> login(String user, String password) async {
    if (loading) return false;
    loading = true;
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

      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
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

  Future<bool> isAuthenticated() async {
    const storage = FlutterSecureStorage();
    String accesToken = await storage.read(key: 'acces_token') ?? '';
    return accesToken.isNotEmpty;
  }
}
