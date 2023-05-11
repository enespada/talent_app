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
    // final data = await fbFirestore
    //     .collection('chats')
    //     .where('users', arrayContains: userApp.id)
    //     .get();
    // chats = [];
    // if (data.docs.isNotEmpty) {
    //   for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
    //     Chat chataux = Chat.fromJson(doc.data());
    //     chataux.id = doc.reference;
    //     chats!.add(chataux);
    //   }
    // }
    chats = [];
    final data = fbFirestore
        .collection('chats')
        .where('users', arrayContains: userApp.id)
        .snapshots();
    // print('Length: ${await data.length}');
    QuerySnapshot<Map<String, dynamic>> snapshot = await data.first;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      Chat chataux = Chat.fromJson(doc.data());
      chataux.id = doc.reference;
      chats!.add(chataux);
    }
    data.listen((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      //Recorremos los nuevos chats
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        bool isNewChat = true;
        //Recorremos los viejos chats
        for (Chat chat in chats!) {
          if (chat.id == doc.reference) {
            isNewChat = false;
            Chat chataux = Chat.fromJson(doc.data());
            //Si hay nuevos mensajes
            if (chat.messages!.length != chataux.messages!.length) {
              chataux.id = doc.reference;
              int n = chataux.messages!.length;
              if (n != 0) {
                int i = n - 1;
                bool lastMessageInSending = false;
                while (i >= 0 && !lastMessageInSending) {
                  //Actualizamos el estado solo de los mensajes de otros usuarios
                  if (chataux.messages![i].userId != userApp.id) {
                    if (chataux.messages![i].messageStatus ==
                        MessageStatus.Sending) {
                      chataux.messages![i].messageStatus = MessageStatus.Sent;
                    } else {
                      lastMessageInSending = true;
                    }
                  } else {
                    lastMessageInSending = true;
                  }
                  i--;
                }
              }
              int index = chats!.indexOf(chat);
              chats!.remove(chat);
              chats!.insert(index, chataux);
              List<Map<String, dynamic>> newMessages = [];
              for (Message message in chataux.messages!) {
                newMessages.add(message.toJson());
              }
              await fbFirestore
                  .collection('chats')
                  .doc(chataux.id!.id)
                  .update({'messages': newMessages});
            }
            break;
          }
        }
        //Si hay un nuevo chat
        if (isNewChat) {
          Chat chataux = Chat.fromJson(doc.data());
          chataux.id = doc.reference;
          chats!.add(chataux);
        }
      }
      notifyListeners();
    });

    isLoadingChats = false;
    notifyListeners();
  }

  Future<String> getChatImageURL({
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

  Future<Chat> newChat(Chat chat) async {
    final FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    //P1: Creamos el chat en Firestore para obtener un id
    final DocumentReference reference =
        await fbFirestore.collection('chats').add(chat.toJson());
    chat.id = reference;
    // if (chats != null) {
    //   chats!.add(chat);
    // }
    return chat;
  }

  void reset() {
    chats?.clear();
    chats = null;
  }
}
