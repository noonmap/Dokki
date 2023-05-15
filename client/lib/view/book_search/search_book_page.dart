import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/opacity_loading.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:dokki/view/book_search/widget/book_list_item.dart';
import 'package:dokki/view/book_search/widget/no_search_result_ui.dart';
import "package:flutter/foundation.dart" as foundation;
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class SearchBookPage extends StatefulWidget {
  final String userId;
  const SearchBookPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<SearchBookPage> createState() => _SearchBookPageState();
}

class _SearchBookPageState extends State<SearchBookPage> {
  final fieldText = TextEditingController();
  String searchValue = "";
  int page = 1;

  // Drag 거리를 체크
  // 해당 값을 평균 내서 50%이상 움직였을 때 데이터 불러오기
  double _dragDistance = 0;
  void clearText() {
    searchValue = "";
    fieldText.clear();
  }

  @override
  void initState() {
    super.initState();
    final bp = Provider.of<BookProvider>(context, listen: false);
    bp.initProvider();
  }

  scrollNotification(notification, bp) {
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
          if (bp.pageData["numberOfElements"] < 10) {
            Utils.flushBarErrorMessage("마지막 페이지 입니다.", context);
            return;
          }
          page += 1;
          bp.getBookListSearch(searchValue, "Keyword", page.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bp = Provider.of<BookProvider>(context, listen: true);
    return Stack(
      children: [
        Container(
          padding:
              foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS
                  ? Utils.getIosCommonPadding()
                  : Utils.getAndroidCommonPadding(),
          child: Column(
            children: [
              TextField(
                textInputAction: TextInputAction.go,
                onSubmitted: (_) {
                  setState(() {
                    page = 1;
                  });
                  bp.initProvider();
                  if (searchValue != "") {
                    bp.getBookListSearch(
                        searchValue, "Keyword", page.toString());

                    print(bp.pageData);
                  } else {
                    Utils.flushBarErrorMessage("키워드를 입력해주세요.", context);
                  }
                },
                onChanged: (value) {
                  searchValue = value;
                },
                controller: fieldText,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: grayColor100,
                  prefixIconColor: grayColor300,
                  suffixIconColor: grayColor300,
                  hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: grayColor300),
                  prefixIcon: const Icon(Ionicons.search_sharp, size: 25),
                  suffixIcon: IconButton(
                    icon: const Icon(Ionicons.close_outline),
                    onPressed: clearText,
                  ),
                  hintText: "책 제목 또는 저자명을 입력하세요.",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                  child: bp.bookList.isNotEmpty
                      ? NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification notification) {
                            scrollNotification(notification, bp);
                            return false;
                          },
                          child: ListView.separated(
                            itemCount: bp.bookList.length,
                            itemBuilder: (context, index) {
                              return BookListItem(
                                loginUserId: widget.userId,
                                bookId: bp.bookList[index].bookId,
                                bookTitle: bp.bookList[index].bookTitle,
                                bookCoverPath: bp.bookList[index].bookCoverPath,
                                bookAuthor: bp.bookList[index].bookAuthor,
                                bookPublisher: bp.bookList[index].bookPublisher,
                                bookPublishYear:
                                    bp.bookList[index].bookPublishYear,
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
                          ),
                        )
                      : bp.pageData.isEmpty
                          ? const Center(
                              child: Text("검색 키워드를 입력해주세요.",
                                  style: TextStyle(color: grayColor500)),
                            )
                          : const NoSearchResultUI())
            ],
          ),
        ),
        if (bp.isListLoading) const OpacityLoading()
      ],
    );
  }
}
