import 'dart:math';

import 'package:dokki/constants/colors.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/ui/book_detail/widgets/book_item.dart';
import "package:flutter/foundation.dart" as foundation;
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late double _sry;
  double _ry = 0.0;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final bp = Provider.of<BookProvider>(context, listen: false);
      Map<String, dynamic> arg =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

      bp.getBookById(arg["bookId"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bp = Provider.of<BookProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: brandColor100,
        actions: <Widget>[
          TextButton(
            onPressed: () {},
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
      body: bp.isLoading || bp.book == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: brandColor000,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        )),
                        padding: const EdgeInsets.fromLTRB(35, 40, 35, 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onHorizontalDragStart: (e) {
                                setState(() {
                                  _sry = e.localPosition.dx;
                                });
                              },
                              onHorizontalDragUpdate: (e) {
                                setState(() {
                                  _ry =
                                      (e.localPosition.dx - _sry) * -0.0174533;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration:
                                    const BoxDecoration(color: brandColor000),
                                child: BookItem(
                                    imagePath: bp.book!.bookCoverPath,
                                    backImagePath:
                                        bp.book!.bookCoverBackImagePath,
                                    sideImagePath:
                                        bp.book!.bookCoverSideImagePath,
                                    width: 240,
                                    height: 300,
                                    rotateY: _ry,
                                    depth: (bp.book!.bookTotalPage / 6 > 100
                                            ? 100
                                            : bp.book!.bookTotalPage / 6)
                                        .toDouble()),
                              ),
                            ),
                            const SizedBox(
                              height: 65,
                            ),
                            Text(
                              bp.book!.bookTitle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: false,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bp.book!.bookAuthor,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: grayColor400,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        "${bp.book!.bookPublisher} • ${bp.book!.bookPublishYear} • ${bp.book!.bookTotalPage}P",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: grayColor400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            StatisticInfo(
                              title: "읽은 사람",
                              value: "${bp.book!.readerCount}명",
                              iconData: Ionicons.people_sharp,
                            ),
                            const SizedBox(height: 15),
                            StatisticInfo(
                              title: "평균 별점",
                              value: "${bp.book!.meanScore}점",
                              iconData: Ionicons.star_sharp,
                            ),
                            const SizedBox(height: 15),
                            StatisticInfo(
                              title: "평균 독서 시간",
                              value: "${bp.book!.meanReadTime}시간",
                              iconData: Ionicons.time_sharp,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
              color: brandColor100,
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
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 8,
      ),
      decoration: const BoxDecoration(
          color: brandColor100,
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            icon,
            size: 18,
            color: brandColor300,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
