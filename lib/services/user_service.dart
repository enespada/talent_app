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
  List<Post>? userPosts;
  List<UserApp>? followers;
  List<UserApp>? following;
  bool isLoading = false;
  bool isLoadingImage = false;

  void reset() {
    userApp = null;
    userPosts?.clear();
    userPosts = null;
    followers?.clear();
    followers = null;
    following?.clear();
    following = null;
    profileUrlImage = null;
  }

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
    if (userPosts == null) {
      userPosts = [];
    } else {
      userPosts!.clear();
    }
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
      userPosts?.add(postaux);
    }

    userPosts?.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));

    isLoading = false;
    notifyListeners();
  }

  Future<void> getFollowers() async {
    List<DocumentReference>? idFollowers = [];
    idFollowers.addAll(userApp!.followers!);
    if (idFollowers.isEmpty) return;
    if (followers != null) {
      followers!.clear();
    } else {
      followers = [];
    }
    List<UserApp> provFollowers = [];
    final FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    final data = await fbFirestore
        .collection("users")
        .where(FieldPath.documentId, whereIn: userApp!.followers)
        .get();
    for (DocumentReference idFollower in idFollowers) {
      bool userExists = false;
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
        if (idFollower.id == doc.id) {
          userExists = true;
          UserApp auxUserApp = UserApp.fromJson(doc.data());
          auxUserApp.id = doc.reference;
          provFollowers.add(auxUserApp);
        }
      }
      if (!userExists) {
        userApp!.followers!.remove(idFollower);
        await fbFirestore
            .collection('users')
            .doc(userApp!.id!.id)
            .update({'followers': userApp!.followers});
      }
    }
    followers!.addAll(provFollowers);
    notifyListeners();
  }

  Future<void> getFollowing() async {
    List<DocumentReference>? idFollowings = [];
    idFollowings.addAll(userApp!.following!);
    if (idFollowings.isEmpty) return;
    if (following != null) {
      following!.clear();
    } else {
      following = [];
    }
    List<UserApp> provFollowing = [];
    final FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    final data = await fbFirestore
        .collection("users")
        .where(FieldPath.documentId, whereIn: userApp!.following)
        .get();
    for (DocumentReference idFollowing in idFollowings) {
      bool userExists = false;
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
        if (idFollowing.id == doc.id) {
          userExists = true;
          UserApp auxUserApp = UserApp.fromJson(doc.data());
          auxUserApp.id = doc.reference;
          provFollowing.add(auxUserApp);
        }
      }
      if (!userExists) {
        userApp!.following!.remove(idFollowing);
        await fbFirestore
            .collection('users')
            .doc(userApp!.id!.id)
            .update({'following': userApp!.following});
      }
    }
    following!.addAll(provFollowing);
    notifyListeners();
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
    userApp!.following!.add(userToFollow.id!);
    userToFollow.followers!.add(userApp!.id!);
    if (following == null) {
      await getFollowing();
    } else {
      following!.add(userToFollow);
    }
    // await postsService.getFollowingPosts(userApp!);
    notifyListeners();
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
    if (following == null) {
      await getFollowing();
    } else {
      following!.remove(userToUnfollow);
    }
    // await postsService.getFollowingPosts(userApp!);
    notifyListeners();
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
    if (followers == null) {
      await getFollowers();
    } else {
      followers!.removeWhere((element) => element.id == followerToRemove.id);
    }
    notifyListeners();
  }

  Future<String> getProfileImageURL(String id) async {
    try {
      if (id == '') return '';
      // if (profileUrlImage != null) return profileUrlImage!;

      final storageRef = await FirebaseStorage.instance
          .refFromURL(
              "${NetworkEndpoints.firebaseStorageBaseUrl}/$id/profile.png")
          .getDownloadURL();
      profileUrlImage = storageRef.toString();
      return storageRef.toString();
    } catch (e) {
      try {
        final storageRef = await FirebaseStorage.instance
            .refFromURL(
                "${NetworkEndpoints.firebaseStorageBaseUrl}/default_images/no-user.png")
            .getDownloadURL();
        profileUrlImage = storageRef.toString();
        return storageRef.toString();
      } catch (e) {
        return '';
      }
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
    profileUrlImage = null;
    await getProfileImageURL(userApp!.id!.id);
    notifyListeners();
  }
}
