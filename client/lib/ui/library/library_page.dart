import 'package:dokki/constants/colors.dart';
import 'package:dokki/providers/library_provider.dart';
import 'package:dokki/ui/common_widgets/opacity_loading.dart';
import 'package:dokki/ui/common_widgets/paragraph.dart';
import 'package:dokki/ui/library/widgets/library_book_item.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatefulWidget {
  final String userId;

  const LibraryPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  String username = '';
  String myId = '';
  bool isMine = false;

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
    String? tmpName = await storage.read(key: "username");
    String? tmpId = await storage.read(key: 'userId');

    if (tmpName != null && tmpId != null) {
      setState(() {
        username = tmpName;
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
      body: lp.isLoading
          ? const OpacityLoading()
          : Padding(
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 32,
                        height: 32,
                      ),
                      Row(
                        children: [
                          Paragraph(
                            text: username,
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
                      if (isMine)
                        const SizedBox(
                          width: 32,
                          height: 32,
                          child: Icon(
                            Icons.menu,
                            size: 32,
                            color: brandColor300,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: NotificationListener(
                      onNotification: (ScrollNotification notification) {
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
                              libraryBooks: lp.libraryBooks, idx: idx);
                        },
                        itemCount: lp.libraryBooks.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
