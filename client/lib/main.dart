import 'package:dokki/constants/colors.dart';
import 'package:dokki/constants/url.dart';
import 'package:dokki/screens/home_screen/home_screen.dart';
import 'package:dokki/screens/login_screen/login_screen.dart';
import 'package:dokki/screens/splash_screen/splash_screen.dart';
import 'package:dokki/utils/routes/routes.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String _title = 'dokki';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: brandColor100,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: RoutesName.login,
      onGenerateRoute: Routes.generateRoute,
      title: _title,
    );
  }
}
