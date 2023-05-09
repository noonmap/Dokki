import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class BottomSheetModal extends StatefulWidget {
  final String? bookId;
  const BottomSheetModal({
    super.key,
    this.bookId,
  });

  @override
  State<BottomSheetModal> createState() => _BottomSheetModalState();
}

class _BottomSheetModalState extends State<BottomSheetModal> {
  int selectedIndex = 0;

  void showMessage(BookProvider bp, BuildContext context) {
    if (bp.errorMessage != "") {
      Navigator.pop(context);
      Utils.flushBarErrorMessage(bp.errorMessage, context);
      bp.errorMessage = "";
    }
    if (bp.successMessage != "") {
      Navigator.pop(context);
      Utils.flushBarSuccessMessage(bp.successMessage, context);
      bp.successMessage = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final bp = Provider.of<BookProvider>(context, listen: false);

    return SizedBox(
      height: 280,
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
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    child: AbsorbPointer(
                      child: BookAddButton(
                          iconData: Ionicons.heart_sharp,
                          text: "읽고 싶은 책",
                          selected: selectedIndex == 0),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    child: AbsorbPointer(
                      child: BookAddButton(
                          iconData: Ionicons.bookmark_sharp,
                          text: "읽는 중인 책",
                          selected: selectedIndex == 1),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                    child: AbsorbPointer(
                      child: BookAddButton(
                          iconData: Ionicons.golf_sharp,
                          text: "완독",
                          selected: selectedIndex == 2),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedIndex == 0) {
                    // 찜 목록 추가
                    await bp.addLikeBook(widget.bookId!);
                    showMessage(bp, context);
                  } else if (selectedIndex == 1) {
                    // 읽는 중인 책에 추가 (타이머에 추가)
                  } else {
                    // 완독에 추가
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  backgroundColor: brandColor300,
                ),
                child: const Text(
                  "저장",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}

class BookAddButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final bool selected;
  const BookAddButton({
    super.key,
    required this.iconData,
    required this.text,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              iconData,
              size: selected ? 36 : 30,
              color: selected ? brandColor300 : grayColor400,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: selected
              ? const TextStyle(fontSize: 15, color: brandColor300)
              : const TextStyle(fontSize: 14, color: grayColor400),
        ),
      ],
    );
  }
}
