import 'package:dokki/constants/colors.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/ui/book_detail/widgets/book_item.dart';
import 'package:dokki/ui/book_detail/widgets/review_item.dart';
import 'package:dokki/ui/common_widgets/bottom_sheet_modal.dart';
import 'package:dokki/ui/common_widgets/opacity_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final bp = Provider.of<BookProvider>(context, listen: false);
      Map<String, dynamic> arg =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      bp.errorMessage = "";
      bp.successMessage = "";
      bp.getBookById(arg["bookId"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arg =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final bp = Provider.of<BookProvider>(context);

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
                  return BottomSheetModal(bookId: arg["bookId"]);
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
      body: bp.isDetailLoading
          ? const OpacityLoading()
          : SafeArea(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: brandColor100,
                              ),
                              padding:
                                  const EdgeInsets.fromLTRB(35, 10, 35, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      bp.book!.bookTitle,
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
                                      imagePath: bp.book!.bookCoverPath,
                                      backImagePath:
                                          bp.book!.bookCoverBackImagePath,
                                      sideImagePath:
                                          bp.book!.bookCoverSideImagePath,
                                      width: clientWidth / 2,
                                      height: clientWidth / 1.6,
                                      depth: (bp.book!.bookTotalPage / 5.5 > 100
                                              ? 100
                                              : bp.book!.bookTotalPage / 5.5)
                                          .toDouble()),
                                  const SizedBox(
                                    height: 55,
                                  ),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MoreInfo(
                                          icon: Icons.star_border_rounded,
                                          text: "4.8"),
                                      SizedBox(width: 10),
                                      MoreInfo(
                                          icon: Icons.people_outline,
                                          text: "1121"),
                                      SizedBox(width: 10),
                                      MoreInfo(
                                          icon: Icons.av_timer_sharp,
                                          text: "4.8h"),
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
                                            profileImagePath: bp.book!
                                                .review[index].profileImagePath,
                                            nickname:
                                                bp.book!.review[index].nickname,
                                            content:
                                                bp.book!.review[index].content,
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
                  );
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
