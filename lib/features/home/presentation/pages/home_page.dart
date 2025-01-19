import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../chat/presentation/pages/chats_page.dart';
import '../../../display/presentation/pages/display_page.dart';
import '../../../notification/presentation/pages/navigation_page.dart';
import '../../../post/bloc/post_bloc.dart';
import '../../../post/data/data_sources/post_data_source.dart';
import '../../../post/data/repositories/post_repository.dart';
import '../../../post/presentation/pages/post_page.dart';
import '../../../profile/bloc/profile_bloc.dart';
import '../../../profile/bloc/profile_event.dart';
import '../../../profile/data/data_sources/profile_remote_data_source.dart';
import '../../../profile/data/repositories/profile_repository.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../search/presentation/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  // قائمة الصفحات
  final List<Widget> screens = [
    BlocProvider(
      create: (context) => PostBloc(PostRepository(NewPostsRemoteDataSource())),
      child: FeedScreen(),
    ),
    const NotificationPage(),
    BlocProvider(
      create: (context) => PostBloc(PostRepository(NewPostsRemoteDataSource())),
      child: CreatePostPage(),
    ),
    BlocProvider(
      create: (context) =>
      ProfileBloc(ProfileRepository(NewProfileRemoteDataSource()))
        ..add(const FetchUserProfile()),
      child: const ProfilePage(),
    ),
  ];

  final List<String> titles = [
    'Home',
    'Notifications',
    'Post',
    'Profile',
  ];

  int currentIndex = 0;

  // تعديل دالة navigationItems لتمرير الفقاعات مع التمرير
  List<Widget> navigationItems() {
    return [
      Icon(Icons.home_filled,
          color: currentIndex == 0 ? Colors.white : Colors.black),
      Icon(Icons.notification_important,
          color: currentIndex == 1 ? Colors.white : Colors.black),
      Icon(Icons.post_add_outlined,
          color: currentIndex == 2 ? Colors.white : Colors.black),
      const CircleAvatar(
        radius: 15, // يمكنك تعديل الحجم
        backgroundColor: Colors.white, // خلفية بيضاء للصورة
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          children: [
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () {},
                ),
                // زر التبديل بين الوضع الفاتح والمظلم
                // IconButton(
                //   icon: const Icon(Icons.nightlight_round),
                //   onPressed: () {
                //     // إرسال حدث واحد فقط لتبديل الوضع
                //     BlocProvider.of<DarkModeBloc>(context).add(ToggleDarkModeEvent());
                //   },
                // ),
              ],
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        actions: currentIndex == 0
            ? [
          IconButton(
            color: Colors.black,
            iconSize: 27,
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPagea()),
              );
            },
          ),
          IconButton(
            color: Colors.black,
            icon: const Icon(Icons.chat), // زر المحادثات
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChatsPage(),
                ),
              );
            },
          ),
        ]
            : null,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade300, Colors.grey.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: screens,
        onPageChanged: (pageIndex) {
          setState(() {
            currentIndex = pageIndex;
          });
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: navigationItems(),
        height: 55,
        color: Colors.grey.shade400,
        // نفس اللون الفاتح المستخدم في الـ AppBar
        backgroundColor: Colors.transparent,
        // خلفية شفافة لتجنب تداخل اللون مع الخلفية
        buttonBackgroundColor: Colors.grey.shade600,
        // نفس اللون الداكن المستخدم في الـ AppBar
        onTap: (index) {
          setState(() {
            currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          });
        },),
    );
  }
}

