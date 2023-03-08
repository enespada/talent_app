import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path/path.dart' as p;
import 'package:video_thumbnail/video_thumbnail.dart';

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
        final String url =
            await FirebaseStorage.instance.ref(file).getDownloadURL();
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

  Future<Widget> getPostPoster(Post post) async {
    final FirebaseStorage fbStorage = FirebaseStorage.instance;
    final FullMetadata metadata =
        await fbStorage.ref(post.files![0]).getMetadata();
    final String contentType = metadata.contentType!;
    final String url = await fbStorage.ref(post.files![0]).getDownloadURL();

    if (contentType.split("/").first == "video") {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: url,
        imageFormat: ImageFormat.JPEG,
        //Specify the width of the thumbnail, let the height auto-scaled to keep
        //the source aspect ratio
        maxWidth: 0,
        quality: 25,
      );

      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/${post.files![0]}')
          .create(recursive: true);
      file.writeAsBytesSync(uint8list!);

      return Image.file(file, fit: BoxFit.cover);
    } else {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }
  }

  Future uploadPost(Post post, List<AssetEntity> selectedImages) async {
    final FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
    //P1: Creamos el post en Firestore para obtener un id
    final DocumentReference reference =
        await fbFirestore.collection('posts').add(post.toJson());
    post.id = reference.id;

    //P2: Guardamos en el Storage los files del post
    final FirebaseStorage fbStorage = FirebaseStorage.instance;
    final Reference storageRef = fbStorage.ref();

    List<String> filesList = [];
    for (AssetEntity selectedImage in selectedImages) {
      File file = (await selectedImage.file)!;
      String extension = p.extension(file.path);

      final Reference ref = storageRef.child(
          '${post.userId!.id}/posts/${post.id}/file${selectedImages.indexOf(selectedImage)}$extension');
      await ref.putFile(file);
      filesList.add(ref.fullPath);
    }

    //P3: Guardamos las urls de los files en el post en Firestore
    await fbFirestore.collection('posts').doc(post.id).update({
      "files": filesList,
    });
    post.files!.addAll(filesList);
    return post;
  }
}
