import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class BottomSheetModal extends StatefulWidget {
  final bool isState;
  final int currentState;
  final String bookId;
  const BottomSheetModal(
      {Key? key,
      required this.isState,
      required this.currentState,
      required this.bookId})
      : super(key: key);

  @override
  State<BottomSheetModal> createState() => _BottomSheetModalState();
}

class _BottomSheetModalState extends State<BottomSheetModal> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentState;
  }

  @override
  Widget build(BuildContext context) {
    final clientWidth = MediaQuery.of(context).size.width;
    final bp = Provider.of<BookProvider>(context);
    return Container(
      width: clientWidth,
      height: 128,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  child: Container(
                    width: (clientWidth - 40) / 2,
                    height: (80 - 32),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          bottomLeft: Radius.circular(16.0)),
                      color:
                          _selectedIndex == 0 ? brandColor300 : brandColor100,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book_sharp,
                          size: 20,
                          color: _selectedIndex == 0
                              ? brandColor000
                              : grayColor600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "읽는 중인 책",
                          style: TextStyle(
                            fontSize: 14,
                            color: _selectedIndex == 0
                                ? brandColor000
                                : grayColor600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                InkWell(
                  child: Container(
                    width: (clientWidth - 40) / 2,
                    height: (80 - 32),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0)),
                      color:
                          _selectedIndex == 1 ? brandColor300 : brandColor100,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Ionicons.golf_sharp,
                          size: 20,
                          color: _selectedIndex == 1
                              ? brandColor000
                              : grayColor600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "완독서",
                          style: TextStyle(
                            color: _selectedIndex == 1
                                ? brandColor000
                                : grayColor600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
              ],
            ),
            TextButton(
                onPressed: () {
                  if (_selectedIndex == 0) {
                    bp.addReadingBook({"bookId": widget.bookId}).then((value) {
                      Navigator.pop(context);
                    }).then((_) {
                      bp.getBookById(widget.bookId);
                    });
                  }
                },
                child: Text(
                  "저장",
                  style: TextStyle(color: brandColor300, fontSize: 14),
                )),
          ],
        ),
      ),
    );
  }
}
