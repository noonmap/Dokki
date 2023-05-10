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
  late String userId;

  List pages = [
    const HomePage(),
    const SearchBookPage(),
    const LibraryPage(userId: ''),
    const DokkiGrassPage(userId: ''),
    const ProfilePage(userId: ''),
  ];

  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void getUserIdFromStorage() async {
    String? tmp = await storage.read(key: "userId");
    if (tmp != null) {
      setState(() {
        userId = tmp;
        pages[2] = LibraryPage(userId: userId);
        pages[3] = DokkiGrassPage(userId: userId);
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
