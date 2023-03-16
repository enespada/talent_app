import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/utils/utils.dart';

class ChatsService extends ChangeNotifier {
  List<Chat>? chats;
  bool isLoadingChats = false;
  bool isLoadingImage = false;

  Future<void> getUserChats(UserApp userApp) async {
    if (isLoadingChats) return;
    isLoadingChats = true;
    notifyListeners();

    if (chats != null) chats!.clear();

    FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    final data = await fbFirestore
        .collection('chats')
        .where('users', arrayContains: userApp.id)
        .get();
    chats = [];
    if (data.docs.isNotEmpty) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
        chats!.add(Chat.fromJson(doc.data()));
      }
    }

    isLoadingChats = false;
    notifyListeners();
  }

  Future<String> getChatImageUrl({
    required Chat chat,
    required UserApp loguedUserApp,
  }) async {
    if (chat.urlImage != null) return chat.urlImage!;
    try {
      if (chat.name == null) {
        String destinationUserId = '';
        for (DocumentReference<Object?> userId in chat.users!) {
          if (userId != loguedUserApp.id) {
            destinationUserId = userId.id;
            break;
          }
        }
        final storageRef = await FirebaseStorage.instance
            .refFromURL(
                "${NetworkEndpoints.FirebaseStorageBaseUrl}/$destinationUserId/profile.png")
            .getDownloadURL();
        chat.urlImage = storageRef.toString();
        return storageRef.toString();
      } else {
        //TODO GRUPOS: devolver la url de la imagen del grupo
        return '';
      }
    } catch (e) {
      final storageRef = await FirebaseStorage.instance
          .refFromURL(
              "${NetworkEndpoints.FirebaseStorageBaseUrl}/default_images/profile.png")
          .getDownloadURL();
      return storageRef.toString();
    }
  }

  Future<void> uploadMessage(Chat chat, Message message) async {
    await chat.id!.update({
      "messages": FieldValue.arrayUnion([message.toJson()]),
    });
    // chats!.map((Chat c) {
    //   if (c.id == chat.id) {
    //     c.messages!.add(message);
    //   }
    // });
  }
}
