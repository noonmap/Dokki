import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:dokki/data/model/diary/diary_model.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiaryItem extends StatelessWidget {
  const DiaryItem({
    super.key,
    required this.diaryData,
  });

  final DiaryModel diaryData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.diaryDetail,
            arguments: {"bookId": diaryData.bookId});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: grayColor100),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Image.network(
                  width: double.infinity,
                  height: 180,
                  diaryData.diaryImagePath,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Paragraph(
                    text: diaryData.bookTitle,
                    weightType: WeightType.semiBold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Paragraph(
                    text: DateFormat('yyyy.MM.dd').format(diaryData.created),
                    size: 12,
                    color: grayColor300,
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
