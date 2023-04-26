import 'package:dokki/ui/view/book_list_view.dart';
import 'package:dokki/ui/widgets/search_input.dart';
import 'package:flutter/material.dart';

class SearchBookPage extends StatelessWidget {
  const SearchBookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
      child: const Column(
        children: [
          SearchInput(),
          Expanded(
            child: BookListView(),
          )
        ],
      ),
    );
  }
}
