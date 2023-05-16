import 'package:dokki/common/widget/bottom_navigation_bar_widget.dart';
import 'package:dokki/view/book_search/search_book_page.dart';
import 'package:dokki/view/dokki_grass/dokki_grass_page.dart';
import 'package:dokki/view/home/home_page.dart';
import 'package:dokki/view/library/library_page.dart';
import 'package:dokki/view/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final storage = const FlutterSecureStorage();
  late String userId, nickname;

  List pages = [
    const HomePage(userId: ''),
    const SearchBookPage(userId: ''),
    const LibraryPage(
      userId: '',
      nickname: '',
    ),
    const DokkiGrassPage(),
    const ProfilePage(userId: ''),
  ];

  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void getUserIdFromStorage() async {
    String? tmpId = await storage.read(key: "userId");
    String? tmpName = await storage.read(key: 'nickname');
    if (tmpId != null && tmpName != null) {
      setState(() {
        userId = tmpId;
        nickname = tmpName;

        pages[0] = HomePage(userId: userId);
        pages[1] = SearchBookPage(userId: userId);
        pages[2] = LibraryPage(
          userId: userId,
          nickname: nickname,
        );
        pages[4] = ProfilePage(userId: userId);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserIdFromStorage();
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
