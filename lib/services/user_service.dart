import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/utils/utils.dart';

class UserService extends ChangeNotifier {
  UserApp? userApp;
  DocumentSnapshot<Map<String, dynamic>>? userAppData;
  List<Post> userPosts = [];
  List<UserApp> followers = [];
  List<UserApp> following = [];
  bool isLoading = false;

  Future<UserApp?> getUser() async {
    final fbFirestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    final snapshot = await fbFirestore.collection("users").doc(user?.uid).get();

    userAppData = snapshot;
    userApp = UserApp.fromJson(snapshot.data()!);
    return userApp;
  }

  Future<void> updateUser(UserApp userAppToUpdate) async {
    if (userApp == null) return;
    if (isLoading) return;
    isLoading = true;
    notifyListeners();

    final fbFirestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    final Map<String, dynamic> data = {};
    if (userApp!.bio != userAppToUpdate.bio) {
      data.addAll({"bio": userAppToUpdate.bio});
      userApp!.bio = userAppToUpdate.bio;
    }
    if (userApp!.userName != userAppToUpdate.userName) {
      data.addAll({"userName": userAppToUpdate.userName});
      userApp!.userName = userAppToUpdate.userName;
    }
    if (userApp!.fullName != userAppToUpdate.fullName) {
      data.addAll({"fullName": userAppToUpdate.fullName});
      userApp!.fullName = userAppToUpdate.fullName;
    }
    if (userApp!.phone != userAppToUpdate.phone) {
      data.addAll({"phone": userAppToUpdate.phone});
      userApp!.phone = userAppToUpdate.phone;
    }
    if (data.isNotEmpty) {
      await fbFirestore
          .collection("users")
          .doc(user?.uid)
          .set(data, SetOptions(merge: true));
    }

    if (userApp!.modality != userAppToUpdate.modality) {
      await fbFirestore
          .collection("users")
          .doc(user?.uid)
          .update({"modality": userAppToUpdate.modality});
      userApp!.modality = userAppToUpdate.modality;
    }
    if (userApp!.sport != userAppToUpdate.sport) {
      await fbFirestore
          .collection("users")
          .doc(user?.uid)
          .update({"sport": userAppToUpdate.sport});

      userApp!.sport = userAppToUpdate.sport;
    }

    isLoading = false;
    notifyListeners();
  }

  //Metodo para obtener los posts del usuario
  Future<void> getPosts() async {
    if (userApp == null) return;
    if (isLoading) return;
    isLoading = true;
    notifyListeners();

    userPosts.clear();
    FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    final data = await fbFirestore
        .collection('posts')
        .where('user', isEqualTo: userApp!.id)
        // .orderBy("datetime", descending: true)
        // .limit(30)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
      Post postaux = Post.fromJson(doc.data());
      postaux.userApp = userApp;
      userPosts.add(postaux);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getFollowers() async {
    List<DocumentReference?>? idFollowers = [];
    idFollowers.addAll(userApp!.followers!);
    if (idFollowers.isEmpty) return;
    // if (isLoading) return;
    // isLoading = true;
    // notifyListeners();

    followers.clear();
    List<UserApp> provFollowers = [];
    final fbFirestore = FirebaseFirestore.instance;
    final data = await fbFirestore.collection("users").get();
    String stringToCompare = '';
    for (QueryDocumentSnapshot<Map<String, dynamic>> element in data.docs) {
      for (DocumentReference? idFollower in idFollowers) {
        stringToCompare =
            idFollower.toString().split('(')[1].split(')')[0].split('/')[1];
        if (stringToCompare == element.id) {
          provFollowers.add(UserApp.fromJson(element.data()));
          break;
        }
      }
    }
    followers.addAll(provFollowers);

    // isLoading = false;
    // notifyListeners();
  }

  Future<void> getFollowing() async {
    List<DocumentReference?>? idFollowing = [];
    idFollowing.addAll(userApp!.following!);
    if (idFollowing.isEmpty) return;
    // if (isLoading) return;
    // isLoading = true;
    // notifyListeners();

    following.clear();
    List<UserApp> provFollowing = [];
    final fbFirestore = FirebaseFirestore.instance;
    // final data = await fbFirestore
    //     .collection("users")
    //     .where("id", whereIn: idFollowing)
    //     .get();
    final data = await fbFirestore.collection("users").get();
    String stringToCompare = '';
    for (QueryDocumentSnapshot<Map<String, dynamic>> element in data.docs) {
      for (DocumentReference? idFollowing in idFollowing) {
        stringToCompare =
            idFollowing.toString().split('(')[1].split(')')[0].split('/')[1];
        if (stringToCompare == element.id) {
          provFollowing.add(UserApp.fromJson(element.data()));
          break;
        }
      }
    }
    following.addAll(provFollowing);

    // isLoading = false;
    // notifyListeners();
  }

  Future<String> profileImageURL(String id) async {
    try {
      if (id == '') return '';

      final storageRef = await FirebaseStorage.instance
          .refFromURL(
              "${NetworkEndpoints.FirebaseStorageBaseUrl}/$id/profile.png")
          .getDownloadURL();
      return storageRef.toString();
    } catch (e) {
      final storageRef = await FirebaseStorage.instance
          .refFromURL(
              "${NetworkEndpoints.FirebaseStorageBaseUrl}/default_images/profile.png")
          .getDownloadURL();
      return storageRef.toString();
    }
  }
}
