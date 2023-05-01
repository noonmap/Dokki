import 'package:dokki/constants/colors.dart';
import 'package:dokki/ui/common_widgets/thumb_image.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class BookListItem extends StatelessWidget {
  final String bookId;
  final String bookTitle;
  final String bookCoverPath;
  final String bookAuthor;
  final String bookPublisher;
  final String bookPublishYear;

  const BookListItem(
      {super.key,
      required this.bookId,
      required this.bookTitle,
      required this.bookCoverPath,
      required this.bookAuthor,
      required this.bookPublisher,
      required this.bookPublishYear});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.bookDetail,
            arguments: {"bookId": bookId});
      },
      child: Container(
        decoration: const BoxDecoration(
          color: grayColor000,
        ),
        child: Row(
          children: [
            Flexible(
              child: ThumbImage(
                  thumbImagePath: bookCoverPath, width: 80, height: 100),
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
                    bookTitle,
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
                    bookAuthor,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(
                      color: grayColor300,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "$bookPublisher • $bookPublishYear",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
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
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            color: brandColor300,
                                          ),
                                          width: 90,
                                          height: 70,
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Ionicons.heart_sharp,
                                              color: grayColor000,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            color: grayColor400,
                                          ),
                                          width: 90,
                                          height: 70,
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            color: grayColor400,
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
                                        shape: const RoundedRectangleBorder(
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
