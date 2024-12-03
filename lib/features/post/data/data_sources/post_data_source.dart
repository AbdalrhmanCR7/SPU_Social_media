import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:social_media_app/features/post/data/models/post_model.dart';



abstract class PostRepo {
  Future<List<Post>> fetchAllPosts();

  Future<void> createPost(Post post);

  Future<void> deletePost(String postId);

  Future<List<Post>> fetchPostByUserId(String userId);
}


  class NewPostsRemoteDataSource implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    await postCollection.doc(post.id).set(post.toJson());
  }

  @override
  Future<void> deletePost(String postId) async {
    await postCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    final PostsSnapshot =
        await postCollection.orderBy('timestamp', descending: true).get();
    final List<Post> allPosts = PostsSnapshot.docs
        .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return allPosts;
  }

  @override
  Future<List<Post>> fetchPostByUserId(String userId) async {
    final PostsSnapshot =
        await postCollection.where('userId', isEqualTo: userId).get();
    final userPosts = PostsSnapshot.docs
        .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return userPosts;
  }

// Future<FileEntities> uploadFile(
//     XFileEntities xFileEntities,
//     String folderName,
//     ) async {
//   final String path = "$folderName/${xFileEntities.name}";
//   final Reference storageRef = _storage.ref(path);
//   await storageRef.putData(xFileEntities.xFileAsBytes);
//   final String fileUrl = await storageRef.getDownloadURL();
//   final FileEntities fileEntities =
//   FileEntities(name: xFileEntities.name, url: fileUrl);
//   return fileEntities;
// }
//
// Future<String> uploadImage(Uint8List imageBytes) async {
//   final Reference storageRef = _storage.ref().child('posts').child(DateTime.now().millisecondsSinceEpoch.toString());
//   final UploadTask uploadTask = storageRef.putData(imageBytes);
//   final TaskSnapshot downloadUrl = await uploadTask.whenComplete(() => null);
//   return await downloadUrl.ref.getDownloadURL();
// }
}
