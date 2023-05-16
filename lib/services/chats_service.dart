import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/utils/utils.dart';

class ChatsService extends ChangeNotifier {
  List<Chat>? chats;
  bool isLoadingChats = false;
  bool isLoadingImage = false;
  List<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>? chatsScreenSS;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? chatScreenSS;

  Future<void> getUserChats(UserApp userApp) async {
    if (isLoadingChats) return;
    isLoadingChats = true;
    notifyListeners();

    if (chats != null) chats!.clear();
    FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    //O1: Sin escuchar cambios
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
    //O2: Con escuchas en messages como un array
    chats = [];
    final chatsSnapshots = fbFirestore
        .collection('chats')
        .where('users', arrayContains: userApp.id)
        .snapshots();
    QuerySnapshot<Map<String, dynamic>> chatsData = await chatsSnapshots.first;
    for (QueryDocumentSnapshot<Map<String, dynamic>> chatDoc
        in chatsData.docs) {
      Chat chataux = Chat.fromJson(chatDoc.data());
      chataux.id = chatDoc.reference;
      chatsScreenSS ??= [];
      chatsScreenSS!.add(chatsSnapshots
          .listen((QuerySnapshot<Map<String, dynamic>> snapshot) async {
        //Recorremos los nuevos chats
        for (QueryDocumentSnapshot<Map<String, dynamic>> chatDoc
            in snapshot.docs) {
          bool isNewChat = true;
          //Recorremos los viejos chats
          for (Chat chat in chats!) {
            if (chat.id == chatDoc.reference) {
              isNewChat = false;
              break;
            }
          }
          //Si hay un nuevo chat
          if (isNewChat) {
            Chat chataux = Chat.fromJson(chatDoc.data());
            chataux.id = chatDoc.reference;
            //Recuperamos los mensajes
            final messagesSnapshots =
                chatDoc.reference.collection('messages').snapshots();
            QuerySnapshot<Map<String, dynamic>> messagesData =
                await messagesSnapshots.first;
            List<Message> messages = [];
            for (QueryDocumentSnapshot<Map<String, dynamic>> messagesDoc
                in messagesData.docs) {
              Message m = Message.fromJson(messagesDoc.data());
              m.id = messagesDoc.reference;
              messages.add(m);
            } //ffcDkbujfCSGmChppFPGK8cC1s03
            messages.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
            chataux.messages = [];
            chataux.messages!.addAll(messages);
            chats!.add(chataux);
            chatsScreenSS!.add(messagesSnapshots
                .listen((QuerySnapshot<Map<String, dynamic>> snapshot) async {
              //Recorremos los nuevos mensajes
              for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                  in snapshot.docs) {
                Message messageaux = Message.fromJson(doc.data());
                messageaux.id = doc.reference;
                bool isNewMessage = true;
                for (Message message in chataux.messages!) {
                  if (message.id == doc.reference) {
                    isNewMessage = false;

                    if (messageaux.userId != userApp.id) {
                      messageaux.messageStatus = MessageStatus.Sent;
                      await fbFirestore
                          .collection('chats')
                          .doc(messageaux.chatId!.id)
                          .collection('messages')
                          .doc(doc.reference.id)
                          .update(messageaux.toJson());
                    } else {}
                  }
                }
                //Si hay un nuevo message
                if (isNewMessage) {
                  chataux.messages ??= [];
                  chataux.messages!.add(messageaux);
                } else {
                  int m = chataux.messages!.length;
                  int index = 0;
                  while (index < m) {
                    if (chataux.messages![index].id == messageaux.id) {
                      chataux.messages!.removeAt(index);
                      break;
                    }
                    index++;
                  }
                  chataux.messages!.insert(index, messageaux);
                }
              }
              notifyListeners();
            }));
          }
        }
        notifyListeners();
      }));
    }

    isLoadingChats = false;
    notifyListeners();
  }

  Future<void> setUpChatStreamSubscription(Chat chat, UserApp userApp) async {
    FirebaseFirestore fbFirestore = FirebaseFirestore.instance;

    final data = fbFirestore.collection('chats').doc(chat.id!.id).snapshots();
    // DocumentSnapshot<Map<String, dynamic>> snapshot = await data.first;

    chatScreenSS =
        data.listen((DocumentSnapshot<Map<String, dynamic>> doc) async {
      Chat chataux = Chat.fromJson(doc.data()!);
      chataux.id = doc.reference;

      //Evento 1: Si hay nuevos mensajes
      if (chat.messages!.length != chataux.messages!.length) {
        int n = chataux.messages!.length;
        if (n != 0) {
          int i = n - 1;
          bool lastMessageInSending = false;
          while (i >= 0 && !lastMessageInSending) {
            //Actualizamos el estado solo de los mensajes de otros usuarios
            if (chataux.messages![i].userId != userApp.id) {
              //Si esta enviado lo cambiamos a leido
              if (chataux.messages![i].messageStatus == MessageStatus.Sent ||
                  chataux.messages![i].messageStatus == MessageStatus.Sending) {
                chataux.messages![i].messageStatus = MessageStatus.Read;
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
      } else {
        //Evento 2: Si el estado del ultimo mensaje cambia
        if (chat.messages!.last.messageStatus !=
            chataux.messages!.last.messageStatus) {
          chat.messages!.last.messageStatus =
              chataux.messages!.last.messageStatus;
        }
      }

      notifyListeners();
    });
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
    //O1: Sin escuchar cambios
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
    for (StreamSubscription<QuerySnapshot<Map<String, dynamic>>> element
        in chatsScreenSS ?? []) {
      element.cancel();
    }
    chatsScreenSS = null;
    chatScreenSS?.cancel();
    chatScreenSS = null;
  }
}
