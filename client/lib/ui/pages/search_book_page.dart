import 'package:dokki/constants/colors.dart';
import 'package:dokki/constants/image_strings.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class SearchBookPage extends StatefulWidget {
  const SearchBookPage({Key? key}) : super(key: key);

  @override
  State<SearchBookPage> createState() => _SearchBookPageState();
}

class _SearchBookPageState extends State<SearchBookPage> {
  final fieldText = TextEditingController();
  String searchValue = "";
  int page = 1;

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

  @override
  Widget build(BuildContext context) {
    final bp = Provider.of<BookProvider>(context, listen: true);
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Column(
            children: [
              TextField(
                textInputAction: TextInputAction.go,
                onSubmitted: (_) {
                  if (searchValue != "") {
                    bp.getBookListSearch(
                        searchValue, "Keyword", page.toString());
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
              Expanded(
                  child: bp.bookList.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.all(20),
                          child: ListView.separated(
                            itemCount: bp.bookList.length,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(30),
                                                      topRight:
                                                          Radius.circular(30),
                                                    ),
                                                  ),
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      height: 280,
                                                      color: brandColor000,
                                                      child: Stack(children: [
                                                        Container(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: IconButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            icon: const Icon(
                                                                Ionicons
                                                                    .close_outline),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  20,
                                                                  40,
                                                                  20,
                                                                  0),
                                                          child: Column(
                                                            children: [
                                                              const Text(
                                                                "책 추가하기",
                                                                style: TextStyle(
                                                                    color:
                                                                        grayColor500,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(8)),
                                                                      color:
                                                                          brandColor300,
                                                                    ),
                                                                    width: 90,
                                                                    height: 70,
                                                                    child:
                                                                        IconButton(
                                                                      onPressed:
                                                                          () {},
                                                                      icon:
                                                                          const Icon(
                                                                        Ionicons
                                                                            .heart_sharp,
                                                                        color:
                                                                            whiteColor100,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(8)),
                                                                      color:
                                                                          whiteColor300,
                                                                    ),
                                                                    width: 90,
                                                                    height: 70,
                                                                  ),
                                                                  Container(
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(8)),
                                                                      color:
                                                                          whiteColor300,
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
                                                                onPressed:
                                                                    () {},
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  shape: const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(20))),
                                                                  backgroundColor:
                                                                      brandColor300,
                                                                  minimumSize:
                                                                      const Size
                                                                          .fromHeight(50),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                        "저장"),
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
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
                                                        fontWeight:
                                                            FontWeight.w500),
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
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                height: 5,
                              );
                            },
                          ),
                        )
                      : bp.pageData.isEmpty
                          ? const Center(
                              child: Text("검색 키워드를 입력해주세요.",
                                  style: TextStyle(color: blackColor400)),
                            )
                          : const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage(tDokkiCharacter),
                                  width: 150,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("검색 결과가 없습니다.",
                                    style: TextStyle(color: blackColor400)),
                              ],
                            ))
            ],
          ),
        ),
        if (bp.isLoading)
          Opacity(
            opacity: 0.4,
            child: Container(
              alignment: Alignment.center,
              color: blackColor200,
              child: const SpinKitFadingFour(
                color: brandColor500,
                size: 50.0,
              ),
            ),
          )
      ],
    );
  }
}
