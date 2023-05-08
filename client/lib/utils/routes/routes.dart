import 'package:dokki/ui/book_detail/book_detail_page.dart';
import 'package:dokki/ui/book_search/search_book_page.dart';
import 'package:dokki/ui/diary/diary_detail_page.dart';
import 'package:dokki/ui/diary/diary_page.dart';
import 'package:dokki/ui/dokki_grass/dokki_grass_page.dart';
import 'package:dokki/ui/home/home_page.dart';
import 'package:dokki/ui/library/library_page.dart';
import 'package:dokki/ui/login/login_page.dart';
import 'package:dokki/ui/main/main_page.dart';
import 'package:dokki/ui/profile/follow_page.dart';
import 'package:dokki/ui/profile/profile_page.dart';
import 'package:dokki/ui/profile/wishlist_page.dart';
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
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                LibraryPage(userId: args['userId']),
            settings: settings);

      case RoutesName.dokkiGrass:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DokkiGrassPage());

      case RoutesName.profile:
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                ProfilePage(userId: args['userId']),
            settings: settings);

      case RoutesName.follow:
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                FollowPage(userId: args['userId'], category: args['category']),
            settings: settings);

      case RoutesName.wishlist:
        return MaterialPageRoute(
            builder: (BuildContext context) => const WishlistPage());

      case RoutesName.diary:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DiaryPage());

      case RoutesName.diaryDetail:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DiaryDetailPage());

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
