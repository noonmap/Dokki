import 'package:dokki/constants/colors.dart';
import 'package:flutter/material.dart';

class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arg =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    print(arg);

    return Scaffold(
      backgroundColor: grayColor000,
      body: Center(child: Text(arg['bookId'])),
    );
  }
}
