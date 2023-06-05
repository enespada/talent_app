// ignore_for_file: unnecessary_new
import 'package:flutter/material.dart';

import 'package:talent_app/models/models.dart';

class SearchService extends ChangeNotifier {
  List<UserApp> suggestedUsers = [];
  FocusNode focusNode = new FocusNode();
  TextEditingController tec = new TextEditingController();

  Future<void> suggestUsers() async {
    // final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    // final data = await firebaseFirestore.collection('users').where('userName', );
  }
}
