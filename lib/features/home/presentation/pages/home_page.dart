import 'package:flutter/material.dart';

import '../../../display/presentation/pages/display_page.dart';
import '../../../post/presentation/pages/post_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  final List<Widget> screens = const [
    DisPlayPage(),
    AddPostPage(),
    ProfilePage(),

  ];

  final List<String> titles = [
    'Home',
    'Post',
    'profile',

  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(titles[currentIndex]),



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
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(213, 196, 142, 100),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(screens.length, (index) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      index == 0
                          ? Icons.home_outlined
                          : index == 1
                          ? Icons.post_add_outlined
                          : Icons.person ,



                      color: currentIndex == index ? Colors.white : Colors.black,
                    ),
                    Text(
                      titles[index],
                      style: TextStyle(
                        color:
                        currentIndex == index ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
