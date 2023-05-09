import 'package:dokki/data/model/library/library_book_model.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class LibraryBookItem extends StatelessWidget {
  const LibraryBookItem({super.key, required this.bookData});

  final LibraryBookModel bookData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.bookDetail,
            arguments: {'bookId': bookData.bookId});
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(4, 4),
              color: Colors.black.withOpacity(0.2),
            ),
          ],
        ),
        child: Image.network(
          bookData.bookCoverPath,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
