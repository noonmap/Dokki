import 'package:dokki/constants/colors.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class BookListItem extends StatelessWidget {
  const BookListItem({
    super.key,
    required this.bp,
    required this.index,
  });

  final BookProvider bp;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.bookDetail,
            arguments: {"bookId": bp.bookList[index].bookId});
      },
      child: Container(
        decoration: const BoxDecoration(
          color: whiteColor100,
        ),
        child: Row(
          children: [
            Flexible(
              child: Image.network(
                bp.bookList[index].bookCoverPath,
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
                    bp.bookList[index].bookTitle,
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
                    bp.bookList[index].bookAuthor,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(
                      color: grayColor300,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "${bp.bookList[index].bookPublisher} • ${bp.bookList[index].bookPublishYear}",
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
                      showModalBottomSheet<void>(
                        context: context,
                        isDismissible: false,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Container(
                            height: 280,
                            color: brandColor000,
                            child: Stack(children: [
                              Container(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Ionicons.close_outline),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 40, 20, 0),
                                child: Column(
                                  children: [
                                    const Text(
                                      "책 추가하기",
                                      style: TextStyle(
                                          color: grayColor500,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            color: brandColor300,
                                          ),
                                          width: 90,
                                          height: 70,
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Ionicons.heart_sharp,
                                              color: whiteColor100,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            color: whiteColor300,
                                          ),
                                          width: 90,
                                          height: 70,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            color: whiteColor300,
                                          ),
                                          width: 90,
                                          height: 70,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 55,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        backgroundColor: brandColor300,
                                        minimumSize: const Size.fromHeight(50),
                                      ),
                                      child: const Text("저장"),
                                    )
                                  ],
                                ),
                              ),
                            ]),
                          );
                        },
                      );
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
  }
}
