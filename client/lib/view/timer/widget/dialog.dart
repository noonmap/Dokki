import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/providers/review_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class CustomDialogBox extends StatefulWidget {
  final int bookStatusId;
  final String bookId;
  final String title;
  final int accumReadTime;
  const CustomDialogBox({
    Key? key,
    required this.title,
    required this.accumReadTime,
    required this.bookStatusId,
    required this.bookId,
  }) : super(key: key);

  @override
  State<CustomDialogBox> createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  double selectedScore = 3.0;
  String textFieldValue = "";
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      height: 400,
      decoration: BoxDecoration(
        color: brandColor000,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            color: Color(0XFF2C3A47),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Ionicons.time,
                      color: brandColor100,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "읽은 시간",
                      style: TextStyle(
                        color: brandColor100,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                Text(
                  "${Utils.secondTimeToFormatString(widget.accumReadTime)}",
                  style: TextStyle(
                    color: brandColor100,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "리뷰 작성",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          RatingBar(
            minRating: 1,
            maxRating: 5,
            initialRating: selectedScore,
            onRatingUpdate: (value) {
              setState(() {
                selectedScore = value;
              });
            },
            ratingWidget: RatingWidget(
              full: const Icon(
                Icons.star,
                color: yellowColor400,
              ),
              empty: const Icon(Icons.star, color: grayColor200),
              half: const Icon(Icons.star_half, color: yellowColor400),
            ),
            itemCount: 5,
            itemSize: 30,
            itemPadding: const EdgeInsets.only(right: 4.0),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TextField(
              minLines: null,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: '리뷰를 작성해주세요!',
                hintStyle: const TextStyle(
                  color: grayColor300,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: grayColor300, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: grayColor300, width: 1),
                ),
              ),
              expands: true,
              onChanged: (value) {
                setState(
                  () {
                    textFieldValue = value;
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: ElevatedButton(
              onPressed: () async {
                // 완독 + 리뷰 작성
                await context
                    .read<BookProvider>()
                    .updateCompleteBook(widget.bookStatusId);
                await context.read<ReviewProvider>().addComment(widget.bookId,
                    {"content": textFieldValue, "score": selectedScore});
                Navigator.pop(context);
                Utils.flushBarSuccessMessage("해당 책이 서재로 이동되었습니다.", context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Color(0XFF2C3A47);
                    }
                    return Color(0XFF2C3A47);
                  },
                ),
              ),
              child: const Text(
                "완독",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: brandColor100,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
