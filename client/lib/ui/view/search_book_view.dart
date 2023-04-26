import 'package:dokki/api/response/status.dart';
import 'package:dokki/constants/colors.dart';
import 'package:dokki/ui/view_model/search_book_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBookView extends StatefulWidget {
  const SearchBookView({Key? key}) : super(key: key);

  @override
  State<SearchBookView> createState() => _SearchBookViewState();
}

class _SearchBookViewState extends State<SearchBookView> {
  @override
  void initState() {
    super.initState();
    final mp = Provider.of<SearchBookViewModel>(context, listen: false);
    mp.fetchSearchBookListApi("프로그래머", "Keyword", 0, 10);
  }

  @override
  void dispose() {
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<SearchBookViewModel>(context);

    return mp.bookList.status == Status.LOADING
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            padding: const EdgeInsets.all(20),
            child: ListView.separated(
              itemCount: mp.bookList.data!.content!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print("상세 페이지 이동");
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: const BoxDecoration(
                      color: whiteColor100,
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: Image.network(
                            mp.bookList.data!.content![index].bookCoverPath!,
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
                                mp.bookList.data!.content![index].bookTitle!,
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
                                mp.bookList.data!.content![index].bookAuthor!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                                style: const TextStyle(
                                  color: grayColor300,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "${mp.bookList.data!.content![index].bookPublisher!} • ${mp.bookList.data!.content![index].bookPublishYear}",
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
