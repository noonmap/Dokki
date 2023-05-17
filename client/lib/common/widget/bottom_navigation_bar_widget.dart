import 'package:dokki/common/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
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
        BottomNavigationBarItem(icon: Icon(Ionicons.search_sharp), label: "검색"),
        BottomNavigationBarItem(
            icon: Icon(Ionicons.library_sharp), label: "서재"),
        BottomNavigationBarItem(
            icon: Icon(Ionicons.person_sharp), label: "프로필"),
      ],
    );
  }
}
