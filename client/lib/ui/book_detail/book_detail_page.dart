import 'dart:math';

import 'package:dokki/constants/colors.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/ui/book_detail/widgets/book_item.dart';
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
  final double _rx = 0.0;
  double _ry = 0.0;
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          decoration: const BoxDecoration(
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: grayColor200,
                              //     blurRadius: 10.0,
                              //     spreadRadius: 1.0,
                              //     offset: Offset(27, 4),
                              //   ),
                              // ],
                              ),
                          child: BookItem(
                              imagePath: bp.book!.bookCoverPath,
                              width: 200,
                              height: 300,
                              rotateY: _ry,
                              rotateX: _rx,
                              depth: 40.0),
                        ),
                      ),
                      Slider(
                        min: pi * -2,
                        max: pi * 2,
                        value: _ry,
                        onChanged: (value) => setState(
                          () {
                            _ry = value;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text(
                          bp.book!.bookTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: grayColor600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          bp.book!.bookAuthor,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: grayColor300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
