import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/post/bloc/post_bloc.dart';

import '../../../../core/widgets/selected_image.dart';

class AddPostPage extends StatelessWidget {
  const AddPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                // CircleAvatar(
                //   radius: 20,
                // ),
                SizedBox(width: 10),
                Text("User name"),
              ],
            ),
            TextField(
              controller: context.read<PostBloc>().contentController,
              decoration: const InputDecoration(
                hintText: "Type something",
                border: InputBorder.none,
              ),
              maxLines: null,
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<PostBloc>().add(SelectImage());
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.image, color: Colors.blue),
                      Text("Add photo"),
                    ],
                  ),
                ),
                const Row(
                  children: [
                    Icon(Icons.video_call_rounded, color: Colors.green),
                    Text("Add video"),
                  ],
                ),
                const Row(
                  children: [
                    Icon(Icons.camera_alt, color: Colors.redAccent),
                    Text("Take a photo"),
                  ],
                ),
                const Row(
                  children: [
                    Icon(Icons.person_sharp, color: Colors.black),
                    Text("Mention"),
                  ],
                ),
                const Center(
                  child: Row(
                    children: [
                      Icon(Icons.upgrade_outlined, color: Colors.black),
                      Text("post"),
                    ],
                  ),
                ),
              ],
            ),
            const Center(

              child: Padding(
                padding: EdgeInsets.only(top: 90),

                child:

                SelectedImage(),
                ),
              ),

          ],
        ),
      ),
    );
  }
}


