import 'package:dokki/screens/home_screen/viewModel/book_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 게시물 목록 View
class BookListView extends StatelessWidget {
  late BookListViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel =
        Provider.of<BookListViewModel>(context); // Provider로 viewModel을 가져온다.
    return Scaffold(
      body: _buildBookList(),
    );
  }

  Widget _buildBookList() {
    final items = viewModel.items; // viewModel에 저장된 items
    final itemCount = items.length;
    return ListView.builder(
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(title: Text(item.bookTitle));
      },
      itemCount: itemCount,
    );
  }
}
