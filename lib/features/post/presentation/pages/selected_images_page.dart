import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../core/entities/entity/x_file_entity.dart';
import '../../bloc/post_bloc.dart';
import '../../bloc/post_event.dart';
import '../../bloc/post_state.dart';
import '../../data/models/post_model.dart';

class SelectedImagesPage extends StatefulWidget {
  final List<XFile> images;
  const SelectedImagesPage({required this.images});

  @override
  _SelectedImagesPageState createState() => _SelectedImagesPageState();
}

class _SelectedImagesPageState extends State<SelectedImagesPage> {
   late List<XFile> images;
  int currentIndex = 0;
  TextEditingController captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    images = List.from(widget.images);
  }

  void _showFullImage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageView(
          images: images,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<PostBloc>().add(const FetchUserPost());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state is PostLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PostError) {
                    return Text(state.message);
                  } else if (state is UserPostLoadedState) {
                    final userPost = state.userPost;

                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 25.0,
                          backgroundImage: NetworkImage(userPost.profileImageUrl),
                        ),
                        const SizedBox(width: 15.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userPost.userName,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_horiz),
                          onPressed: () {},
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 20.0),

              TextField(
                controller: captionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Write something about these images...',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20.0),

              images.isEmpty
                  ? const Center(child: Text("No images selected"))
                  : Stack(
                children: [
                  Container(
                    height: 300.0,
                    child: PageView.builder(
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () {
                            _showFullImage(index);
                          },
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  File(images[index].path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      images.removeAt(index);
                                      if (currentIndex >= images.length) {
                                        currentIndex = images.length - 1;
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Icon(
                                      Icons.close,
                                      size: 18.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${currentIndex + 1} / ${images.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (images.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select at least one image!'),
                            ),
                          );
                          return;
                        }

                        // تحويل الصور إلى كائنات XFileEntities
                        final files = images.map((e) {
                          final bytes = File(e.path).readAsBytesSync();
                          return XFileEntities(name: e.name, xFileAsBytes: bytes);
                        }).toList();

                        // رفع الصور باستخدام PostBloc
                        context.read<PostBloc>().add(
                          UploadFilesEvent(files: files, folderName: 'post_images'),
                        );

                        // الاستماع لحالة رفع الملفات وإنشاء المنشور بعد نجاحها
                        context.read<PostBloc>().stream.listen((state) {
                          if (state is PostFilesUploaded) {
                            final uploadedImagesUrls = state.files.map((file) => file.url).toList();

                            // إنشاء المنشور باستخدام الروابط المرفوعة
                            context.read<PostBloc>().add(
                              CreatePostEvent(
                                Post(
                                  id: '',
                                  userName: '',
                                  text: captionController.text,
                                  createdAt: DateTime.now(),
                                  imageUrls: uploadedImagesUrls,
                                  backgroundColor: '',
                                  likes: [],
                                  comments: [],
                                  profileImageUrl: '',
                                ),
                              ),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Post created successfully!')),
                            );

                            Navigator.pop(context);
                          } else if (state is PostError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        });
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Post'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20.0),

              ElevatedButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final List<XFile> newImages = await picker.pickMultiImage();
                  setState(() {
                    images.addAll(newImages);
                  });
                                },
                child: const Text('Add Photos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final List<XFile> images;
  final int initialIndex;

  const FullScreenImageView({required this.images, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoViewGallery.builder(
        itemCount: images.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: FileImage(File(images[index].path)),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        pageController: PageController(initialPage: initialIndex),
        scrollPhysics: BouncingScrollPhysics(),
      ),
    );
  }
}
