import 'package:dokki/constants/colors.dart';
import 'package:dokki/screens/home_screen/view/book_list_view.dart';
import 'package:dokki/screens/home_screen/viewModel/book_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListViewModel>(
      create: (_) => BookListViewModel(),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {},
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
        body: BookListView(),
      ),
    );
  }
}
