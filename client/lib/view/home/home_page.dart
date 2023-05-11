import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/constant/common.dart';
import 'package:dokki/common/widget/opacity_loading.dart';
import 'package:dokki/providers/status_book_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:dokki/view/book_search/widget/book_list_item.dart';
import 'package:dokki/view/home/widget/reading_book_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    fetchData("0");
  }

  void fetchData(String userId) async {
    final sbp = Provider.of<StatusBookProvider>(context, listen: false);

    sbp.initProvider();
    sbp.getReadTimeToday(userId);
    sbp.getLikeBookList("0", PAGE_LIMIT);
    sbp.getReadingBookList("0", PAGE_LIMIT);
  }

  @override
  Widget build(BuildContext context) {
    print("home build");
    final sbp = Provider.of<StatusBookProvider>(context);
    TabController tabController = TabController(length: 2, vsync: this);
    return sbp.isTodayLoading || sbp.isLikeLoading || sbp.isReadingLoading
        ? const OpacityLoading()
        : Container(
            decoration: const BoxDecoration(color: brandColor100),
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  height: 160,
                  decoration: const BoxDecoration(color: brandColor100),
                  child: Column(
                    children: [
                      Text(
                        Utils.getToday(),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        Utils.secondTimeToFormatString(sbp.todayReadTime),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(color: grayColor000),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      children: [
                        TabBar(
                          indicatorColor: brandColor300,
                          indicatorWeight: 3,
                          labelColor: brandColor300,
                          unselectedLabelColor: brandColor200,
                          controller: tabController,
                          labelPadding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          tabs: const [
                            Tab(
                              text: "읽는 중",
                            ),
                            Tab(
                              text: "찜 목록",
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              ListView.separated(
                                itemBuilder: (_, index) {
                                  final item = sbp.readingBookList[index];
                                  return ReadingBookItem.fromModel(model: item);
                                },
                                separatorBuilder: (_, index) {
                                  return const SizedBox(height: 8.0);
                                },
                                itemCount: sbp.readingBookList.length,
                              ),
                              ListView.separated(
                                  itemBuilder: (_, index) {
                                    final item = sbp.likeBookList[index];
                                    return BookListItem(
                                      bookId: item.bookId,
                                      bookTitle: item.bookTitle,
                                      bookCoverPath: item.bookCoverPath,
                                      bookAuthor: item.bookAuthor,
                                      bookPublisher: item.bookPublisher,
                                      bookPublishYear: item.bookPublishYear,
                                      imageWidth: 60.0,
                                      imageHeight: 70.0,
                                      isLikeList: true,
                                    );
                                  },
                                  separatorBuilder: (_, index) {
                                    return const SizedBox(height: 8.0);
                                  },
                                  itemCount: sbp.likeBookList.length),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
