import 'package:dokki/ui/book_detail/book_detail_page.dart';
import 'package:dokki/ui/book_search/search_book_page.dart';
import 'package:dokki/ui/dokki_grass/dokki_grass_page.dart';
import 'package:dokki/ui/home/home_page.dart';
import 'package:dokki/ui/library/library_page.dart';
import 'package:dokki/ui/login/login_page.dart';
import 'package:dokki/ui/main/main_page.dart';
import 'package:dokki/ui/profile/profile_page.dart';
import 'package:dokki/ui/splash/splash_page.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.main:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MainPage());
      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomePage());
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashPage());
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage());
      case RoutesName.searchBook:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SearchBookPage());
      case RoutesName.bookDetail:
        return MaterialPageRoute(
            builder: (BuildContext context) => const BookDetailPage(),
            settings: settings);
      case RoutesName.library:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LibraryPage());
      case RoutesName.dokkiGrass:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DokkiGrassPage());
      case RoutesName.profile:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProfilePage());
      default:
        return MaterialPageRoute(
          builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text("No Route Defined!"),
              ),
            );
          },
        );
    }
  }
}
