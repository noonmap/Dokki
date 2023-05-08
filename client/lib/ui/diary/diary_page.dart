import 'package:dokki/constants/colors.dart';
import 'package:dokki/providers/diary_provider.dart';
import 'package:dokki/ui/common_widgets/opacity_loading.dart';
import 'package:dokki/ui/common_widgets/paragraph.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
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

  // 🍇 임시 데이터
  Map<String, dynamic> tmpData = {
    'bookId': '1',
    'bookTitle': '엄청나게 긴 제목으로 테스트를 해야 합니다 더 길어야 해요',
    'diaryId': 1,
    'diaryImagePath':
        'https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2022/09/18/1e586277-48ba-4e8a-9b98-d8cdbe075d86.jpg',
    'diaryContent': '예쁜 카리나',
    'created': '2023-05-09',
  };

  scrollNotification(notification, dp) {
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
          dp.getDiarys(page: page);
        }
      }
    }
  }

  @override
  void initState() {
    final dp = Provider.of<DiaryProvider>(context, listen: false);
    dp.initProvider();
    dp.getDiarys(page: page);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dp = Provider.of<DiaryProvider>(context);

    return Scaffold(
      body: dp.isLoading
          ? const OpacityLoading()
          : Padding(
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                      ),
                      Paragraph(
                        text: '감정 일기',
                        size: 18,
                        weightType: WeightType.medium,
                      ),
                      SizedBox(
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
                          return DiaryItem(tmpData: tmpData);
                        },
                        itemCount: 1,
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

class DiaryItem extends StatelessWidget {
  const DiaryItem({
    super.key,
    required this.tmpData,
  });

  final Map<String, dynamic> tmpData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.diaryDetail,
            arguments: {"diaryId": tmpData['diaryId']});
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(color: grayColor100),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Hero(
              tag: tmpData['diaryId'],
              child: Image.network(
                tmpData['diaryImagePath'],
                width: 168,
                height: 168,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Paragraph(
                        text: tmpData['created'],
                        size: 12,
                        color: grayColor300,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Paragraph(
                    text: tmpData['bookTitle'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
