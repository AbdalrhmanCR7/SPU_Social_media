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
import '../../../profile/bloc/profile_state.dart';
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

  final List<Widget> screens = [
    BlocProvider(
      create: (context) => PostBloc(PostRepository(NewPostsRemoteDataSource())),
      child: const FeedScreen(),
    ),
    const NotificationPage(),
    BlocProvider(
      create: (context) => PostBloc(PostRepository(NewPostsRemoteDataSource())),
      child: const CreatePostPage(),
    ),
    ProfilePage(),
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
      Icon(
        Icons.home_filled,
        color: currentIndex == 0 ? Colors.white : Colors.black,
      ),
      Icon(
        Icons.notification_important,
        color: currentIndex == 1 ? Colors.white : Colors.black,
      ),
      Icon(
        Icons.post_add_outlined,
        color: currentIndex == 2 ? Colors.white : Colors.black,
      ),
      BlocProvider(
        create: (context) =>
            ProfileBloc(ProfileRepository(ProfileRemoteDataSourceImpl()))
              ..add(const FetchUserProfile()),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is LoadedState &&
                state.profileUser.profileImageUrl != null) {
              return CircleAvatar(
                radius: 15,
                backgroundImage:
                    NetworkImage(state.profileUser.profileImageUrl!),
                backgroundColor: Colors.white,
              );
            } else {
              return CircleAvatar(
                radius: 15,
                backgroundImage: const AssetImage('assets/images/person.png')
                    as ImageProvider,
                backgroundColor: Colors.white,
              );
            }
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: currentIndex == 3
          ? Drawer(
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () {
                      context.read< ProfileBloc>().add(Logout());
                    },
                  ),
                ),
              ),
            )
          : null,
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
                  icon: const Icon(Icons.chat),
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
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.grey.shade600,
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
