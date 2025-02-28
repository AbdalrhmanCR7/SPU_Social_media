// import 'package:bloc/bloc.dart';
// import '../data/data_sources/chat_remote_data_source.dart';
// import '../data/models/chat_user.dart';
// import '../data/repositories/chat_repository.dart';
// import 'chat_event.dart';
// import 'chat_state.dart';
//
//
// class ChatBloc extends Bloc<ChatEvent, ChatState> {
//   final UserRepository _userRepository;
//
//   UserRepository get chatRepository => UserRepository(ChatRemoteDataSource());
//   ChatBloc(this._userRepository) : super(ChatInitial()) {
//
//     on<FetchChatRoomEvent>((event, emit) async {
//       final chatRoomId = await _userRepository.getChatRoom(event.receiverId);
//       if (chatRoomId != null) {
//         emit(ChatRoomLoaded(chatRoomId: chatRoomId));
//       } else {
//         final newChatRoomId =
//         await _userRepository.createChatRoom(event.receiverId);
//         emit(ChatRoomCreated(chatRoomId: newChatRoomId));
//         emit(ChatRoomLoaded(chatRoomId: newChatRoomId));
//       }
//     });
//
//     on<FetchUsersEvent>((event, emit) async {
//       emit(ChatLoading());
//       final userStream = await _userRepository.fetchUsersByName(event.name);
//       await for (final users in userStream) {
//         if (users.isNotEmpty) {
//           emit(ChatUsersLoaded(users: users));
//         } else {
//           emit(ChatError(error: 'No users found'));
//         }
//       }
//     });
//
//     on<FetchMessagesEvent>((event, emit) async {
//       final messagesStream = _userRepository.getMessages(event.chatId);
//       await emit.forEach<List<Message>>(
//         messagesStream,
//         onData: (messages) => ChatMessagesLoaded(messages: messages),
//         onError: (_, __) => ChatError(error: 'Error fetching messages'),
//       );
//     });
//
//     on<SendMessageEvent>((event, emit) async {
//       await _userRepository.sendMessage(
//         event.chatId,
//         event.receiverId,
//         event.message,
//       );
//       emit(ChatMessagesSent());
//       add(FetchMessagesEvent(chatId: event.chatId)); // تحديث الرسائل
//     });
//     on<ViewUsersEvent>((event, emit) async {
//       emit(ChatLoading());
//       final userStream = _userRepository.fetchUsersWithLastMessage();
//       await emit.forEach<List<UserChatWithMessage>>(
//         userStream,
//         onData: (users) => ViewUsersLoaded(users: users),
//         onError: (_, __) =>
//             ChatError(error: 'Error fetching users with last message'),
//       );
//     });
//
//
//     on<DeleteMessageEvent>((event, emit) async {
//
//       emit(ChatLoading());
//       await _userRepository.deleteMessage(event.chatId, event.messageId);
//       emit(ChatMessageDeleted());
//       add(FetchMessagesEvent(chatId: event.chatId));
//
//
//
//     });
//     on<UpdateMessageEvent>((event, emit) async {
//
//       emit(ChatLoading());
//       await _userRepository.updateMessage(
//         event.chatId,
//         event.messageId,
//         event.updatedMessage,
//       );
//       emit(MessageUpdatedState());
//
//     });
//     //
//     //   on<SendMediaEvent>((event, emit) async {
//     //     emit(ChatLoading());
//     //     await _userRepository.sendMedia(
//     //       event.chatId,
//     //       event.receiverId,
//     //       event.mediaUrl,
//     //       event.mediaType,
//     //     );
//     //     emit(ChatMessagesSent());
//     //     add(FetchMessagesEvent(chatId: event.chatId)); // تحديث الرسائل بعد الإرسال
//     //   });
//     //
//     //   on<UploadMediaEvent>((event, emit) async {
//     //     emit(MediaUploading());
//     //     final mediaUrl = await _userRepository.uploadMedia(event.file, event.folder);
//     //     emit(MediaUploaded());
//     //   });
//     //
//     //
//   }
// }
// هذا ملف البلوك
// import 'dart:io';
//
// abstract class ChatEvent {}
//
// class FetchUsersEvent extends ChatEvent {
//   final String name;
//   FetchUsersEvent({required this.name});
// }
//
// class FetchMessagesEvent extends ChatEvent {
//   final String chatId;
//   FetchMessagesEvent({required this.chatId});
// }
//
// class SendMessageEvent extends ChatEvent {
//   final String chatId;
//   final String receiverId;
//   final String message;
//   SendMessageEvent({required this.chatId, required this.receiverId, required this.message});
// }
//
// class CreateChatRoomEvent extends ChatEvent {
//   final String receiverId;
//   CreateChatRoomEvent({required this.receiverId});
// }
//
// class FetchChatRoomEvent extends ChatEvent {
//   final String receiverId;
//   FetchChatRoomEvent({required this.receiverId});
// }
//
// class ViewUsersEvent extends ChatEvent {}
//
// class DeleteMessageEvent extends ChatEvent {
//   final String chatId;
//   final String messageId;
//
//   DeleteMessageEvent({required this.chatId, required this.messageId});
// }
//
// class UpdateMessageEvent extends ChatEvent {
//   final String chatId;
//   final String messageId;
//   final String updatedMessage;
//
//   UpdateMessageEvent({
//     required this.chatId,
//     required this.messageId,
//     required this.updatedMessage,
//   });
//
// }
//
//
//
//
//
//
//
// //
// // class SendMediaEvent extends ChatEvent {
// //   final String chatId;
// //   final String receiverId;
// //   final String mediaUrl; // رابط الوسائط
// //   final String mediaType; // نوع الوسائط (image أو video)
// //
// //   SendMediaEvent({
// //     required this.chatId,
// //     required this.receiverId,
// //     required this.mediaUrl,
// //     required this.mediaType,
// //   });
// // }
// // class UploadMediaEvent extends ChatEvent {
// //   final File file;
// //   final String folder;
// //
// //   UploadMediaEvent({required this.file, required this.folder});
// // }
// // class SendMediaMessageEvent extends ChatEvent {
// //   final String chatId;
// //   final String receiverId;
// //   final File file;
// //
// //   SendMediaMessageEvent({
// //     required this.chatId,
// //     required this.receiverId,
// //     required this.file,
// //   });
// // }
//
// هذا الاحداث
//
// import '../data/models/chat_user.dart';
//
// abstract class ChatState {}
//
// class ChatInitial extends ChatState {}
//
// class ChatLoading extends ChatState {}
//
// class ChatUsersLoaded extends ChatState {
//   final List<UserChat> users;
//
//   ChatUsersLoaded({required this.users});
// }
//
// class ChatMessagesLoaded extends ChatState {
//   final List<Message> messages;
//
//   ChatMessagesLoaded({required this.messages});
// }
//
// class ChatMessagesSent extends ChatState {}
//
// class ChatRoomCreated extends ChatState {
//   final String chatRoomId;
//
//   ChatRoomCreated({required this.chatRoomId});
// }
//
// class ChatRoomLoaded extends ChatState {
//   final String chatRoomId;
//
//   ChatRoomLoaded({required this.chatRoomId});
// }
//
// class ViewUsersLoaded extends ChatState {
//   final List<UserChatWithMessage> users;
//
//   ViewUsersLoaded({required this.users});
// }
//
// class ChatError extends ChatState {
//   final String error;
//
//   ChatError({required this.error});
// }
// class ChatMessageDeleted extends ChatState {}
// class MessageUpdatedState extends ChatState {}
//
//
//
//
//
// هذا ملف الحالات
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../models/chat_user.dart';
//
// class ChatRemoteDataSource {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Stream<List<UserChat>> fetchUsersByName(String name) {
//     final lowerCaseName = name.toLowerCase();
//     return FirebaseFirestore.instance
//         .collection('users')
//         .where('userNameLower', isGreaterThanOrEqualTo: lowerCaseName)
//         .where('userNameLower', isLessThanOrEqualTo: '$lowerCaseName\uf8ff')
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) {
//         final userData = doc.data();
//         return UserChat(
//           uid: doc.id,
//           userName: userData['userName'] ?? '',
//           profileImageUrl: userData['profileImageUrl'] ?? '',
//         );
//       }).toList();
//     });
//   }
//
//   Stream<List<Message>> getMessages(String chatId) {
//     return _firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.reversed.map((doc) {
//         final data = doc.data();
//
//         return Message(
//           senderId: data['senderId'] ?? '',
//           receiverId: data['receiverId'] ?? '',
//           message: data['message'] ?? '',
//           messageId: data['messageId'] ?? '',
//           timestamp: data['timestamp'] != null
//               ? (data['timestamp'] as Timestamp).toDate()
//               : DateTime.now(),
//         );
//       }).toList();
//     });
//   }
//
//   Future<void> sendMessage(
//       String chatId, String receiverId, String message) async {
//     final currentUser = FirebaseAuth.instance.currentUser?.uid;
//     if (currentUser != null) {
//       final messageRef = await _firestore
//           .collection('chats')
//           .doc(chatId)
//           .collection('messages')
//           .add({
//         'senderId': currentUser,
//         'receiverId': receiverId,
//         'message': message,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       await messageRef.update({
//         'messageId': messageRef.id,
//       });
//       await _firestore.collection("chats").doc(chatId).set({
//         'users': [currentUser, receiverId],
//         'lastMessage': message,
//         'timestamp': FieldValue.serverTimestamp(),
//       }, SetOptions(merge: true));
//     } else {
//       throw Exception('Current User is Null');
//     }
//   }
//
//   Future<String?> getChatRoom(String receiverId) async {
//     final User? currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser != null) {
//       final chatQuery = await _firestore
//           .collection('chats')
//           .where('users', arrayContains: currentUser.uid)
//           .get();
//
//       final chats = chatQuery.docs
//           .where((chat) => chat['users'].contains(receiverId))
//           .toList();
//
//       if (chats.isNotEmpty) {
//         return chats.first.id;
//       }
//     }
//     return null;
//   }
//
//   Future<String> createChatRoom(String receiverId) async {
//     final User? currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser != null) {
//       final currentUserDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(currentUser.uid)
//           .get();
//       final String currentUserName = currentUserDoc.data()?['userName'];
//
//       final receiverDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(receiverId)
//           .get();
//       final String receiverName = receiverDoc.data()?['userName'];
//
//       final chatRoom = await _firestore.collection('chats').add({
//         'users': [currentUser.uid, receiverId],
//         'userNames': [currentUserName, receiverName],
//         'lastMessage': '',
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//       return chatRoom.id;
//     }
//     throw Exception('Current User is Null');
//   }
//
//   Stream<List<UserChatWithMessage>> viewUsers() {
//     final currentUser = FirebaseAuth.instance.currentUser?.uid;
//     if (currentUser != null) {
//       return _firestore
//           .collection('chats')
//           .snapshots()
//           .asyncMap((snapshot) async {
//         List<UserChatWithMessage> userChats = [];
//         for (var doc in snapshot.docs) {
//           final data = doc.data();
//
//           if (doc.id.isNotEmpty) {
//             final List users = data['users'] ?? [];
//             if (users.isNotEmpty) {
//               final userId = users.firstWhere((id) => id != currentUser);
//               final userDoc =
//               await _firestore.collection('users').doc(userId).get();
//               final userData = userDoc.data();
//               if (userData != null) {
//                 userChats.add(UserChatWithMessage(
//                   uid: userId,
//                   userName: userData['userName'] ?? '',
//                   profileImageUrl: userData['profileImageUrl'] ?? '',
//                   lastMessage: data['lastMessage'] ?? '',
//                   timestamp: (data['timestamp'] as Timestamp).toDate(),
//                 ));
//               }
//             }
//           }
//         }
//
//         userChats.sort((a, b) => b.timestamp.compareTo(a.timestamp));
//         return userChats;
//       });
//     } else {
//       throw Exception('Current User is Null');
//     }
//   }
//
//   Future<void> deleteMessage(String chatId, String messageId) async {
//     try {
//       final messagesRef =
//       _firestore.collection('chats').doc(chatId).collection('messages');
//
//       await messagesRef.doc(messageId).delete();
//
//       final snapshot = await messagesRef
//           .orderBy('timestamp', descending: true)
//           .limit(1)
//           .get();
//       final lastMessage =
//       snapshot.docs.isNotEmpty ? snapshot.docs.first.data()['message'] : '';
//
//       await _firestore.collection('chats').doc(chatId).update({
//         'lastMessage': lastMessage,
//       });
//     } catch (e) {
//       throw Exception('Failed to delete message: $e');
//     }
//   }
//
//   Future<void> updateMessage(
//       String chatId, String messageId, String updatedMessage) async {
//     try {
//       final messagesRef =
//       _firestore.collection('chats').doc(chatId).collection('messages');
//
//       await messagesRef.doc(messageId).update({
//         'message': updatedMessage,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//
//       final snapshot = await messagesRef
//           .orderBy('timestamp', descending: true)
//           .limit(1)
//           .get();
//       final lastMessage =
//       snapshot.docs.isNotEmpty ? snapshot.docs.first.data()['message'] : '';
//       await _firestore.collection('chats').doc(chatId).update({
//         'lastMessage': lastMessage,
//       });
//     } catch (e) {
//       throw Exception('Failed to update message: $e');
//     }
//   }
// }
//
// هذا الداتا
// class UserChat {
//   final String uid;
//   final String userName;
//   final String profileImageUrl;
//
//   UserChat({
//     required this.uid,
//     required this.userName,
//     required this.profileImageUrl,
//   });
// }
//
// class Message {
//   final String senderId;
//   final String receiverId;
//   final String message;
//   final String messageId;
//   final DateTime timestamp;
//
//
//   Message({
//     required this.senderId,
//     required this.receiverId,
//     required this.message,
//     required this.messageId,
//     required this.timestamp,
//
//   });
//
// }
//
//
// class UserChatWithMessage {
//   final String uid;
//   final String userName;
//   final String profileImageUrl;
//   final String lastMessage;
//   final DateTime timestamp;
//
//   UserChatWithMessage({
//     required this.uid,
//     required this.userName,
//     required this.profileImageUrl,
//     required this.lastMessage,
//     required this.timestamp,
//   });
// }
//
//
//
//
//
// هذا المودلز
// import 'dart:io';
//
// import 'package:social_media_app/features/chat/data/models/chat_user.dart';
// import '../data_sources/chat_remote_data_source.dart';
//
//
// class UserRepository {
//   final ChatRemoteDataSource remoteDataSource;
//
//   UserRepository(this.remoteDataSource);
//
//   Future<Stream<List<UserChat>>> fetchUsersByName(String name) async {
//     try {
//       return remoteDataSource.fetchUsersByName(name);
//     } catch (e) {
//       throw Exception('Error fetching users: $e');
//     }
//   }
//
//   Stream<List<Message>> getMessages(String chatId) {
//     try {
//       return remoteDataSource.getMessages(chatId);
//     } catch (e) {
//       throw Exception('Error fetching messages: $e');
//     }
//   }
//
//   Future<void> sendMessage(String chatId, String receiverId, String message) async {
//     try {
//       await remoteDataSource.sendMessage(chatId, receiverId, message);
//     } catch (e) {
//       throw Exception('Error sending message: $e');
//     }
//   }
//
//   Future<String?> getChatRoom(String receiverId) async {
//     try {
//       return await remoteDataSource.getChatRoom(receiverId);
//     } catch (e) {
//       throw Exception('Error getting chat room: $e');
//     }
//   }
//
//   Future<String> createChatRoom(String receiverId) async {
//     try {
//       return await remoteDataSource.createChatRoom(receiverId);
//     } catch (e) {
//       throw Exception('Error creating chat room: $e');
//     }
//   }
//
//   Stream<List<UserChatWithMessage>> fetchUsersWithLastMessage() {
//     try {
//       return remoteDataSource.viewUsers();
//     } catch (e) {
//       throw Exception('Error fetching users with message: $e');
//     }
//   }
//
//
//
//
//
//   Future<void> deleteMessage(String chatId, String messageId) async {
//     try {
//       await remoteDataSource.deleteMessage(chatId, messageId);
//     } catch (e) {
//       throw Exception('Error deleting message: $e');
//     }
//   }
//   Future<void> updateMessage(String chatId, String messageId, String updatedMessage) async {
//     try {
//       await remoteDataSource.updateMessage(chatId, messageId, updatedMessage);
//     } catch (e) {
//       throw Exception('Error updating message: $e');
//     }
//   }
//
//
//
//
//
//
// // Future<void> sendMedia(String chatId, String receiverId, String mediaUrl, String mediaType) async {
// //   try {
// //     await remoteDataSource.sendMedia(chatId, receiverId, mediaUrl, mediaType);
// //   } catch (e) {
// //     throw Exception('Error sending media: $e');
// //   }
// // }
// //
// // Future<String> uploadMedia(File file, String folder) async {
// //   return await remoteDataSource.uploadMedia(file, folder);
// // }
// }
//
//
//
//
// هذا المستودع
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import '../../bloc/chat_bloc.dart';
// import '../../bloc/chat_event.dart';
// import '../../bloc/chat_state.dart';
// import '../../data/models/chat_user.dart';
// class ChatsPage extends StatefulWidget {
//   const ChatsPage({super.key});
//
//   @override
//   ChatsPageState createState() => ChatsPageState();
// }
//
// class ChatsPageState extends State<ChatsPage> {
//   bool isDataLoaded = false;
//
//   String formatTimestamp(DateTime timestamp) {
//     final dateFormat = DateFormat('H:mm dd/MM');
//     return dateFormat.format(timestamp);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     final chatBloc = context.read<ChatBloc>();
//     if (!isDataLoaded) {
//       chatBloc.add(ViewUsersEvent());
//       isDataLoaded = true;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final chatBloc = context.read<ChatBloc>();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chats'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SearchPage()),
//               ).then((_) {
//                 setState(() {
//                   chatBloc.add(ViewUsersEvent());
//                 });
//               });
//             },
//           ),
//         ],
//       ),
//       body: StreamBuilder<ChatState>(
//         stream: chatBloc.stream.where((state) => state is ViewUsersLoaded),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text('Error loading data'));
//           } else if (snapshot.hasData && snapshot.data is ViewUsersLoaded) {
//             final users = (snapshot.data as ViewUsersLoaded).users;
//
//             return ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 final user = users[index];
//                 return Card(
//                   margin:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: (user.profileImageUrl.isNotEmpty)
//                           ? NetworkImage(user.profileImageUrl)
//                           : const AssetImage('assets/images/person.png')
//                       as ImageProvider,
//                     ),
//                     title: Text(user.userName),
//                     subtitle: Text(
//                       user.lastMessage,
//                       style: const TextStyle(fontSize: 12),
//                     ),
//                     trailing: Text(
//                       formatTimestamp(user.timestamp),
//                       style: const TextStyle(fontSize: 10, color: Colors.grey),
//                     ),
//                     onTap: () {
//                       if (user.uid.isNotEmpty) {
//                         final chatBloc = context.read<ChatBloc>();
//                         chatBloc.add(FetchChatRoomEvent(receiverId: user.uid));
//
//                         // انتظر حتى يتم تحميل الـ chatId
//                         chatBloc.stream.where((state) => state is ChatRoomLoaded).first.then((state) {
//                           if (state is ChatRoomLoaded) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ConversationPage(
//                                   userName: user.userName,
//                                   profileImageUrl: user.profileImageUrl,
//                                   receiverId: user.uid,
//                                   chatId: state.chatRoomId, // استخدم الـ chatId الصحيح
//                                 ),
//                               ),
//                             );
//                           }
//                         });
//                       }
//                     },
//                   ),
//                 );
//               },
//             );
//           } else {
//             return const Center(child: Text('No users found'));
//           }
//         },
//       ),
//     );
//   }
// }
//
// class SearchPage extends StatelessWidget {
//   SearchPage({super.key});
//
//   final FocusNode _focusNode = FocusNode();
//
//   @override
//   Widget build(BuildContext context) {
//     final chatBloc = context.read<ChatBloc>();
//
//     Future.delayed(Duration.zero, () => _focusNode.requestFocus());
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Card(
//           child: TextField(
//             focusNode: _focusNode,
//             decoration: const InputDecoration(
//               prefixIcon: Icon(Icons.search),
//               hintText: 'Search...',
//             ),
//             onChanged: (val) {
//               chatBloc.add(FetchUsersEvent(name: val));
//             },
//           ),
//         ),
//       ),
//       body: StreamBuilder<ChatState>(
//         stream: chatBloc.stream
//             .where((state) => state is ChatUsersLoaded || state is ChatError),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData && snapshot.data is ChatUsersLoaded) {
//             final users = (snapshot.data as ChatUsersLoaded).users;
//
//             return ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 final user = users[index];
//                 return ListTile(
//                   title: Text(
//                     user.userName,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       color: Colors.black54,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   leading: CircleAvatar(
//                     backgroundImage: (user.profileImageUrl.isNotEmpty)
//                         ? NetworkImage(user.profileImageUrl)
//                         : const AssetImage('assets/images/person.png')
//                     as ImageProvider,
//                   ),
//                   onTap: () {
//                     if (user.uid.isNotEmpty) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ConversationPage(
//                             userName: user.userName,
//                             profileImageUrl: user.profileImageUrl,
//                             receiverId: user.uid,
//                             chatId: user.uid,
//                           ),
//                         ),
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text('Receiver ID is    m   issing!')),
//                       );
//                     }
//                   },
//                 );
//               },
//             );
//           } else {
//             return Container();
//           }
//         },
//       ),
//     );
//   }
// }
//
// class ConversationPage extends StatelessWidget {
//   final String userName;
//   final String profileImageUrl;
//   final String receiverId;
//   final String chatId;
//
//   ConversationPage({
//     super.key,
//     required this.userName,
//     required this.profileImageUrl,
//     required this.receiverId,
//     required this.chatId,
//   });
//
//   final TextEditingController _messageController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//
//   @override
//   Widget build(BuildContext context) {
//     final chatBloc = context.read<ChatBloc>();
//
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.grey.shade300, Colors.grey.shade600],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: profileImageUrl.isNotEmpty
//                   ? NetworkImage(profileImageUrl)
//                   : const AssetImage('assets/images/person.png')
//               as ImageProvider,
//               radius: 20,
//             ),
//             const SizedBox(width: 10),
//             Flexible(
//               child: Text(
//                 userName,
//                 overflow: TextOverflow.ellipsis,
//                 style: GoogleFonts.lato(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.call),
//             color: Colors.white,
//             tooltip: 'إجراء مكالمة صوتية',
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.videocam),
//             color: Colors.white,
//             tooltip: 'إجراء مكالمة فيديو',
//             onPressed: () {},
//           ),
//           PopupMenuButton<String>(
//             color: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//             icon: const Icon(Icons.more_vert, color: Colors.white),
//             onSelected: (value) {},
//             itemBuilder: (BuildContext context) {
//               return {'إعدادات 1', 'إعدادات 2'}.map((String choice) {
//                 return PopupMenuItem<String>(
//                   value: choice,
//                   child: Text(
//                     choice,
//                     style: GoogleFonts.roboto(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 );
//               }).toList();
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               color: Colors.grey.shade300, // خلفية المحادثة بيضاء
//               child: StreamBuilder<List<Message>>(
//                 stream: chatBloc.chatRepository.getMessages(chatId),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(child: Text('No messages yet.'));
//                   } else {
//                     final messages = snapshot.data!;
//                     return ListView.builder(
//                       reverse: true,
//                       itemCount: messages.length,
//                       itemBuilder: (context, index) {
//                         final message = messages[index];
//
//                         if ((message.senderId == FirebaseAuth.instance.currentUser?.uid ||
//                             message.receiverId == FirebaseAuth.instance.currentUser?.uid) &&
//                             message.message.isNotEmpty) {
//                           bool isCurrentUserMessage =
//                               message.senderId == FirebaseAuth.instance.currentUser?.uid;
//
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 5.0, horizontal: 10.0),
//                             child: GestureDetector(
//                               onLongPress: () {
//                                 if (isCurrentUserMessage) {
//                                   showDialog(
//                                     context: context,
//                                     builder: (context) => AlertDialog(
//                                       title: const Text('Message Options'),
//                                       content: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           ListTile(
//                                             leading: const Icon(Icons.edit),
//                                             title: const Text('Edit Message'),
//                                             onTap: () {
//                                               Navigator.pop(context);
//                                               showUpdateConfirmationDialog(
//                                                   context, chatBloc, message);
//                                             },
//                                           ),
//                                           ListTile(
//                                             leading: const Icon(Icons.delete),
//                                             title: const Text('Delete Message'),
//                                             onTap: () {
//                                               Navigator.pop(context);
//                                               showDeleteConfirmationDialog(
//                                                   context, chatBloc, message);
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 }
//                               },
//                               child: Row(
//                                 mainAxisAlignment: isCurrentUserMessage
//                                     ? MainAxisAlignment.end
//                                     : MainAxisAlignment.start,
//                                 children: [
//                                   Flexible(
//                                     child: Container(
//                                       decoration: const BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             Color(0xFFB0B0B0),
//                                             Color(0xFF808080)
//                                           ],
//                                           begin: Alignment.topLeft,
//                                           end: Alignment.bottomRight,
//                                         ),
//                                       ),
//                                       padding: const EdgeInsets.all(10),
//                                       child: Text(
//                                         message.message,
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           color: isCurrentUserMessage
//                                               ? Colors.white
//                                               : Colors.black,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         } else {
//                           return Container();
//                         }
//                       },
//                     );
//                   }
//                 },
//               ),
//             ),
//           ),
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFFB0B0B0), Color(0xFF808080)],
//                 // تدرجات فضي ورمادي
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.camera_alt),
//                     color: Colors.white,
//                     onPressed: () async {
//                       final XFile? file =
//                       await _picker.pickImage(source: ImageSource.camera);
//                       // if (file != null) {
//                       //   final File selectedFile = File(file.path);
//                       //   chatBloc.add(SendMediaMessageEvent(
//                       //     chatId: chatId,
//                       //     receiverId: receiverId,
//                       //     file: selectedFile,
//                       //   ));
//                       // }
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.mic),
//                     color: Colors.white,
//                     onPressed: () {},
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.photo),
//                     color: Colors.white,
//                     onPressed: () async {
//                       final XFile? file = await _picker.pickImage(
//                         source: ImageSource.gallery,
//                       );
//                       //
//                       // if (file != null) {
//                       //   final File selectedFile = File(file.path);
//                       //
//                       //   chatBloc.add(SendMediaMessageEvent(
//                       //     chatId: chatId,
//                       //     receiverId: receiverId,
//                       //     file: selectedFile,
//                       //   ));
//                       // }
//                     },
//                   ),
//                   Expanded(
//                     child: SizedBox(
//                       height: 40,
//                       child: TextField(
//                         controller: _messageController,
//                         style: const TextStyle(color: Colors.black),
//                         cursorColor: Colors.black,
//                         textAlign: TextAlign.right,
//                         decoration: InputDecoration(
//                           hintText: 'Type your message...',
//                           hintStyle: const TextStyle(
//                             height: 1.8,
//                             fontSize: 12,
//                             color: Colors.black54,
//                           ),
//                           filled: true,
//                           fillColor: Colors.transparent,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30),
//                             borderSide: const BorderSide(color: Colors.grey),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30),
//                             borderSide: const BorderSide(color: Colors.black),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: Colors.white,
//                     onPressed: () {
//                       if (_messageController.text.isNotEmpty) {
//                         final messageText = _messageController.text;
//                         chatBloc.add(SendMessageEvent(
//                           chatId: chatId, // تأكد من استخدام الـ chatId الموجود
//                           receiverId: receiverId,
//                           message: messageText,
//                         ));
//                         _messageController.clear();
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void showDeleteConfirmationDialog(
//       BuildContext context, ChatBloc chatBloc, Message message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Message'),
//         content: const Text('Are you sure you want to delete this message?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               chatBloc.add(DeleteMessageEvent(
//                   chatId: chatId, messageId: message.messageId));
//               Navigator.pop(context);
//             },
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void showUpdateConfirmationDialog(
//       BuildContext context, ChatBloc chatBloc, Message message) {
//     TextEditingController updateMessageController =
//     TextEditingController(text: message.message);
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Update Message'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: updateMessageController,
//               decoration: const InputDecoration(
//                 hintText: 'Enter new message',
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               chatBloc.add(UpdateMessageEvent(
//                 chatId: chatId,
//                 messageId: message.messageId,
//                 updatedMessage: updateMessageController.text,
//               ));
//               Navigator.pop(context);
//             },
//             child: const Text('Update'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// وهذا ملف الصفحة
// اريد منك مراجع الاكواد السابقة واذا كان هناك اخطا عدلها لي لكي تعمل المحادثة بشكل طبيعي دون مشاكل لا اريد حذف شي فقط عدل وارسل لي الملفات كاملة