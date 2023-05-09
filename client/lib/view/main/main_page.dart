import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/view/book_search/search_book_page.dart';
import 'package:dokki/view/dokki_grass/dokki_grass_page.dart';
import 'package:dokki/view/home/home_page.dart';
import 'package:dokki/view/library/library_page.dart';
import 'package:dokki/view/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ionicons/ionicons.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: grayColor000,
        onTap: onTap,
        currentIndex: currentIndex,
        unselectedItemColor: grayColor200,
        selectedItemColor: brandColor300,
        showUnselectedLabels: false,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Ionicons.home_sharp), label: "독기"),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.search_sharp), label: "검색"),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.library_sharp), label: "서재"),
          BottomNavigationBarItem(icon: Icon(Ionicons.leaf_sharp), label: "텃밭"),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.person_sharp), label: "프로필"),
        ],
      ),
    );
  }
}
