import 'package:dokki/screens/home_screen/view/book_list_view.dart';
import 'package:dokki/screens/home_screen/viewModel/book_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListViewModel>(
        create: (_) => BookListViewModel(), child: BookListView());
  }
}
