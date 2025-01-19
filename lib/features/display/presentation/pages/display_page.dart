import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../post/bloc/post_bloc.dart';
import '../../../post/bloc/post_event.dart';
import '../../../post/bloc/post_state.dart';
import '../../../post/data/models/post_model.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PostBloc>().add(FetchAllPostsEvent());
    return Scaffold(

      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            final posts = state.posts;
            if (posts.isEmpty) {
              return const Center(child: Text('No posts available.'));
            }
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final hasImage = post.imageUrls.isNotEmpty;
                return _buildPost(context, post, hasImage);
              },
            );
          } else if (state is PostError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Something went wrong.'));
          }
        },
      ),
    );
  }

  Widget _buildPost(BuildContext context, Post post, bool hasImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header: صورة واسم المستخدم ووقت النشر
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(post.profileImageUrl),
                radius: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
        ),

        // محتوى المنشور (صورة أو نص مع خلفية ملونة)
        hasImage
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // النص فوق الصورة (بسيط وبدون خلفية)
            if (post.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  post.text,
                  style: const TextStyle(
                    fontSize: 18.0, // تكبير الخط
                    color: Colors.black, // لون النص الأسود الافتراضي
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: _isArabic(post.text)
                      ? TextAlign.right
                      : TextAlign.left, // المحاذاة حسب اللغة
                  textDirection: _isArabic(post.text)
                      ? TextDirection.rtl
                      : TextDirection.ltr, // الاتجاه حسب اللغة
                ),
              ),
            const SizedBox(height: 10), // مسافة صغيرة بين النص والصورة

            // الصور
            SizedBox(
              height: 370,
              child: PageView.builder(
                itemCount: post.imageUrls.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        image: NetworkImage(post.imageUrls[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )
            : Padding(
          padding: const EdgeInsets.all(10),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(int.parse('0xFF${post.backgroundColor}')),
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  post.text,
                  style: const TextStyle(
                    fontSize: 24.0, // تكبير الخط للنصوص بدون صور
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: _isArabic(post.text)
                      ? TextAlign.right
                      : TextAlign.left, // المحاذاة حسب اللغة
                  textDirection: _isArabic(post.text)
                      ? TextDirection.rtl
                      : TextDirection.ltr, // الاتجاه حسب اللغة
                ),
              ),
            ),
          ),
        ),

        // تفاعل المستخدم (الإعجاب، التعليق، المشاركة)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.favorite_border, color: Colors.red),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.comment_outlined, color: Colors.orange),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.share, color: Colors.blue),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.bookmark_border, color: Colors.purple),
                onPressed: () {},
              ),
            ],
          ),
        ),

        // وقت النشر
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            _formatTimeAgo(post.createdAt),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        const SizedBox(height: 10),
        Divider(height: 1, color: Colors.grey[300]),
      ],
    );
  }


  bool _isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }


  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
