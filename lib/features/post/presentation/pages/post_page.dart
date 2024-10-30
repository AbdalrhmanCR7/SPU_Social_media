import 'package:flutter/material.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _textController = TextEditingController();
  String? _imageUrl = 'https://via.placeholder.com/150';  // رابط صورة افتراضي

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
                CircleAvatar(
                  // يمكنك إضافة صورة الملف الشخصي هنا
                  radius: 20,
                ),
                SizedBox(width: 10),
                Text("User name"),
              ],
            ),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: "Type something",
                border: InputBorder.none,
              ),
              maxLines: null,
            ),
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image, color: Colors.blue),
                      onPressed: () {
                        setState(() {
                          _imageUrl = 'https://via.placeholder.com/150'; // تغيير رابط الصورة عند الضغط
                        });
                      },
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Add photo"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.video_call_rounded,
                          color: Colors.green),
                      onPressed: () {
                        // إضافة فيديو
                      },
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Add video"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon:
                      const Icon(Icons.camera_alt, color: Colors.redAccent),
                      onPressed: () {
                        // التقاط صورة
                      },
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Take a photo"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.person_sharp, color: Colors.black),
                      onPressed: () {
                        // ذكر شخص
                      },
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Mention"),
                    ),
                  ],
                ),
              ],
            ),

              const Center(
                child: Padding(
                  padding: EdgeInsets.only( top: 30),

                  child: Image(

                    image: AssetImage(
                        'assets/images/Slogo.jpg'
                    ),
                   // fit: BoxFit.fill,
                    fit: BoxFit.contain,

                  )
                ),
              ),
          ],
        ),
      ),
    );
  }
}
