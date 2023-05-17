import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/opacity_loading.dart';
import 'package:dokki/data/model/review/review_model.dart';
import 'package:dokki/providers/review_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:dokki/view/book_detail/widget/review_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewListPage extends StatefulWidget {
  final String bookId;
  final String loginUserId;
  const ReviewListPage(
      {Key? key, required this.bookId, required this.loginUserId})
      : super(key: key);

  @override
  State<ReviewListPage> createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  int currentPage = 0;
  double _dragDistance = 0;
  scrollNotification(notification, rp) {
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
          if (rp.pageData["numberOfElements"] < 10) {
            Utils.flushBarErrorMessage("마지막입니다.", context);
            return;
          }
          currentPage += 1;
          rp.getCommentListOfBook(widget.bookId, currentPage.toString());
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<ReviewProvider>().initProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    context
        .read<ReviewProvider>()
        .getCommentListOfBook(widget.bookId, currentPage.toString());
  }

  @override
  Widget build(BuildContext context) {
    final rp = Provider.of<ReviewProvider>(context, listen: true);
    print(rp.reviewList.length);
    return Scaffold(
      backgroundColor: brandColor100,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "전체 리뷰",
          style: TextStyle(
            color: grayColor600,
          ),
        ),
        backgroundColor: brandColor100,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: grayColor600,
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: Utils.getAndroidCommonPadding(),
            child: rp.reviewList.isNotEmpty
                ? NotificationListener(
                    onNotification: (ScrollNotification notification) {
                      scrollNotification(notification, rp);
                      return false;
                    },
                    child: ListView.separated(
                      itemCount: rp.reviewList.length,
                      itemBuilder: (context, index) {
                        return ReviewItem(
                          bookId: widget.bookId,
                          loginUserId: widget.loginUserId,
                          commentId: rp.reviewList[index].commentId,
                          userId: rp.reviewList[index].userId,
                          profileImagePath:
                              rp.reviewList[index].profileImagePath,
                          nickname: rp.reviewList[index].nickname,
                          content: rp.reviewList[index].content,
                          score: rp.reviewList[index].score,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                    ),
                  )
                : Center(
                    child: Text("리뷰가 없습니다."),
                  ),
          ),
          if (rp.isListLoading) const OpacityLoading()
        ],
      ),
    );
  }
}
