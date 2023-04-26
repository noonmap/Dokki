import 'package:dokki/constants/colors.dart';
import 'package:dokki/ui/pages/dokki_grass_page.dart';
import 'package:dokki/ui/pages/home_page.dart';
import 'package:dokki/ui/pages/library_page.dart';
import 'package:dokki/ui/pages/profile_page.dart';
import 'package:dokki/ui/pages/search_book_page.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    const HomePage(),
    const SearchBookPage(),
    const LibraryPage(),
    const DokkiGrassPage(),
    const ProfilePage(),
  ];
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      backgroundColor: whiteColor100,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: whiteColor100,
        onTap: onTap,
        currentIndex: currentIndex,
        unselectedItemColor: grayColor200,
        selectedItemColor: brandColor300,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Ionicons.home_sharp), label: "독기"),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.search_sharp), label: "검색"),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.library_sharp), label: "서재"),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.flower_sharp), label: "텃밭"),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.person_sharp), label: "프로필"),
        ],
      ),
    );
  }
}
