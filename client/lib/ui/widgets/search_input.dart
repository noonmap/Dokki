import 'package:dokki/constants/colors.dart';
import 'package:dokki/ui/view_model/book_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({Key? key}) : super(key: key);

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  String value = "";

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<BookListViewModel>(context, listen: true);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: TextField(
        textInputAction: TextInputAction.go,
        onSubmitted: (_) {
          mp.fetchSearchBookListApi(value, "Keyword", 0, 50);
        },
        onChanged: (text) {
          setState(() {
            value = text;
          });
        },
        decoration: const InputDecoration(
            filled: true,
            fillColor: grayColor100,
            hintStyle: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: grayColor300),
            icon: Icon(Ionicons.search_sharp, size: 20),
            hintText: "책 제목 또는 저자명을 입력하세요.",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ))),
      ),
    );
  }
}
