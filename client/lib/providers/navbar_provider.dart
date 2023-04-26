import 'package:dokki/ui/screens/dokki_grass_screen.dart';
import 'package:dokki/ui/screens/home_screen.dart';
import 'package:dokki/ui/screens/library_screen.dart';
import 'package:dokki/ui/screens/profile_screen.dart';
import 'package:dokki/ui/screens/search_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class NavbarProvider with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  final List<NavbarP> _items = [
    NavbarP(
      widget: const HomeScreen(),
      name: "홈",
      icon: Ionicons.home_sharp,
    ),
    NavbarP(
      widget: const SearchBookScreen(),
      name: "검색",
      icon: Ionicons.search_sharp,
    ),
    NavbarP(
      widget: const LibraryScreen(),
      name: "서재",
      icon: Ionicons.library_sharp,
    ),
    NavbarP(
      widget: const DokkiGrassScreen(),
      name: "텃밭",
      icon: Ionicons.flower_sharp,
    ),
    NavbarP(
      widget: const ProfileScreen(),
      name: "프로필",
      icon: Ionicons.person_sharp,
    ),
  ];

  List<NavbarP> get items => _items;
}

class NavbarP {
  String? name;
  IconData? icon;
  Widget? widget;

  NavbarP({this.widget, this.name, this.icon});
}
