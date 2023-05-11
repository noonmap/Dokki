import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/bottom_sheet_modal.dart';
import 'package:dokki/common/widget/opacity_loading.dart';
import 'package:dokki/data/model/book/book_detail_model.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/view/book_detail/widget/book_item.dart';
import 'package:dokki/view/book_detail/widget/review_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailPage extends StatefulWidget {
  final String bookId;
  const BookDetailPage({super.key, required this.bookId});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage>
    with TickerProviderStateMixin {
  late Future<BookDetailModel> _data;

  @override
  void initState() {
    super.initState();
    _data = context.read<BookProvider>().getBookById(widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    final clientWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: brandColor100,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                builder: (BuildContext context) {
                  return BottomSheetModal(bookId: widget.bookId);
                },
              );
            },
            child: const Text(
              "저장",
              style: TextStyle(
                  color: grayColor500,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
        iconTheme: const IconThemeData(
          color: grayColor500,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<BookDetailModel>(
          future: _data,
          builder:
              (BuildContext context, AsyncSnapshot<BookDetailModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Center(child: Text("error"));
              }
              return SingleChildScrollView(
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: brandColor100,
                        ),
                        padding: const EdgeInsets.fromLTRB(35, 10, 35, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                snapshot.data!.bookTitle,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                softWrap: false,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            BookItem(
                                imagePath: snapshot.data!.bookCoverPath,
                                backImagePath:
                                    snapshot.data!.bookCoverBackImagePath,
                                sideImagePath:
                                    snapshot.data!.bookCoverSideImagePath,
                                width: clientWidth / 2,
                                height: clientWidth / 1.6,
                                depth: (snapshot.data!.bookTotalPage / 5.5 > 100
                                        ? 100
                                        : snapshot.data!.bookTotalPage / 5.5)
                                    .toDouble()),
                            const SizedBox(
                              height: 55,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MoreInfo(
                                    icon: Icons.star_border_rounded,
                                    text: snapshot.data!.meanScore.toString()),
                                SizedBox(width: 10),
                                MoreInfo(
                                    icon: Icons.people_outline,
                                    text:
                                        snapshot.data!.readerCount.toString()),
                                SizedBox(width: 10),
                                MoreInfo(
                                    icon: Icons.av_timer_sharp,
                                    text: "${snapshot.data!.meanReadTime}h"),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: brandColor100,
                        ),
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
                            vertical: 18, horizontal: 20),
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  snapshot.data!.bookSummary,
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
                                  snapshot.data!.bookAuthor,
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
                                  snapshot.data!.bookPublisher,
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
                                  snapshot.data!.bookTotalPage.toString(),
                                )
                              ],
                            ),
                            ListView.builder(
                              itemCount: snapshot.data!.review.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.only(
                                      bottom: 16, top: 16),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1, color: grayColor100))),
                                  child: ReviewItem(
                                      profileImagePath: snapshot
                                          .data!.review[index].profileImagePath,
                                      nickname:
                                          snapshot.data!.review[index].nickname,
                                      content:
                                          snapshot.data!.review[index].content,
                                      score:
                                          snapshot.data!.review[index].score),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const OpacityLoading();
            }
          },
        ),
      ),
    );
  }
}

class StatisticInfo extends StatelessWidget {
  final String title, value;
  final IconData iconData;

  const StatisticInfo(
      {super.key,
      required this.title,
      required this.value,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
              color: brandColor000,
              borderRadius: BorderRadius.all(Radius.circular(48))),
          child: Icon(
            iconData,
            size: 24,
            color: brandColor300,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: grayColor300,
                fontSize: 13,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              value,
              style: const TextStyle(
                letterSpacing: 1,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
      ],
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
