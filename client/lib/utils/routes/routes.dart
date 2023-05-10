import 'package:dokki/utils/routes/routes_name.dart';
import 'package:dokki/view/book_detail/book_detail_page.dart';
import 'package:dokki/view/book_search/search_book_page.dart';
import 'package:dokki/view/diary/diary_create_page.dart';
import 'package:dokki/view/diary/diary_detail_page.dart';
import 'package:dokki/view/diary/diary_page.dart';
import 'package:dokki/view/dokki_grass/dokki_grass_page.dart';
import 'package:dokki/view/home/home_page.dart';
import 'package:dokki/view/library/library_page.dart';
import 'package:dokki/view/login/login_page.dart';
import 'package:dokki/view/main/main_page.dart';
import 'package:dokki/view/profile/follow_page.dart';
import 'package:dokki/view/profile/profile_page.dart';
import 'package:dokki/view/profile/wishlist_page.dart';
import 'package:dokki/view/splash/splash_page.dart';
import 'package:dokki/view/timer/timer_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.main:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MainPage());

      case RoutesName.home:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
            builder: (BuildContext context) => const HomePage());
      case RoutesName.timer:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (BuildContext context) => TimerPage(
            bookStatusId: args["bookStatusId"],
            bookTitle: args["bookTitle"],
          ),
          settings: settings,
        );
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
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (BuildContext context) => BookDetailPage(
                  bookId: args['bookId'],
                ),
            settings: settings);

      case RoutesName.library:
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                LibraryPage(userId: args['userId']),
            settings: settings);

      case RoutesName.dokkiGrass:
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                DokkiGrassPage(userId: args['userId']),
            settings: settings);

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
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                DiaryDetailPage(bookId: args['bookId']),
            settings: settings);

      case RoutesName.diaryCreate:
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                DiaryCreatePage(bookId: args['bookId']),
            settings: settings);

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
