import 'package:dokki/constants/colors.dart';
import 'package:dokki/ui/common_widget/paragraph.dart';
import 'package:flutter/material.dart';

class DiaryDetailPage extends StatelessWidget {
  const DiaryDetailPage({
    super.key,
    required int diaryId,
  });

  // 🍇 임시 데이터
  static Map<String, dynamic> tmpData = {
    'bookId': '1',
    'bookTitle': '엄청나게 긴 제목으로 테스트를 해야 합니다 더 길어야 해요',
    'diaryId': 1,
    'diaryImagePath':
        'https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2022/09/18/1e586277-48ba-4e8a-9b98-d8cdbe075d86.jpg',
    'diaryContent':
        '예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나 예쁜 카리나',
    'created': '2023-05-09',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(72, 80, 72, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: tmpData['diaryId'],
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
                    tmpData['diaryImagePath'],
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
                text: tmpData['bookTitle'],
                size: 20,
                weightType: WeightType.semiBold,
              ),
            ),
            const SizedBox(height: 28),
            Paragraph(
              text: tmpData['diaryContent'],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Paragraph(
                  text: tmpData['created'],
                  size: 14,
                  color: grayColor300,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
