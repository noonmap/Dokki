import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/opacity_loading.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:dokki/providers/diary_provider.dart';
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

    return Scaffold(
      body: dp.isDetailLoading
          ? const OpacityLoading()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(72, 80, 72, 40),
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
                    const SizedBox(height: 28),
                    Paragraph(
                      text: dp.diary!.diaryContent,
                    ),
                    const SizedBox(height: 24),
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
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
