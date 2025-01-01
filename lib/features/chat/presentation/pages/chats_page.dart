import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import '../../bloc/chat_bloc.dart';
import '../../bloc/chat_event.dart';
import '../../bloc/chat_state.dart';
import '../../data/models/chat_user.dart';


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
          if (state is ChatUsersLoaded) {
            final users = state.users;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

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
                      context.read<ChatBloc>().add(FetchChatRoomEvent(receiverId: user.uid));

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StreamBuilder<ChatState>(
                            stream: context.read<ChatBloc>().stream.where((state) => state is ChatRoomLoaded),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (snapshot.hasData) {
                                final chatRoomState = snapshot.data as ChatRoomLoaded;
                                final chatRoomId = chatRoomState.chatRoomId;
                                return ChatScreen(
                                  userName: user.userName,
                                  profileImageUrl: user.profileImageUrl,
                                  receiverId: user.uid,
                                  chatId: chatRoomId,
                                );
                              } else {
                                return const Center(child: Text('No chat room found.'));
                              }
                            },
                          ),
                        ),
                      ).then((_) {
                        final chatRoomState = context.read<ChatBloc>().state;
                        if (chatRoomState is ChatRoomLoaded) {
                          final chatRoomId = chatRoomState.chatRoomId;
                          context.read<ChatBloc>().add(FetchMessagesEvent(chatId: chatRoomId));
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Receiver ID is missing!')),
                      );
                    }
                  },
                );
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
  final String chatId;

  ChatScreen({
    super.key,
    required this.userName,
    required this.profileImageUrl,
    required this.receiverId,
    required this.chatId,
  });

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundImage: profileImageUrl.isNotEmpty
                  ? NetworkImage(profileImageUrl)
                  : const AssetImage('assets/images/default_profile_pic.jpg')
              as ImageProvider,
              radius: 20,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                userName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // وظيفة مكالمة الصوت
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // وظيفة مكالمة الفيديو
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              // وظائف الإعدادات
            },
            itemBuilder: (BuildContext context) {
              return {'إعدادات 1', 'إعدادات 2'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: chatBloc.chatRepository.getMessages(chatId), // استخدم chatId الصحيح
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                } else {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      // تحقق من أن الرسالة تحتوي على الحقول المطلوبة وأنها تتعلق بالمستخدم الحالي أو المستقبل
                      if ((message.senderId == FirebaseAuth.instance.currentUser?.uid || message.receiverId == FirebaseAuth.instance.currentUser?.uid) && message.message.isNotEmpty) {
                        bool isCurrentUserMessage = message.senderId == FirebaseAuth.instance.currentUser?.uid;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                          child: BubbleSpecialThree(
                            text: message.message, // استخدم حقل النص من الرسالة
                            color: isCurrentUserMessage ? Colors.blueAccent : Colors.grey.shade300, // تغيير لون الفقاعة بناءً على المرسل
                            tail: true,
                            textStyle: TextStyle(
                              fontSize: 18,
                              color: isCurrentUserMessage ? Colors.white : Colors.black, // تغيير لون النص بناءً على المرسل
                            ),
                            isSender: isCurrentUserMessage, // تحديد ما إذا كان المرسل هو المستخدم الحالي
                          ),
                        );
                      } else {
                        // إذا كانت البيانات مفقودة أو الرسالة لا تتعلق بالمستخدم الحالي أو المستقبل، تجاهل هذه الرسالة
                        return Container();
                      }
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    // وظيفة الكاميرا
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () {
                    // وظيفة الاستوديو
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {
                    // وظيفة تسجيل الصوت
                  },
                ),
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
                      chatBloc.add(SendMessageEvent(
                        chatId: chatId, // استخدم chatId الصحيح
                        receiverId: receiverId,
                        message: messageText,
                      ));
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

