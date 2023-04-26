import 'package:dokki/ui/view/search_book_view.dart';
import 'package:dokki/ui/view_model/search_book_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBookScreen extends StatelessWidget {
  const SearchBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SearchBookView();
  }
}
