import 'package:dio/dio.dart';
import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/brand300_button.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/providers/review_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class CreateReviewPage extends StatefulWidget {
  const CreateReviewPage(
      {Key? key,
      required this.bookId,
      required this.bookTitle,
      required this.bookAuthor,
      required this.bookCoverPath,
      required this.bookPublishYear,
      required this.bookPublisher})
      : super(key: key);

  final String bookId;
  final String bookTitle;
  final String bookAuthor;
  final String bookCoverPath;
  final String bookPublishYear;
  final String bookPublisher;
  @override
  State<CreateReviewPage> createState() => _CreateReviewPageState();
}

class _CreateReviewPageState extends State<CreateReviewPage> {
  late TextEditingController _textEditingController;
  late ScrollController _scrollController;
  double selectedScore = 3.0;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: brandColor100,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "리뷰 작성",
            style: TextStyle(
              color: grayColor600,
            ),
          ),
          backgroundColor: brandColor100,
          elevation: 0,
          iconTheme: IconThemeData(
            color: grayColor600,
          ),
        ),
        body: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 책 정보
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        widget.bookCoverPath,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 24),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Paragraph(
                              text: widget.bookTitle,
                              size: 24,
                              weightType: WeightType.semiBold,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Paragraph(
                              text: widget.bookAuthor,
                              color: grayColor300,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Paragraph(
                              text: widget.bookPublishYear,
                              color: grayColor300,
                            ),
                            const SizedBox(height: 4),
                            Paragraph(
                              text: widget.bookPublisher,
                              color: grayColor300,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "평점",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: grayColor500,
                    ),
                  ),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 20),

                  TextField(
                    controller: _textEditingController,
                    maxLength: 500,
                    maxLines: 12,
                    decoration: const InputDecoration(
                      hintText: '리뷰를 작성하세요.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          width: 1,
                          color: grayColor300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          width: 1,
                          color: brandColor200,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(24),
                    ),
                    onTap: () {
                      _scrollController.animateTo(
                          MediaQuery.of(context).viewInsets.bottom,
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.easeIn);
                    },
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Brand300Button(
                      text: '저장',
                      onPressed: () async {
                        try {
                          await context.read<ReviewProvider>().addComment(
                              widget.bookId, {
                            "score": selectedScore,
                            "content": _textEditingController.value.text
                          });
                          await context
                              .read<BookProvider>()
                              .getBookById(widget.bookId);
                          Navigator.pop(context);
                          Utils.flushBarSuccessMessage(
                              context.read<ReviewProvider>().success, context);
                        } on DioError catch (e) {
                          Utils.flushBarErrorMessage(
                              context.read<ReviewProvider>().error, context);
                          rethrow;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
