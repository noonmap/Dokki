import 'dart:io';

import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/brand300_button.dart';
import 'package:dokki/common/widget/opacity_loading.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:dokki/providers/diary_provider.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DiaryCreatePage extends StatefulWidget {
  const DiaryCreatePage({
    super.key,
    this.bookId,
    this.bookTitle,
    this.bookAuthor,
    this.bookPublishYear,
    this.bookPublisher,
    this.bookCoverPath,
    this.existingBookId,
  });

  final String? bookId;
  final String? bookTitle;
  final String? bookAuthor;
  final String? bookCoverPath;
  final String? bookPublishYear;
  final String? bookPublisher;
  final String? existingBookId;

  @override
  State<DiaryCreatePage> createState() => _DiaryCreatePageState();
}

class _DiaryCreatePageState extends State<DiaryCreatePage> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();
  bool isImageLoading = false;
  int? diaryImageCount = 5;
  bool isEdit = false;
  bool notClicked = true;
  bool selectClicked = false;
  bool createClicked = false;

  @override
  void initState() {
    final dp = Provider.of<DiaryProvider>(context, listen: false);

    dp.initProvider();
    dp.getDiaryImageCount();

    if (dp.diaryImageCount != null) {
      setState(() {
        diaryImageCount = dp.diaryImageCount;
      });
    }

    if (widget.existingBookId != null) {
      setState(() {
        isEdit = true;
      });

      () async {
        await dp.getDiaryByBookId(bookId: widget.existingBookId!);

        setState(() {
          _textEditingController =
              TextEditingController(text: dp.diary?.diaryContent);
        });
      }();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dp = Provider.of<DiaryProvider>(context);
    final ImagePicker imagePicker = ImagePicker();
    File? pickedImg;
    double maxWidth = MediaQuery.of(context).size.width;

    Future<void> onCreateButtonPressed() async {
      if (dp.diaryImageCount! < 1) {
        Utils.flushBarErrorMessage("더이상 생성할 수 없습니다.", context);
        return;
      }

      setState(() {
        isImageLoading = true;
        notClicked = false;
      });

      Utils.scrollToBottom(_scrollController);
      await dp.postDiaryImage(content: _textEditingController.text);

      if (dp.isImageError) {
        Utils.flushBarErrorMessage('요청이 너무 많습니다. 다시 시도해주세요.', context);
        return;
      }

      setState(() {
        isImageLoading = false;
        selectClicked = false;
        createClicked = true;
      });

      Utils.scrollToBottom(_scrollController);
    }

    void onSaveButtonPressedWithException() {
      Utils.flushBarErrorMessage("이미지 생성 후 저장할 수 있습니다.", context);
    }

    Future<void> onSaveButtonPressed() async {
      if (isEdit) {
        await dp.putDiary(
          diaryId: dp.diary!.diaryId,
          content: _textEditingController.text,
          imagePath: dp.diaryImage!,
        );
      } else {
        await dp.postDiary(
            bookId: widget.bookId!,
            content: _textEditingController.text,
            imagePath: dp.diaryImage!);
      }

      Navigator.popAndPushNamed(
        context,
        RoutesName.diaryDetail,
        arguments: {"bookId": isEdit ? dp.diary!.bookId : widget.bookId},
      );
    }

    Future<void> getImageFromGallery() async {
      setState(() {
        isImageLoading = true;
        notClicked = false;
      });

      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          pickedImg = File(pickedFile.path);
        });

        Utils.scrollToBottom(_scrollController);
        await dp.postDiaryUserImage(img: pickedImg!);

        setState(() {
          selectClicked = true;
          createClicked = false;
          isImageLoading = false;
        });
        Utils.scrollToBottom(_scrollController);
      }
    }

    return Scaffold(
      body: (isEdit && dp.isDetailLoading)
          ? const OpacityLoading()
          : GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Padding(
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
                        Paragraph(
                          text: isEdit ? '감정 일기 수정' : '감정 일기 생성',
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
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            // 책 정보
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  isEdit
                                      ? dp.diary!.bookCoverPath
                                      : widget.bookCoverPath!,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 24),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Paragraph(
                                        text: isEdit
                                            ? dp.diary!.bookTitle
                                            : widget.bookTitle!,
                                        size: 24,
                                        weightType: WeightType.semiBold,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),
                                      Paragraph(
                                        text: isEdit
                                            ? dp.diary!.bookAuthor
                                            : widget.bookAuthor!,
                                        color: grayColor300,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Paragraph(
                                        text: isEdit
                                            ? dp.diary!.bookPublishYear
                                            : widget.bookPublishYear!,
                                        color: grayColor300,
                                      ),
                                      const SizedBox(height: 4),
                                      Paragraph(
                                        text: isEdit
                                            ? dp.diary!.bookPublisher
                                            : widget.bookPublisher!,
                                        color: grayColor300,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 36),
                            // 감정 일기 입력
                            TextField(
                              controller: _textEditingController,
                              maxLength: 500,
                              maxLines: 12,
                              decoration: const InputDecoration(
                                hintText: '감정 일기를 작성하세요.',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: grayColor300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: brandColor200,
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(24),
                              ),
                            ),
                            const Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: brandColor400,
                                  size: 14,
                                ),
                                Paragraph(
                                  text: ' 이미지 생성은 하루에 5번만 가능합니다.',
                                  color: brandColor300,
                                  size: 14,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // 버튼들
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Brand300Button(
                                  text: '이미지 삽입',
                                  onPressed: getImageFromGallery,
                                ),
                                const SizedBox(width: 24),
                                Column(
                                  children: [
                                    Brand300Button(
                                      text: '이미지 생성',
                                      onPressed: onCreateButtonPressed,
                                    ),
                                    Paragraph(
                                      text: '${dp.diaryImageCount} / 5',
                                      color: grayColor300,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 이미지 버튼 클릭하지 않았고, 등록 페이지면
                                if (notClicked && !isEdit)
                                  SizedBox(
                                    width: maxWidth - 60,
                                    height: maxWidth - 60,
                                    child: const Center(
                                      child: Paragraph(text: '이미지를 등록해주세요.'),
                                    ),
                                  ),
                                // 이미지 버튼 클릭하지 않았고, 수정 페이지면
                                if (notClicked && isEdit)
                                  Image.network(
                                    dp.diary!.diaryImagePath,
                                    width: maxWidth - 60,
                                    height: maxWidth - 60,
                                    fit: BoxFit.cover,
                                  ),
                                // 로딩중이면
                                if (!notClicked && isImageLoading)
                                  SizedBox(
                                    width: maxWidth - 60,
                                    height: maxWidth - 60,
                                    child: const OpacityLoading(),
                                  ),
                                // 로딩이 됐으면
                                if (!notClicked &&
                                    !isImageLoading &&
                                    dp.isImageLoaded)
                                  Image.network(
                                    dp.diaryImage!,
                                    width: maxWidth - 60,
                                    height: maxWidth - 60,
                                    fit: BoxFit.cover,
                                  ),
                              ],
                            ),
                            if (!notClicked || isEdit)
                              Column(
                                children: [
                                  const SizedBox(height: 32),
                                  Brand300Button(
                                    text: '저장',
                                    onPressed: isImageLoading
                                        ? onSaveButtonPressedWithException
                                        : onSaveButtonPressed,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
