import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/opacity_loading.dart';
import 'package:dokki/common/widget/paragraph.dart';
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
          : Padding(
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
              child: Column(
                children: [
                  // 상단 메뉴바
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const SizedBox(
                          width: 32,
                          height: 32,
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 22,
                            color: brandColor300,
                          ),
                        ),
                      ),
                      const Paragraph(
                        text: '감정 일기 생성',
                        size: 18,
                        weightType: WeightType.medium,
                      ),
                      const SizedBox(
                        width: 32,
                        height: 32,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        bp.book!.bookCoverPath,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 24),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Paragraph(
                              text: bp.book!.bookTitle,
                              size: 24,
                              weightType: WeightType.semiBold,
                            ),
                            const SizedBox(height: 12),
                            Paragraph(
                              text: bp.book!.bookAuthor,
                              color: grayColor300,
                            ),
                            const SizedBox(height: 4),
                            Paragraph(
                              text: bp.book!.bookPublishYear,
                              color: grayColor300,
                            ),
                            const SizedBox(height: 4),
                            Paragraph(
                              text: bp.book!.bookPublisher,
                              color: grayColor300,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 36),
                  const Row(
                    children: [
                      Paragraph(
                        text: '나의 감정 일기',
                        size: 24,
                        weightType: WeightType.semiBold,
                      ),
                    ],
                  ),
                  const TextField()
                ],
              ),
            ),
    );
  }
}
