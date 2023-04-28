import 'package:dokki/constants/colors.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/ui/common_widgets/thumb_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final bp = Provider.of<BookProvider>(context, listen: false);

      Map<String, dynamic> arg =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

      bp.getBookById(arg["bookId"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bp = Provider.of<BookProvider>(context);
    return Scaffold(
        backgroundColor: grayColor000,
        body: bp.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        ThumbImage(
                            thumbImagePath: bp.book.bookCoverPath,
                            width: 112,
                            height: 140),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: Column(
                          children: [
                            Text(
                              bp.book.bookTitle,
                            )
                          ],
                        ))
                      ],
                    )
                  ],
                ),
              ));
  }
}
