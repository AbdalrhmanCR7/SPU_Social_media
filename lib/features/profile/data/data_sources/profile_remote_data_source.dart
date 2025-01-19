
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';




import '../../../../core/entities/entity/file_entity.dart';
import '../../../../core/entities/entity/x_file_entity.dart';
import '../models/profileUser.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fetchUserProfile(String uid);

  Future<void> updateProfile(ProfileUser updatedProfile);

}

class NewProfileRemoteDataSource implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorageStorage = FirebaseStorage.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    final userDoc = await firebaseFirestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      final userData = userDoc.data();
      if (userData != null) {
        return ProfileUser(
          uid: uid,
          id: userData['id'],
          userName: userData['userName'],
          email: userData['email'],
          date: userData['date'],
          bio: userData['bio'],
          profileImageUrl:userData['profileImageUrl'],
        );
      }
    }
    return null;
  }
  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
    await firebaseFirestore.collection('users').doc(updatedProfile.uid).update({
      'bio': updatedProfile.bio,
      'profileImageUrl': updatedProfile.profileImageUrl,
    });
  }

  Future<FileEntities> uploadFile(
      XFileEntities xFileEntities,
      String folderName,
      ) async {
    final String path = "$folderName/${xFileEntities.name}";
    final Reference storageRef = firebaseStorageStorage.ref(path);
    await storageRef.putData(xFileEntities.xFileAsBytes);
    final String fileUrl = await storageRef.getDownloadURL();
    final FileEntities fileEntities =
    FileEntities(name: xFileEntities.name, url: fileUrl);
    return fileEntities;
  }

  Future<XFileEntities?> selectImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? imagePicked = await picker.pickImage(source: ImageSource.gallery);
    if (imagePicked != null) {
      Uint8List selected = await imagePicked.readAsBytes();
      String selectedName = imagePicked.name;
      final XFileEntities xFileEntities =
      XFileEntities(name: selectedName, xFileAsBytes: selected);
      return xFileEntities;
    }
    return null;
  }


}
