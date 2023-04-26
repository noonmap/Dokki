import 'package:dokki/constants/colors.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, RoutesName.home);
            case 1:
              Navigator.pushNamed(context, RoutesName.searchBook);
            default:
              Navigator.pushNamed(context, RoutesName.home);
          }
        },
        selectedItemColor: brandColor300,
        unselectedItemColor: grayColor300,
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        items: const [
          BottomNavigationBarItem(
            tooltip: "하이",
            icon: Icon(Icons.home),
            label: "홈",
          ),
          BottomNavigationBarItem(
            tooltip: "하이요",
            icon: Icon(Icons.search),
            label: "검색",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "서재",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree_sharp),
            label: "텃밭",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: "프로필",
          ),
        ],
      ),
      body: const Center(
        child: Text("Home"),
      ),
    );
  }
}
