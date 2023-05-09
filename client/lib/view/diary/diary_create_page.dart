import 'package:dokki/common/widget/opacity_loading.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/providers/diary_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiaryCreatePage extends StatefulWidget {
  const DiaryCreatePage({
    super.key,
    required this.bookId,
  });

  final String bookId;

  @override
  State<DiaryCreatePage> createState() => _DiaryCreatePageState();
}

class _DiaryCreatePageState extends State<DiaryCreatePage> {
  @override
  void initState() {
    final dp = Provider.of<DiaryProvider>(context, listen: false);
    final bp = Provider.of<BookProvider>(context, listen: false);
    dp.getDiaryImageCount();
    bp.getBookById(widget.bookId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dp = Provider.of<DiaryProvider>(context);
    final bp = Provider.of<BookProvider>(context);

    return Scaffold(
      body: dp.isCountLoading || bp.isDetailLoading
          ? const OpacityLoading()
          : const Padding(
              padding: EdgeInsets.fromLTRB(28, 40, 28, 40),
              child: Column(
                children: [Text('///')],
              ),
            ),
    );
  }
}
