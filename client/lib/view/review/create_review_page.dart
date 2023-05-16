import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/brand300_button.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:flutter/material.dart';

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
        resizeToAvoidBottomInset: false,
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
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
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
                const SizedBox(height: 36),
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
                ),
                const SizedBox(height: 10),
                Brand300Button(
                  text: '저장',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ));
  }
}
