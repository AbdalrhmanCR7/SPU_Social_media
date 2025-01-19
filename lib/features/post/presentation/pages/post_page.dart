import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/features/post/presentation/pages/selected_images_page.dart';

import '../../bloc/post_bloc.dart';
import '../../data/data_sources/post_data_source.dart';
import '../../data/repositories/post_repository.dart';
import 'text_post_page.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "What do you want to post?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),

            // Icons and text
            Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.brown.shade500.withOpacity(0.2),
                  child: Icon(Icons.edit, color: Colors.brown),
                ),
                title: Text(
                  'Text post',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => PostBloc(PostRepository(
                              NewPostsRemoteDataSource())),
                          child: TextPostPage(),
                        )),
                  );
                },
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent.withOpacity(0.2),
                  child: Icon(Icons.photo, color: Colors.blueAccent),
                ),
                title: Text(
                  'Select Image',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final List<XFile>? images = await picker.pickMultiImage();
                  if (images != null && images.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                      create: (context) => PostBloc(PostRepository(
                          NewPostsRemoteDataSource())),
                      child:  SelectedImagesPage(images: images),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.redAccent.withOpacity(0.2),
                  child: Icon(Icons.video_camera_back_outlined,
                      color: Colors.redAccent),
                ),
                title: Text(
                  'Select Video',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  // أضف فيديو
                },
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber.withOpacity(0.2),
                  child: Icon(Icons.location_on, color: Colors.amber),
                ),
                title: Text(
                  'Share Location',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  // اختر موقع
                },
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.2),
                  child: Icon(Icons.public, color: Colors.green),
                ),
                title: Text(
                  'Privacy',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  // تغيير الخصوصية
                },
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  child: Icon(Icons.tag, color: Colors.black),
                ),
                title: Text(
                  'Mention some one',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  // تغيير الخصوصية
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
