import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:talent_app/models/models.dart';
import 'package:talent_app/utils/utils.dart';

class UserService extends ChangeNotifier {
  UserApp? userApp;
  String? profileUrlImage;
  List<Post> userPosts = [];
  List<UserApp> followers = [];
  List<UserApp> following = [];
  bool isLoading = false;
  bool isLoadingImage = false;

  Future<UserApp?> getUser() async {
    final FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    final DocumentSnapshot<Map<String, dynamic>> doc =
        await fbFirestore.collection("users").doc(user?.uid).get();
    userApp = UserApp.fromJson(doc.data()!);
    userApp!.id = doc.reference;
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
    if (userApp!.birthdate != userAppToUpdate.birthdate) {
      data.addAll({"birthdate": userAppToUpdate.birthdate});
      userApp!.birthdate = userAppToUpdate.birthdate;
    }
    if (userApp!.country != userAppToUpdate.country) {
      data.addAll({"country": userAppToUpdate.country});
      userApp!.country = userAppToUpdate.country;
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
      postaux.id = doc.reference;
      postaux.userApp = userApp;
      userPosts.add(postaux);
    }

    userPosts.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));

    isLoading = false;
    notifyListeners();
  }

  Future<void> getFollowers() async {
    if (userApp == null) return;
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
          UserApp auxUserApp = UserApp.fromJson(element.data());
          auxUserApp.id = element.reference;
          provFollowers.add(auxUserApp);
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
          UserApp auxUserApp = UserApp.fromJson(element.data());
          auxUserApp.id = element.reference;
          provFollowing.add(auxUserApp);
          break;
        }
      }
    }
    following.addAll(provFollowing);

    // isLoading = false;
    // notifyListeners();
  }

  Future<void> follow(UserApp userToFollow) async {
    if (userApp == null) return;
    //Actualizamos la lista de seguidores del usuario seguido
    await userToFollow.id!.update({
      "followers": FieldValue.arrayUnion([userApp!.id]),
    });

    //Actualizamos nuestra lista de seguidos en firebase
    await userApp!.id!.update({
      "following": FieldValue.arrayUnion([userToFollow.id]),
    });
    userApp!.following!.add(userToFollow.id);
    userToFollow.followers!.add(userApp!.id);
    following.add(userToFollow);
    // await postsService.getFollowingPosts(userApp!);
  }

  Future<void> unfollow(UserApp userToUnfollow) async {
    if (userApp == null) return;
    //Actualizamos la lista de seguidores del usuario seguido
    await userToUnfollow.id!.update({
      "followers": FieldValue.arrayRemove([userApp!.id]),
    });

    //Actualizamos nuestra lista de seguidos en firebase
    await userApp!.id!.update({
      "following": FieldValue.arrayRemove([userToUnfollow.id]),
    });
    userApp!.following!.removeWhere((element) => element == userToUnfollow.id);
    userToUnfollow.followers!.remove(userApp!.id);
    following.remove(userToUnfollow);
    // await postsService.getFollowingPosts(userApp!);
  }

  Future<void> removeFollower(UserApp followerToRemove) async {
    final fbFirestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    final fbUser = fbFirestore.collection("users").doc(user?.uid);
    final fbFollowerToRemove =
        fbFirestore.collection("users").doc(followerToRemove.id!.id);
    //Actualizamos la lista de seguidores del usuario
    await fbUser.update({
      "followers": FieldValue.arrayRemove([fbFollowerToRemove]),
    });
    //Actualizamos la lista de seguidos del usuario seguidor
    await fbFollowerToRemove.update({
      "following": FieldValue.arrayRemove([fbUser]),
    });
    userApp!.followers!
        .removeWhere((element) => element == followerToRemove.id);
    followers.removeWhere((element) => element.id == followerToRemove.id);
  }

  Future<String> getProfileImageURL(String id) async {
    try {
      if (id == '') return '';

      final storageRef = await FirebaseStorage.instance
          .refFromURL(
              "${NetworkEndpoints.firebaseStorageBaseUrl}/$id/profile.png")
          .getDownloadURL();
      return storageRef.toString();
    } catch (e) {
      final storageRef = await FirebaseStorage.instance
          .refFromURL(
              "${NetworkEndpoints.firebaseStorageBaseUrl}/default_images/profile.png")
          .getDownloadURL();
      return storageRef.toString();
    }
  }

  // Future<void> getProfileImageURL2(String id) async {
  //   if (isLoadingImage) return;
  //   isLoadingImage = true;
  //   notifyListeners();

  //   try {
  //     if (id == '') {
  //       profileUrlImage = '';
  //       return;
  //     }

  //     final storageRef = await FirebaseStorage.instance
  //         .refFromURL(
  //             "${NetworkEndpoints.FirebaseStorageBaseUrl}/$id/profile.png")
  //         .getDownloadURL();

  //     profileUrlImage = storageRef.toString();
  //     return;
  //   } catch (e) {
  //     final storageRef = await FirebaseStorage.instance
  //         .refFromURL(
  //             "${NetworkEndpoints.FirebaseStorageBaseUrl}/default_images/profile.png")
  //         .getDownloadURL();
  //     profileUrlImage = storageRef.toString();
  //     return;
  //   }
  // }

  Future<void> uploadImageProfile(String imgPath) async {
    final fbStorage = FirebaseStorage.instance.ref();
    final File file = File(imgPath);
    final metadaData = SettableMetadata(contentType: "image/png");
    await fbStorage
        .child("${userApp!.id!.path.split('/')[1]}/profile.png")
        .putFile(file, metadaData);
    await Future.delayed(const Duration(seconds: 2));
    await getProfileImageURL(userApp!.id!.id);
    notifyListeners();
  }

  void reset() {
    userApp = null;
    followers.clear();
    following.clear();
    profileUrlImage == null;
    userPosts.clear();
  }
}
