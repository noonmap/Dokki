import 'package:dokki/constants/colors.dart';
import 'package:dokki/providers/navbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouterScreen extends StatelessWidget {
  const RouterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<NavbarProvider>(context, listen: true);
    return Scaffold(
      body: mp.items[mp.selectedIndex].widget,
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: brandColor300,
          unselectedItemColor: grayColor300,
          type: BottomNavigationBarType.fixed,
          iconSize: 24,
          currentIndex: mp.selectedIndex,
          onTap: (i) {
            mp.selectedIndex = i;
          },
          items: mp.items
              .map(
                (item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.name,
                ),
              )
              .toList()),
    );
  }
}
