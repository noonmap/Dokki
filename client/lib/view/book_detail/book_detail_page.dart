import 'dart:ui';

import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/opacity_loading.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/view/book_detail/widget/book_item.dart';
import 'package:dokki/view/book_detail/widget/detail_app_bar.dart';
import 'package:dokki/view/book_detail/widget/review_item.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class BookDetailPage extends StatefulWidget {
  final String bookId;
  const BookDetailPage({super.key, required this.bookId});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().getBookById(widget.bookId);
    });
  }

  int getStatusIndex(bool isReading, bool isBookMarked, bool isComplete) {
    if (isReading) {
      // 읽는 중인 상태
      return 1;
    } else if (isComplete) {
      // 완독서 상태
      return 2;
    }
    return 0; // 아무 상태도 없는 경우
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    final clientWidth = MediaQuery.of(context).size.width;
    final clientHeight = MediaQuery.of(context).size.height;
    final bp = Provider.of<BookProvider>(context, listen: true);
    if (bp.book == null) {
      return Scaffold(
        backgroundColor: brandColor100,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Book Details",
            style: TextStyle(
              color: grayColor600,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: grayColor100,
        ),
        body: Container(
          decoration: const BoxDecoration(color: brandColor100),
          child: const OpacityLoading(),
        ),
      );
    } else {
      return Stack(
        children: [
          Scaffold(
              backgroundColor: brandColor200,
              appBar: DetailAppBar(
                  bookId: widget.bookId,
                  isBookMarked: bp.book!.isBookMarked,
                  addLikeBook: bp.addLikeBook,
                  deleteLikeBook: bp.deleteLikeBook,
                  getBookById: bp.getBookById),
              body: Stack(
                children: [
                  SizedBox(
                    width: clientWidth,
                    height: clientHeight / 4,
                  ),
                  Container(
                    width: clientWidth,
                    height: MediaQuery.of(context).size.height - 220,
                    margin: const EdgeInsets.only(top: 180),
                    decoration: const BoxDecoration(
                      color: brandColor000,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(36.0),
                        topLeft: Radius.circular(36.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 75, 10, 10),
                      child: SingleChildScrollView(
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      bp.book!.bookTitle,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Center(
                                    child: Text(
                                      bp.book!.bookAuthor,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MoreInfo(
                                          icon: Icons.star_border_rounded,
                                          text: bp.book!.meanScore.toString()),
                                      SizedBox(width: 10),
                                      MoreInfo(
                                          icon: Icons.people_outline,
                                          text:
                                              bp.book!.readerCount.toString()),
                                      SizedBox(width: 10),
                                      MoreInfo(
                                          icon: Icons.av_timer_sharp,
                                          text: "${bp.book!.meanReadTime}h"),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                child: TabBar(
                                  indicatorColor: brandColor300,
                                  indicatorWeight: 3,
                                  labelColor: brandColor300,
                                  unselectedLabelColor: brandColor200,
                                  controller: tabController,
                                  labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                  unselectedLabelStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                  tabs: const [
                                    Tab(
                                      text: "책 정보",
                                      icon: Icon(Icons.menu_book_outlined),
                                    ),
                                    Tab(
                                      text: "리뷰",
                                      icon: Icon(Icons.comment_outlined),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 370,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 0),
                                child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "책 소개",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          bp.book!.bookSummary,
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: const TextStyle(
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        const Text(
                                          "작가",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          bp.book!.bookAuthor,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: const TextStyle(
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        const Text(
                                          "출판사",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          bp.book!.bookPublisher,
                                          style: const TextStyle(
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        const Text(
                                          "페이지",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          bp.book!.bookTotalPage.toString(),
                                        )
                                      ],
                                    ),
                                    ListView.builder(
                                      itemCount: bp.book!.review.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: const EdgeInsets.only(
                                              bottom: 16, top: 16),
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1,
                                                      color: grayColor100))),
                                          child: ReviewItem(
                                              profileImagePath: bp
                                                  .book!
                                                  .review[index]
                                                  .profileImagePath,
                                              nickname: bp
                                                  .book!.review[index].nickname,
                                              content: bp
                                                  .book!.review[index].content,
                                              score:
                                                  bp.book!.review[index].score),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: BookItem(
                      imagePath: bp.book!.bookCoverPath,
                      backImagePath: bp.book!.bookCoverBackImagePath,
                      sideImagePath: bp.book!.bookCoverSideImagePath,
                      width: clientWidth / 2.5,
                      height: clientWidth / 2,
                      depth: (bp.book!.bookTotalPage / 5.5 > 100
                              ? 100
                              : bp.book!.bookTotalPage / 5.5)
                          .toDouble(),
                    ),
                  ),
                ],
              )),
          if (bp.isDetailLoading) const OpacityLoading(),
        ],
      );
    }
  }
}

class BookStatusBadge extends StatelessWidget {
  final int statusIndex;

  const BookStatusBadge({super.key, required this.statusIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
          color: brandColor300, borderRadius: BorderRadius.circular(24.0)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            statusIndex == 0
                ? Icons.bookmark_added_sharp
                : statusIndex == 1
                    ? Ionicons.bookmark_sharp
                    : Ionicons.golf_sharp,
            color: grayColor000,
            size: 16.0,
          ),
          const SizedBox(width: 6),
          Text(
            statusIndex == 0
                ? "찜한 책"
                : statusIndex == 1
                    ? "읽는 중인 책"
                    : "완독서",
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: grayColor000,
            ),
          ),
        ],
      ),
    );
  }
}

class MoreInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const MoreInfo({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 12,
      ),
      decoration: const BoxDecoration(
          color: brandColor000,
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: brandColor300,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
