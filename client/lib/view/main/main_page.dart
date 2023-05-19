import 'package:dokki/common/widget/bottom_navigation_bar_widget.dart';
import 'package:dokki/view/book_search/search_book_page.dart';
import 'package:dokki/view/home/home_page.dart';
import 'package:dokki/view/library/library_page.dart';
import 'package:dokki/view/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainPage extends StatefulWidget {
  final String userId;
  final String nickname;
  const MainPage({Key? key, required this.userId, required this.nickname})
      : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    HomePage(userId: ""),
    SearchBookPage(userId: ""),
    LibraryPage(userId: "", nickname: ""),
    ProfilePage(userId: ""),
  ];

  int currentIndex = 0;
  void onTap(int index) {
    setState(
      () {
        currentIndex = index;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    pages[0] = HomePage(userId: widget.userId);
    pages[1] = SearchBookPage(userId: widget.userId);
    pages[2] = LibraryPage(
      userId: widget.userId,
      nickname: widget.nickname,
    );
    pages[3] = ProfilePage(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[currentIndex]),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}
