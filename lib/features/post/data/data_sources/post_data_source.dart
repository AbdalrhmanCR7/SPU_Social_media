import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:social_media_app/features/post/data/models/post_model.dart';
import '../../../../core/entities/entity/file_entity.dart';
import '../../../../core/entities/entity/x_file_entity.dart';

abstract class PostRepo {
  Stream<List<Post>> fetchAllPosts();

  Future<void> createPost(Post post);

  Future<void> deletePost(String postId);

  Stream<List<Post>> fetchPostByUserId(String userId);

  Future<void> updatePost(Post post);

  Future<List<FileEntities>> uploadFilesPost(
      List<XFileEntities> files, String folderName);
}

class NewPostsRemoteDataSource extends PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("المستخدم غير مسجل الدخول");
    }

    String userId = currentUser.uid;

    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc(userId).get();
    if (!userSnapshot.exists) {
      throw Exception("بيانات المستخدم غير موجودة");
    }

    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    String userName = userData['userName'] ?? "مستخدم غير معروف";
    String profileImageUrl = userData['profileImageUrl'] ?? "";

    final postId = (post.id.isNotEmpty) ? post.id : postCollection.doc().id;

    final postData = {
      ...post.toMap(),
      'id': postId,
      'userId': userId,
      'userName': userName,
      'profileImageUrl': profileImageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await postCollection.doc(postId).set(postData);
  }

  @override
  Future<void> deletePost(String postId) async {
    await postCollection.doc(postId).delete();
  }

  @override
  Stream<List<Post>> fetchAllPosts() {
    return firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .where((doc) =>
              doc.data().containsKey('createdAt')) // التأكد من وجود createdAt
          .map((doc) => Post.fromMap(doc.data()))
          .toList();
    });
  }

  @override
  Stream<List<Post>> fetchPostByUserId(String userId) async* {
    // Fetch user data
    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      // Fetch posts based on userId
      QuerySnapshot postSnapshot = await postCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      // Stream the posts
      yield postSnapshot.docs
          .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    }
  }

  @override
  Future<void> updatePost(Post post) async {
    await postCollection.doc(post.id).update(post.toMap());
  }

  @override
  Future<List<FileEntities>> uploadFilesPost(
      List<XFileEntities> files, String folderName) async {
    final uploadTasks = files.map((file) async {
      final String path = "$folderName/${file.name}";
      final Reference storageRef = storage.ref(path);
      await storageRef.putData(file.xFileAsBytes);
      final String fileUrl = await storageRef.getDownloadURL();
      return FileEntities(name: file.name, url: fileUrl);
    }).toList();

    return await Future.wait(uploadTasks);
  }

  Future<UserPost?> fetchUserPost(String uid) async {
    final userDoc = await firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      final userData = userDoc.data();
      if (userData != null) {
        return UserPost(
          uid: uid,
          userName: userData['userName'],
          profileImageUrl: userData['profileImageUrl'],
        );
      }
    }
    return null;
  }
}
