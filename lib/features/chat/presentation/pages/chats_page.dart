import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:intl/intl.dart';
import '../../bloc/chat_bloc.dart';
import '../../bloc/chat_event.dart';
import '../../bloc/chat_state.dart';
import '../../data/models/chat_user.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  ChatsPageState createState() => ChatsPageState();
}

class ChatsPageState extends State<ChatsPage> {
  bool isDataLoaded = false;

  String formatTimestamp(DateTime timestamp) {
    final dateFormat = DateFormat('H:mm dd/MM');
    return dateFormat.format(timestamp);
  }

  @override
  void initState() {
    super.initState();

    final chatBloc = context.read<ChatBloc>();
    if (!isDataLoaded) {
      chatBloc.add(ViewUsersEvent());
      isDataLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              ).then((_) {

                setState(() {
                  chatBloc.add(ViewUsersEvent());
                });
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<ChatState>(
        stream: chatBloc.stream.where((state) => state is ViewUsersLoaded),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (snapshot.hasData && snapshot.data is ViewUsersLoaded) {
            final users = (snapshot.data as ViewUsersLoaded).users;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: (user.profileImageUrl.isNotEmpty)
                          ? NetworkImage(user.profileImageUrl)
                          : const AssetImage('assets/images/تنزيل.png')
                              as ImageProvider,
                    ),
                    title: Text(user.userName),
                    subtitle: Text(
                      user.lastMessage,
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      formatTimestamp(user.timestamp),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    onTap: () {
                      if (user.uid.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConversationPage(
                              userName: user.userName,
                              profileImageUrl: user.profileImageUrl,
                              receiverId: user.uid,
                              chatId: user.uid,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Receiver ID is missing!')),
                        );
                      }
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No users found'));
          }
        },
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();

    Future.delayed(Duration.zero, () => _focusNode.requestFocus());

    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: TextField(
            focusNode: _focusNode,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search...',
            ),
            onChanged: (val) {
              chatBloc.add(FetchUsersEvent(name: val));
            },
          ),
        ),
      ),
      body: StreamBuilder<ChatState>(
        stream: chatBloc.stream
            .where((state) => state is ChatUsersLoaded || state is ChatError),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data is ChatUsersLoaded) {
            final users = (snapshot.data as ChatUsersLoaded).users;

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
                        : const AssetImage('assets/images/تنزيل.png')
                            as ImageProvider,
                  ),
                  onTap: () {
                    if (user.uid.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConversationPage(
                            userName: user.userName,
                            profileImageUrl: user.profileImageUrl,
                            receiverId: user.uid,
                            chatId: user.uid,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Receiver ID is missing!')),
                      );
                    }
                  },
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class ConversationPage extends StatelessWidget {
  final String userName;
  final String profileImageUrl;
  final String receiverId;
  final String chatId;

  ConversationPage({
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
                  : const AssetImage('assets/images/تنزيل.png')
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
            color: Colors.deepPurpleAccent,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            color: Colors.deepPurpleAccent,
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (value) {},
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
              stream: chatBloc.chatRepository.getMessages(chatId),
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

                      bool isCurrentUserMessage = message.senderId ==
                          FirebaseAuth.instance.currentUser?.uid;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        child: BubbleSpecialThree(
                          text: message.message,
                          color: isCurrentUserMessage
                              ? Colors.blueAccent
                              : Colors.grey.shade300,
                          textStyle: TextStyle(
                            fontSize: 18,
                            color: isCurrentUserMessage
                                ? Colors.white
                                : Colors.black,
                          ),
                          isSender: isCurrentUserMessage,
                        ),
                      );
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
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {},
                ),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: const TextStyle(
                          height: 1.8,
                          fontSize: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      final messageText = _messageController.text;
                      if (chatId.isEmpty) {
                        chatBloc.add(CreateChatRoomEvent(
                          receiverId: receiverId,
                        ));
                      } else {
                        chatBloc.add(SendMessageEvent(
                          chatId: chatId,
                          receiverId: receiverId,
                          message: messageText,
                        ));
                      }
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
