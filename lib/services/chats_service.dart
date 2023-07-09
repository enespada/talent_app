import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/utils/utils.dart';

class ChatsService extends ChangeNotifier {
  List<Chat>? chats;
  Chat? activeChat;
  bool isLoadingChats = false;
  bool isLoadingImage = false;
  //Array con los listeners de la pantalla de chats:
  //El primero para saber si viene un nuevo chat
  //Los demas de cada uno de los chats (?)
  List<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>? chatsListeners;

  void reset() {
    for (StreamSubscription<QuerySnapshot<Map<String, dynamic>>> chatsListener
        in chatsListeners ?? []) {
      chatsListener.cancel();
    }
    chatsListeners?.clear();
    activeChat = null;
    chats?.clear();
    chats = null;
  }

  Future<void> getUserChats(UserApp loggedUserApp) async {
    if (isLoadingChats) return;
    isLoadingChats = true;
    notifyListeners();

    if (chats != null) chats!.clear();
    FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    final chatsSnapshots = fbFirestore
        .collection('chats')
        .where('users', arrayContains: loggedUserApp.id)
        .snapshots();
    // QuerySnapshot<Map<String, dynamic>> chatsData = await chatsSnapshots.first;
    // for (QueryDocumentSnapshot<Map<String, dynamic>> chatDoc
    //     in chatsData.docs) {
    //   Chat chataux = Chat.fromJson(chatDoc.data());
    //   chataux.id = chatDoc.reference;
    //   await bringUser(chataux, loggedUserApp);
    // }
    chatsListeners ??= [];
    chatsListeners!.add(chatsSnapshots
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      //Recorremos los nuevos chats
      for (QueryDocumentSnapshot<Map<String, dynamic>> chatDoc
          in snapshot.docs) {
        bool isNewChat = true;
        //Recorremos los viejos chats
        if (chats != null) {
          for (Chat chat in chats!) {
            if (chat.id == chatDoc.reference) {
              isNewChat = false;
              break;
            }
          }
        } else {
          chats = [];
        }
        //Si hay un nuevo chat
        if (isNewChat) {
          Chat chataux = Chat.fromJson(chatDoc.data());
          chataux.id = chatDoc.reference;
          await bringUser(chataux, loggedUserApp);
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
          }
          messages.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
          chataux.messages = [];
          chataux.messages!.addAll(messages);
          if (!chats!.any((Chat c) => c.id == chataux.id)) {
            chats!.add(chataux);
          }
          chatsListeners!.add(messagesSnapshots
              .listen((QuerySnapshot<Map<String, dynamic>> snapshot) async {
            //Recorremos los nuevos mensajes
            for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                in snapshot.docs) {
              Message messageaux = Message.fromJson(doc.data());
              messageaux.id = doc.reference;
              //Si es un mensaje del usuario destino
              if (messageaux.userId != loggedUserApp.id) {
                if (activeChat != null && activeChat!.id == chataux.id) {
                  messageaux.messageStatus = MessageStatus.Read;
                  await fbFirestore
                      .collection('chats')
                      .doc(chataux.id!.id)
                      .collection('messages')
                      .doc(messageaux.id!.id)
                      .update({
                    'messageStatus': messageaux.messageStatusToString()
                  });
                } else if (messageaux.messageStatus == MessageStatus.Sending) {
                  messageaux.messageStatus = MessageStatus.Sent;
                  await fbFirestore
                      .collection('chats')
                      .doc(chataux.id!.id)
                      .collection('messages')
                      .doc(messageaux.id!.id)
                      .update({
                    'messageStatus': messageaux.messageStatusToString()
                  });
                }
              }
              bool isNewMessage = true;
              //Comprobamos si el mensaje ya estaba aqui
              for (Message message in chataux.messages!) {
                if (message.id == messageaux.id) {
                  isNewMessage = false;
                }
              }
              //Si es un message NUEVO lo incluimos sin mas
              if (isNewMessage) {
                chataux.messages ??= [];
                chataux.messages!.add(messageaux);
              }
              //Si el mensaje no es nuevo lo actualizamos
              else {
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
            chats!.sort((a, b) {
              if (a.messages!.isEmpty) return 1;
              if (b.messages!.isEmpty) return -1;
              return b.messages!.last.timestamp!
                  .compareTo(a.messages!.last.timestamp!);
            });
            notifyListeners();
          }));
        }
      }
      notifyListeners();
    }));

    isLoadingChats = false;
    notifyListeners();
  }

  Future<void> bringUser(Chat chat, UserApp loggedUserApp) async {
    //Si es un grupo (widget.chat.users!.length > 2)
    if (chat.name != null) {
      //TODO GRUPOS: Traer imagen del grupo del Storage y el nombre del grupo
      return;
    } else {
      for (DocumentReference userId in chat.users!) {
        if (userId != loggedUserApp.id) {
          DocumentSnapshot<Object?> doc = await userId.get();
          UserApp chatUser =
              UserApp.fromJson(doc.data() as Map<String, dynamic>);
          chatUser.id = userId;
          chat.userApp = chatUser;
          return;
        }
      }
    }
  }

  Future<void> readMessages(Chat chat, UserApp loggedUserApp) async {
    final FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    final data = await fbFirestore
        .collection('chats')
        .doc(chat.id!.id)
        .collection('messages')
        .where('userId', isNotEqualTo: loggedUserApp.id)
        // .where('messageStatus', isNotEqualTo: 'Read')
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
      await chat.id!
          .collection('messages')
          .doc(doc.id)
          .update({'messageStatus': 'Read'});
      // await fbFirestore
      //     .collection('chats')
      //     .doc(chat.id!.id)
      //     .collection('messages')
      //     .doc(doc.id)
      //     .update({'messageStatus': 'Read'});
    }
  }

  Future<String> getChatImageURL({
    required Chat chat,
    required UserApp loggedUserApp,
  }) async {
    if (chat.urlImage != null) return chat.urlImage!;
    try {
      if (chat.name == null) {
        String destinationUserId = '';
        for (DocumentReference<Object?> userId in chat.users!) {
          if (userId != loggedUserApp.id) {
            destinationUserId = userId.id;
            break;
          }
        }
        final storageRef = await FirebaseStorage.instance
            .refFromURL(
                "${NetworkEndpoints.firebaseStorageBaseUrl}/$destinationUserId/profile.png")
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
              "${NetworkEndpoints.firebaseStorageBaseUrl}/default_images/no-user.png")
          .getDownloadURL();
      return storageRef.toString();
    }
  }

  Future<void> uploadMessage(Chat chat, Message message) async {
    await chat.id!.collection('messages').add(message.toJson());
  }

  Future<void> newChat(Chat chat, UserApp loggedUserApp) async {
    final FirebaseFirestore fbFirestore = FirebaseFirestore.instance;

    Message firstMessage = Message(
      content: '¡Hola! Encantad@ de conocerte.',
      timestamp: Timestamp.now(),
      userId: loggedUserApp.id,
      messageStatus: MessageStatus.Sending,
    );
    //O1
    //Creamos el chat en Firestore para obtener un id
    final DocumentReference reference =
        await fbFirestore.collection('chats').add(chat.toJson());
    await fbFirestore
        .collection('chats')
        .doc(reference.id)
        .collection('messages')
        .add(firstMessage.toJson());
    //02:
    //Metemos el mensaje en el chat y lo subimos de una vez
    // String chatIdString = Util.generateRandomString(15);
    // final DocumentReference reference =
    //     fbFirestore.collection('chats').doc(chatIdString);
    // final Map<String, dynamic> newChatData = chat.toJson();
    // newChatData.putIfAbsent('messages', () => [firstMessage.toJson()]);
    // await reference.set(newChatData, SetOptions(merge: true));
  }
}
