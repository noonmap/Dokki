import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/opacity_loading.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:dokki/providers/user_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:dokki/view/book_search/widget/book_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistPage extends StatefulWidget {
  final String loginUserId;
  const WishlistPage({
    super.key,
    required this.loginUserId,
  });

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  int page = 0;
  double _dragDistance = 0;

  scrollNotification(notification, up) {
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
          if (up.pageData["numberOfElements"] < 10) {
            Utils.flushBarErrorMessage("마지막입니다.", context);
            return;
          }
          page += 1;
          up.getWishlist(page: page);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final up = Provider.of<UserProvider>(context, listen: false);
    up.initProvider();
    up.getWishlist(page: page);
  }

  @override
  Widget build(BuildContext context) {
    final up = Provider.of<UserProvider>(context);

    return Scaffold(
      body: up.wishlistLoading
          ? const OpacityLoading()
          : Padding(
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
              child: Column(
                children: [
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
                      const Paragraph(
                        text: '찜한 책',
                        size: 18,
                        weightType: WeightType.medium,
                      ),
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: up.wishlistBooks.isNotEmpty
                            ? const Icon(
                                Icons.menu,
                                size: 32,
                                color: brandColor300,
                              )
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    // 찜한 책이 없을 때
                    child: up.wishlistBooks.isEmpty
                        ? const Center(
                            child: Paragraph(
                              text: '찜한 책이 없습니다.',
                              color: grayColor300,
                            ),
                          )
                        // 찜한 책이 있을 때
                        : NotificationListener(
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return BookListItem(
                                    loginUserId: widget.loginUserId,
                                    bookId: up.wishlistBooks[index].bookId,
                                    bookTitle:
                                        up.wishlistBooks[index].bookTitle,
                                    bookCoverPath:
                                        up.wishlistBooks[index].bookCoverPath,
                                    bookAuthor:
                                        up.wishlistBooks[index].bookAuthor,
                                    bookPublisher:
                                        up.wishlistBooks[index].bookPublisher,
                                    bookPublishYear:
                                        up.wishlistBooks[index].bookPublishYear,
                                    imageHeight: 100.0,
                                    imageWidth: 80.0,
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                                itemCount: up.wishlistBooks.length),
                          ),
                  )
                ],
              ),
            ),
    );
  }
}
