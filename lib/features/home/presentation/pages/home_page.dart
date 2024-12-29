import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../chat/presentation/pages/chats_page.dart';
import '../../../display/presentation/pages/display_page.dart';
import '../../../notification/presentation/pages/navigation_page.dart';
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

  // هنا يمكنك وضع رابط صورة المستخدم
  // final String profileImageUrl =
  //     'https://example.com/profile.jpg'; // استبدل برابط الصورة الفعلي

  final List<Widget> screens = [
    const DisPlayPage(),
    const NotificationPage(),
    const AddPostPage(),
    BlocProvider(
      create: (context) =>
          ProfileBloc(ProfileRepository(NewProfileRemoteDataSource()))
            ..add(FetchUserProfile()),
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
        // backgroundImage: NetworkImage(profileImageUrl), // صورة الملف الشخصي
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
                )
              ],
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        actions: currentIndex == 0 // عرض الأزرار فقط في صفحة الهوم
            ? [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPagea()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chat), // زر المحادثات
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatFeature(),
                      ),
                    );
                  },
                ),
              ]
            : null, // لا تعرض أي أزرار إذا لم يكن في صفحة الهوم
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
        color: const Color(0xFFd5c48e),
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.brown,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          });
        },
      ),
    );
  }
}
