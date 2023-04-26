import 'package:dokki/constants/colors.dart';
import 'package:dokki/providers/navbar_provider.dart';
import 'package:dokki/ui/view_model/search_book_view_model.dart';
import 'package:dokki/utils/routes/routes.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String _title = 'dokki';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavbarProvider>(create: (_) => NavbarProvider()),
        ChangeNotifierProvider<SearchBookViewModel>(
            create: (_) => SearchBookViewModel()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: brandColor100,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: RoutesName.login,
        onGenerateRoute: Routes.generateRoute,
        title: _title,
      ),
    );
  }
}
