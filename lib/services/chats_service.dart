import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/utils/utils.dart';

class ChatsService extends ChangeNotifier {
  List<Chat>? chats;
  Chat? currentChat;

  Future<void> getUserChats(UserApp userApp) async {
    if (chats != null) chats!.clear();

    FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    final data = await fbFirestore
        .collection('chats')
        .where('users', arrayContains: userApp.id)
        .get();
    if (data.docs.isEmpty) {
      chats = [];
      return;
    } else {
      chats = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
        chats!.add(Chat.fromJson(doc.data()));
      }
    }
  }
}
