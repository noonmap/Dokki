import 'package:dokki/ui/screens/dokki_grass_screen.dart';
import 'package:dokki/ui/screens/home_screen.dart';
import 'package:dokki/ui/screens/library_screen.dart';
import 'package:dokki/ui/screens/login_screen.dart';
import 'package:dokki/ui/screens/profile_screen.dart';
import 'package:dokki/ui/screens/router_screen.dart';
import 'package:dokki/ui/screens/search_book_screen.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.common:
        return MaterialPageRoute(
            builder: (BuildContext context) => const RouterScreen());
      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen());
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());
      case RoutesName.searchBook:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SearchBookScreen());
      case RoutesName.library:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LibraryScreen());
      case RoutesName.dokkiGrass:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DokkiGrassScreen());
      case RoutesName.profile:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProfileScreen());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text("No Route Defined!"),
            ),
          );
        });
    }
  }
}
