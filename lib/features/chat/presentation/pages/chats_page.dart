
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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
                          : const AssetImage('assets/images/person.png')
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
                        final chatBloc = context.read<ChatBloc>();
                        chatBloc.add(FetchChatRoomEvent(receiverId: user.uid));

                        // انتظر حتى يتم تحميل الـ chatId
                        chatBloc.stream.where((state) => state is ChatRoomLoaded).first.then((state) {
                          if (state is ChatRoomLoaded) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConversationPage(
                                  userName: user.userName,
                                  profileImageUrl: user.profileImageUrl,
                                  receiverId: user.uid,
                                  chatId: state.chatRoomId, // استخدم الـ chatId الصحيح
                                ),
                              ),
                            );
                          }
                        });
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
                        : const AssetImage('assets/images/person.png')
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
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade300, Colors.grey.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: profileImageUrl.isNotEmpty
                  ? NetworkImage(profileImageUrl)
                  : const AssetImage('assets/images/person.png')
                      as ImageProvider,
              radius: 20,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                userName,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            color: Colors.white,
            tooltip: 'إجراء مكالمة صوتية',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            color: Colors.white,
            tooltip: 'إجراء مكالمة فيديو',
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {},
            itemBuilder: (BuildContext context) {
              return {'إعدادات 1', 'إعدادات 2'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey.shade300, // خلفية المحادثة بيضاء
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

                        if ((message.senderId == FirebaseAuth.instance.currentUser?.uid ||
                            message.receiverId == FirebaseAuth.instance.currentUser?.uid) &&
                            message.message.isNotEmpty) {
                          bool isCurrentUserMessage =
                              message.senderId == FirebaseAuth.instance.currentUser?.uid;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: GestureDetector(
                              onLongPress: () {
                                if (isCurrentUserMessage) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Message Options'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: const Icon(Icons.edit),
                                            title: const Text('Edit Message'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              showUpdateConfirmationDialog(
                                                  context, chatBloc, message);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.delete),
                                            title: const Text('Delete Message'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              showDeleteConfirmationDialog(
                                                  context, chatBloc, message);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisAlignment: isCurrentUserMessage
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFB0B0B0),
                                            Color(0xFF808080)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        message.message,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isCurrentUserMessage
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB0B0B0), Color(0xFF808080)],
                // تدرجات فضي ورمادي
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    color: Colors.white,
                    onPressed: () async {
                      final XFile? file =
                          await _picker.pickImage(source: ImageSource.camera);
                      // if (file != null) {
                      //   final File selectedFile = File(file.path);
                      //   chatBloc.add(SendMediaMessageEvent(
                      //     chatId: chatId,
                      //     receiverId: receiverId,
                      //     file: selectedFile,
                      //   ));
                      // }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo),
                    color: Colors.white,
                    onPressed: () async {
                      final XFile? file = await _picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      //
                      // if (file != null) {
                      //   final File selectedFile = File(file.path);
                      //
                      //   chatBloc.add(SendMediaMessageEvent(
                      //     chatId: chatId,
                      //     receiverId: receiverId,
                      //     file: selectedFile,
                      //   ));
                      // }
                    },
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                         textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: const TextStyle(
                            height: 1.8,
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.white,
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        final messageText = _messageController.text;
                        chatBloc.add(SendMessageEvent(
                          chatId: chatId, // تأكد من استخدام الـ chatId الموجود
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
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmationDialog(
      BuildContext context, ChatBloc chatBloc, Message message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              chatBloc.add(DeleteMessageEvent(
                  chatId: chatId, messageId: message.messageId));
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void showUpdateConfirmationDialog(
      BuildContext context, ChatBloc chatBloc, Message message) {
    TextEditingController updateMessageController =
        TextEditingController(text: message.message);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: updateMessageController,
              decoration: const InputDecoration(
                hintText: 'Enter new message',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              chatBloc.add(UpdateMessageEvent(
                chatId: chatId,
                messageId: message.messageId,
                updatedMessage: updateMessageController.text,
              ));
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
