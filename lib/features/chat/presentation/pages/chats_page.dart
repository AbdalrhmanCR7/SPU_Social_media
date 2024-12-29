import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../bloc/chat_bloc.dart';
import '../../bloc/chat_event.dart';
import '../../bloc/chat_state.dart';

class ChatFeature extends StatelessWidget {
  const ChatFeature({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String currentUserId = currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search...',
            ),
            onChanged: (val) {
              context.read<ChatBloc>().add(FetchUsersEvent(name: val));
            },
          ),
        ),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatUsersLoaded) {
            final user = state.user;

            return ListTile(
              title: Text(
                user.userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: CircleAvatar(
                backgroundImage: (user.profileImageUrl.isNotEmpty)
                    ? NetworkImage(user.profileImageUrl)
                    : const AssetImage('assets/images/default_profile_pic.jpg')
                as ImageProvider,
              ),
              onTap: () {
                if (user.uid.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        userName: user.userName,
                        profileImageUrl: user.profileImageUrl,
                        receiverId: user.uid,
                        currentUserId: currentUserId,
                      ),
                    ),
                  );

                  FirebaseFirestore.instance.collection('chats').doc(currentUserId).collection('users').doc(user.uid).set({
                    'userName': user.userName,
                    'profileImageUrl': user.profileImageUrl,
                    'receiverId': user.uid,
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Receiver ID is missing!')),
                  );
                }
              },
            );
          } else if (state is ChatError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: Text('Please enter a name to search'));
          }
        },
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String userName;
  final String profileImageUrl;
  final String receiverId;
  final String currentUserId;

  ChatScreen({
    super.key,
    required this.userName,
    required this.profileImageUrl,
    required this.receiverId,
    required this.currentUserId,
  });

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<ChatBloc>().add(FetchMessagesEvent(
        currentUserId: currentUserId, receiverId: receiverId));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: profileImageUrl.isNotEmpty
                  ? NetworkImage(profileImageUrl)
                  : const AssetImage('assets/images/default_profile_pic.jpg')
              as ImageProvider,
              radius: 20,
            ),
            const SizedBox(width: 10),
            Text(userName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatMessagesLoaded) {
                  final messages = state.messages;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final messageData = messages[index];
                      bool isCurrentUserMessage = messageData['senderId'] == currentUserId;
                      return Align(
                        alignment: isCurrentUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                            decoration: BoxDecoration(
                              color: isCurrentUserMessage
                                  ? Colors.blueAccent
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              messageData['message'],
                              style: TextStyle(
                                color: isCurrentUserMessage ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ChatError) {
                  return Center(child: Text('Error: ${state.error}'));
                } else {
                  return const Center(child: Text('No messages yet.'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        final messageText = _messageController.text;
                        context.read<ChatBloc>().add(SendMessageEvent(
                          senderId: currentUserId,
                          receiverId: receiverId,
                          message: messageText,
                        ));



                        context.read<ChatBloc>().add(FetchMessagesEvent(
                          currentUserId: currentUserId,
                          receiverId: receiverId,
                        ));

                        _messageController.clear();
                      }
                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
