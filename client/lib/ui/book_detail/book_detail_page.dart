import 'package:dokki/constants/colors.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/ui/book_detail/widgets/book_item.dart';
import 'package:flutter/material.dart';
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
    print(bp.book!.bookCoverPath);
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
                          color: brandColor100,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(18),
                            bottomRight: Radius.circular(18),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(35, 10, 35, 10),
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
                                    const BoxDecoration(color: brandColor100),
                                child: BookItem(
                                    imagePath: bp.book!.bookCoverPath,
                                    backImagePath:
                                        bp.book!.bookCoverBackImagePath,
                                    sideImagePath:
                                        bp.book!.bookCoverSideImagePath,
                                    width: 200,
                                    height: 240,
                                    rotateY: _ry,
                                    depth: (bp.book!.bookTotalPage / 6 > 100
                                            ? 100
                                            : bp.book!.bookTotalPage / 6)
                                        .toDouble()),
                              ),
                            ),
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
                                    icon: Icons.people_outline, text: "1121"),
                                SizedBox(width: 10),
                                MoreInfo(
                                    icon: Icons.av_timer_sharp, text: "4.8h"),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
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
