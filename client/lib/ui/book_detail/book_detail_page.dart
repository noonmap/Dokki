import 'package:dokki/constants/colors.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/ui/common_widgets/thumb_image.dart';
import 'package:dokki/utils/utils.dart';
import "package:flutter/foundation.dart" as foundation;
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
        appBar: AppBar(
          backgroundColor: brandColor100,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                print("저장");
              },
              child: const Text(
                "저장",
                style: TextStyle(
                    color: grayColor500,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
          iconTheme: const IconThemeData(
            color: grayColor500,
          ),
        ),
        backgroundColor: grayColor000,
        body: bp.isLoading || bp.book == null
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Container(
                  padding: foundation.defaultTargetPlatform ==
                          foundation.TargetPlatform.iOS
                      ? Utils.getIosCommonPadding()
                      : Utils.getAndroidCommonPadding(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ThumbImage(
                            thumbImagePath: bp.book!.bookCoverPath,
                            width: 112,
                            height: 140,
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Flexible(
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    bp.book!.bookTitle,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    bp.book!.bookAuthor,
                                    style: const TextStyle(color: grayColor300),
                                  ),
                                  Text(
                                    "${bp.book!.bookPublishYear} • ${bp.book!.bookPublisher}",
                                    style: const TextStyle(color: grayColor300),
                                  ),
                                  Text(
                                    "${bp.book!.bookTotalPage}p",
                                    style: const TextStyle(color: grayColor300),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ));
  }
}
