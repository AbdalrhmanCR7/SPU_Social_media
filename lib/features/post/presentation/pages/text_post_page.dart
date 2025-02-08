import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/post_bloc.dart';
import '../../bloc/post_event.dart';
import '../../bloc/post_state.dart';
import '../../data/models/post_model.dart';

class TextPostPage extends StatefulWidget {
  const TextPostPage({super.key});

  @override
  _TextPostPageState createState() => _TextPostPageState();
}

class _TextPostPageState extends State<TextPostPage> {
  Color _selectedBackgroundColor = Colors.blue.shade100;
  final TextEditingController _textEditingController = TextEditingController();
  bool _isPosting = false; // Added variable

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<PostBloc>().add(const FetchUserPost());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Text Post'),
      ),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Post created successfully!'),
              ),
            );
            setState(() => _isPosting = false); // Reset state
            Navigator.pop(context);
          } else if (state is PostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            setState(() => _isPosting = false); // Reset state
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    if (state is UserPostLoadedState) {
                      return Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: (state.userPost.profileImageUrl.isNotEmpty)
                                    ? NetworkImage(state.userPost.profileImageUrl)
                                    : const AssetImage('assets/images/person.png')
                                as ImageProvider,
                              ),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.userPost.userName,
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
                          ),
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),

                const SizedBox(height: 20.0),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _selectedBackgroundColor,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: TextField(
                      controller: _textEditingController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'Write something...',
                        hintStyle: TextStyle(
                          fontSize: 24.0,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 28.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildBackgroundOption(Colors.redAccent),
                      _buildBackgroundOption(Colors.purple),
                      _buildBackgroundOption(Colors.green),
                      _buildBackgroundOption(Colors.blue),
                      _buildBackgroundOption(Colors.amber),
                      _buildBackgroundOption(Colors.blueGrey),
                      _buildBackgroundOption(Colors.grey.shade300),
                      _buildBackgroundOption(Colors.blue.shade100),
                      _buildBackgroundOption(Colors.pink.shade100),
                      _buildBackgroundOption(Colors.yellow.shade100),
                      _buildBackgroundOption(Colors.green.shade100),
                      _buildBackgroundOption(Colors.brown.shade100),
                      _buildBackgroundOption(Colors.teal.shade100),
                      _buildBackgroundOption(Colors.deepOrange.shade100),
                      _buildBackgroundOption(Colors.white),
                    ],
                  ),
                ),

                const SizedBox(height: 20.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey.shade300, Colors.grey.shade600],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            constraints: const BoxConstraints(
                                maxWidth: 200, maxHeight: 50),
                            alignment: Alignment.center,
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20.0),

                    Expanded(
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey.shade300, Colors.grey.shade600],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: InkWell(
                          onTap: _isPosting // Disable when posting
                              ? null
                              : () async {
                            final text = _textEditingController.text;
                            final backgroundColor =
                            _selectedBackgroundColor.value.toRadixString(16);
                            final createdAt = DateTime.now();

                            final post = Post(
                              id: '',
                              text: text,
                              createdAt: createdAt,
                              imageUrls: [],
                              backgroundColor: backgroundColor,
                              profileImageUrl: '',
                              userName: '',
                            );

                            setState(() => _isPosting = true);
                            context.read<PostBloc>().add(CreatePostEvent(post));
                          },
                          child: Container(
                            constraints: const BoxConstraints(
                                maxWidth: 200, maxHeight: 50),
                            alignment: Alignment.center,
                            child: _isPosting
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              'Post',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBackgroundColor = color;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400),
        ),
      ),
    );
  }
}