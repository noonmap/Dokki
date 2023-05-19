import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/page/animate_book_page.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:dokki/providers/diary_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:dokki/view/diary/widget/diary_item.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({
    super.key,
  });

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  int page = 0;
  double _dragDistance = 0;
  bool isGrid = true;

  scrollNotification(notification, DiaryProvider dp) {
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
          if (dp.pageData["numberOfElements"] < 10) {
            Utils.flushBarErrorMessage("마지막입니다.", context);
            return;
          }
          page += 1;
          dp.getDiaries(page: page);
        }
      }
    }
  }

  @override
  void initState() {
    final dp = Provider.of<DiaryProvider>(context, listen: false);
    dp.diarysInitProvider();
    dp.initProvider();
    dp.getDiaries(page: page);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dp = Provider.of<DiaryProvider>(context);
    return Scaffold(
      backgroundColor: brandColor000,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: brandColor000,
        foregroundColor: grayColor600,
        centerTitle: true,
        title: const Paragraph(
          text: '감정 일기 스크랩 북',
          size: 18,
          weightType: WeightType.medium,
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
            icon: !isGrid
                ? const Icon(Ionicons.grid)
                : const Icon(Ionicons.color_wand_outline),
          ),
        ],
      ),
      body: dp.isLoading
          ? null
          : Padding(
              padding: isGrid
                  ? const EdgeInsets.fromLTRB(28, 20, 28, 20)
                  : const EdgeInsets.all(0),
              child: Column(
                children: [
                  Expanded(
                    // 작성된 감정 일기가 없을 때
                    child: dp.diaries.isEmpty
                        ? const Center(
                            child: Paragraph(
                              text: '작성된 감정 일기가 없습니다.',
                              color: grayColor300,
                            ),
                          )
                        // 작성된 감정 일기가 있을 때
                        : isGrid
                            ? NotificationListener(
                                onNotification:
                                    (ScrollNotification notification) {
                                  scrollNotification(notification, dp);
                                  return false;
                                },
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 40,
                                    crossAxisSpacing: 20,
                                    childAspectRatio: 0.65,
                                  ),
                                  itemBuilder: (context, idx) {
                                    return DiaryItem(
                                        diaryData: dp.diaries[idx]);
                                  },
                                  itemCount: dp.diaries.length,
                                ),
                              )
                            : AnimateBookPage(
                                libraryBooks: const [],
                                diarys: dp.diaries,
                                isDiary: true,
                              ),
                  )
                ],
              ),
            ),
    );
  }
}
