import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/opacity_loading.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:dokki/providers/diary_provider.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DiaryDetailPage extends StatefulWidget {
  const DiaryDetailPage({
    super.key,
    required this.bookId,
  });

  final String bookId;

  @override
  State<DiaryDetailPage> createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends State<DiaryDetailPage> {
  @override
  void initState() {
    final dp = Provider.of<DiaryProvider>(context, listen: false);
    dp.getDiaryByBookId(bookId: widget.bookId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dp = Provider.of<DiaryProvider>(context);

    Future<void> onEditButtonTap() async {
      Navigator.popAndPushNamed(context, RoutesName.diaryCreate,
          arguments: {'existingBookId': widget.bookId});
    }

    Future<void> onDeleteButtonTap() async {
      await dp.deleteDiary(diaryId: dp.diary!.diaryId);
      await dp.getDiaries(page: 0);
      Navigator.pushNamed(context, RoutesName.diary);
    }

    return Scaffold(
      body: dp.isDetailLoading
          ? const OpacityLoading()
          : SingleChildScrollView(
              child: Column(
                children: [
                  // 상단 메뉴바
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const SizedBox(
                            width: 40,
                            height: 32,
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 22,
                              color: brandColor300,
                            ),
                          ),
                        ),
                        const Paragraph(
                          text: '나의 감정 일기',
                          size: 18,
                          weightType: WeightType.medium,
                        ),
                        const SizedBox(
                          width: 40,
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(72, 0, 72, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: dp.diary!.diaryId,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  offset: const Offset(4, 4),
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ]),
                              child: Image.network(
                                dp.diary!.diaryImagePath,
                                width: 240,
                                height: 240,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: Paragraph(
                            text: dp.diary!.bookTitle,
                            size: 20,
                            weightType: WeightType.semiBold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Paragraph(
                              text: DateFormat('yyyy.MM.dd')
                                  .format(dp.diary!.created),
                              size: 14,
                              color: grayColor300,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Paragraph(
                          text: dp.diary!.diaryContent,
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: onEditButtonTap,
                              child: const Paragraph(
                                text: '수정',
                                color: grayColor300,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: onDeleteButtonTap,
                              child: const Paragraph(
                                text: '삭제',
                                color: grayColor300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
