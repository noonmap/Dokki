import 'package:dokki/constants/colors.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/ui/book_search/widgets/book_list_item.dart';
import 'package:dokki/ui/book_search/widgets/no_search_result_ui.dart';
import 'package:dokki/ui/common_widgets/opacity_loading.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
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
                              return BookListItem(bp: bp, index: index);
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
                          : const NoSearchResultUI())
            ],
          ),
        ),
        if (bp.isLoading) const OpacityLoading()
      ],
    );
  }
}
