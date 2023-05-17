import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/page/animate_book_page.dart';
import 'package:dokki/common/widget/opacity_loading.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:dokki/providers/library_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:dokki/view/library/widget/library_book_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatefulWidget {
  final String userId;
  final String nickname;

  const LibraryPage({
    Key? key,
    required this.userId,
    required this.nickname,
  }) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  String myId = '';
  bool isMine = false;
  bool isGrid = true;

  int page = 0;
  double _dragDistance = 0;

  scrollNotification(notification, lp) {
    // 스크롤 최대 범위
    var containerExtent = notification.metrics.viewportDimension;

    if (notification is ScrollStartNotification) {
      // 스크롤 시작하면 발생 (손가락으로 리스트 누르고 움직이려고 할때)
      // 스크롤 거리값을 0으로 초기화
      _dragDistance = 0;
    } else if (notification is OverscrollNotification) {
      // 안드로이드 에서 동작
      // 스크롤 시작후 움직일때 발생(손가락으로 리스트를 누르고 움직이고 있을 때 계속 발생)
      // 스크롤 움직인 만큼 빼준다. (notification.overscroll);
      _dragDistance -= notification.overscroll;
    } else if (notification is ScrollUpdateNotification) {
      // ios에서 동작
      // 스크롤 시작후 움직일 때 발생
      // 스크롤 움직인 만큼 빼준다. (notification.scrollDelta)
      _dragDistance -= notification.scrollDelta!;
    } else if (notification is ScrollEndNotification) {
      // 스크롤 끝났을 때 발생

      // 지금까지 움직인 거리 최대 거리로 나눈다.
      var percent = _dragDistance / (containerExtent);
      // 해당 값이 -0.4(40프로 이상) 아래서 위로 움직였다면
      if (percent <= -0.4) {
        // maxScrollExtent 리스트 가장 아래 위치 값
        // pixels는 현재 위치 값
        // 두값이 같다면 (스크롤 가장 아래 위치)
        if (notification.metrics.maxScrollExtent ==
            notification.metrics.pixels) {
          if (lp.pageData["numberOfElements"] < 10) {
            Utils.flushBarErrorMessage("마지막입니다.", context);
            return;
          }
          page += 1;
          lp.getLibraryBooks(userId: widget.userId, page: page);
        }
      }
    }
  }

  void getUserInfoFromStorage() async {
    const storage = FlutterSecureStorage();
    String? tmpId = await storage.read(key: 'userId');

    if (tmpId != null) {
      setState(() {
        myId = tmpId;
        isMine = widget.userId == myId;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfoFromStorage();
    final lp = Provider.of<LibraryProvider>(context, listen: false);
    lp.initProvider();
    lp.getLibraryBooks(userId: widget.userId, page: page);
  }

  @override
  Widget build(BuildContext context) {
    final lp = Provider.of<LibraryProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: grayColor600,
        title: Column(
          children: [
            const SizedBox(height: 15),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Paragraph(
                  text: widget.nickname,
                  size: 18,
                  weightType: WeightType.semiBold,
                ),
                const Paragraph(
                  text: '님의 서재',
                  size: 18,
                  weightType: WeightType.medium,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
            icon: !isGrid
                ? Icon(Ionicons.grid)
                : Icon(Ionicons.color_wand_outline),
          ),
        ],
      ),
      body: lp.isLoading
          ? const OpacityLoading()
          : Padding(
              padding: isGrid
                  ? const EdgeInsets.fromLTRB(28, 20, 28, 20)
                  : const EdgeInsets.all(0),
              child: Column(
                children: [
                  Expanded(
                    child: lp.libraryBooks.isEmpty
                        ? const Center(
                            child: Paragraph(
                              text: '서재에 책이 없습니다.',
                              color: grayColor300,
                            ),
                          )
                        : isGrid
                            ? NotificationListener(
                                onNotification:
                                    (ScrollNotification notification) {
                                  scrollNotification(notification, lp);
                                  return false;
                                },
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 40,
                                    crossAxisSpacing: 20,
                                    childAspectRatio: 0.65,
                                  ),
                                  itemBuilder: (context, idx) {
                                    return LibraryBookItem(
                                        bookData: lp.libraryBooks[idx],
                                        loginUserId: widget.userId);
                                  },
                                  itemCount: lp.libraryBooks.length,
                                ),
                              )
                            : AnimateBookPage(
                                libraryBooks: lp.libraryBooks,
                                diarys: [],
                                isDiary: false,
                              ),
                  ),
                ],
              ),
            ),
    );
  }
}
