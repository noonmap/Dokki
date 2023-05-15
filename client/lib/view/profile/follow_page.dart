import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:dokki/providers/user_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:dokki/view/profile/widget/follow_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({
    super.key,
    required this.userId,
    required this.category,
  });

  final String userId, category;

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
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
          up.getFollowList(
              userId: widget.userId, category: widget.category, page: page);
        }
      }
    }
  }

  @override
  void initState() {
    final up = Provider.of<UserProvider>(context, listen: false);
    up.initProvider();
    up.getFollowList(
        userId: widget.userId, category: widget.category, page: page);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final up = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
        child: Column(
          children: [
            // 상단 메뉴바
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
                Paragraph(
                  text: widget.category == 'following' ? '팔로잉' : '팔로워',
                  size: 18,
                  weightType: WeightType.medium,
                ),
                const SizedBox(
                  width: 32,
                  height: 32,
                ),
              ],
            ),
            const SizedBox(height: 40),
            if (up.followList.isEmpty)
              const Center(
                child: Paragraph(
                  text: '유저가 없습니다.',
                  color: grayColor300,
                ),
              )
            else
              Expanded(
                child: NotificationListener(
                  onNotification: (ScrollNotification notification) {
                    scrollNotification(notification, up);
                    return false;
                  },
                  child: ListView.separated(
                      itemBuilder: (context, idx) {
                        return FollowListItem(user: up.followList[idx]);
                      },
                      separatorBuilder: (context, idx) {
                        return Column(
                          children: [
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: grayColor100,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      },
                      itemCount: up.followList.length),
                ),
              )
          ],
        ),
      ),
    );
  }
}
