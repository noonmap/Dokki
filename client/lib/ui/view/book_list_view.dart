import 'package:dokki/constants/colors.dart';
import 'package:dokki/ui/view_model/book_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class BookListView extends StatefulWidget {
  const BookListView({Key? key}) : super(key: key);

  @override
  State<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<BookListViewModel>(context);
    print(mp.isLoading);
    // loading 중 아니고 비어있는 경우
    return mp.isLoading
        ? getLoadingUI()
        : Container(
            padding: const EdgeInsets.all(20),
            child: ListView.separated(
              itemCount: mp.bookList.content.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print("상세 페이지 이동");
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: whiteColor100,
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: Image.network(
                            mp.bookList.content[index].bookCoverPath,
                            width: 80,
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mp.bookList.content[index].bookTitle,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                                style: const TextStyle(
                                  color: grayColor500,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                mp.bookList.content[index].bookAuthor,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                                style: const TextStyle(
                                  color: grayColor300,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "${mp.bookList.content[index].bookPublisher} • ${mp.bookList.content[index].bookPublishYear}",
                                style: const TextStyle(
                                  color: grayColor300,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  print("추가");
                                },
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: Icon(
                                        Icons.add_circle_outline,
                                        color: brandColor400,
                                        size: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "추가",
                                      style: TextStyle(
                                          color: brandColor400,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 5,
                );
              },
            ),
          );
  }
}

// 검색 중인 UI
Widget getLoadingUI() {
  return const Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SpinKitSpinningCircle(
        color: whiteColor400,
        size: 50,
      ),
      Text("Loading..."),
    ],
  ));
}

// 검색 결과 있는 경우의 UI
// Widget getHasDataUI(){
//
// }
//
// // 검색 결과 없는 경우의 UI
// Widget getNoDataUI(){
//
// }
