import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:talent_app/models/models.dart';

class PostsService extends ChangeNotifier {
  List<Post> postsToShow = [];
  bool isLoading = false;

  PostsService() {}

  //Metodo para obtener los posts de la gente que sigue el usuario
  Future<void> getFollowingPosts(UserApp userApp) async {
    if (isLoading) return;
    isLoading = true;
    notifyListeners();

    postsToShow.clear();
    FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    if (userApp.following!.isNotEmpty) {
      final data = await fbFirestore
          .collection('posts')
          .where('user', whereIn: userApp.following)
          // .orderBy("datetime", descending: true)
          .limit(30)
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
        Post postaux = Post.fromJson(doc.data());
        await postaux.userId?.get().then((value) => postaux.userApp =
            UserApp.fromJson(value.data() as Map<String, dynamic>));
        postsToShow.add(postaux);
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<List<String>> getPostFiles(Post post) async {
    List<String> postFilesUrls = [];
    try {
      for (String file in post.files!) {
        final url = await FirebaseStorage.instance.ref(file).getDownloadURL();
        postFilesUrls.add(url.toString());
      }
      return postFilesUrls;
    } catch (e) {
      // final url = await FirebaseStorage.instance
      //     .ref("default_images/example.png")
      //     .getDownloadURL();
      return postFilesUrls;
    }
  }
}
