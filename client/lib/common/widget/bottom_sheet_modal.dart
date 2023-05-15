import 'package:dio/dio.dart';
import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/providers/date_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      height: _selectedIndex == 0 ? 112 : 233,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
            SizedBox(height: _selectedIndex == 0 ? 6 : 12),
            _selectedIndex == 1
                ? Text("독서 기간",
                    style: TextStyle(
                      fontSize: 13,
                      color: grayColor600,
                      fontWeight: FontWeight.w600,
                    ))
                : SizedBox(),
            _selectedIndex == 1 ? OpenDateButton(isStart: true) : SizedBox(),
            _selectedIndex == 1 ? OpenDateButton(isStart: false) : SizedBox(),
            const SizedBox(
              height: 6,
            ),
            Center(
              child: TextButton(
                onPressed: () async {
                  if (_selectedIndex == 0) {
                    final response =
                        await bp.addReadingBook({"bookId": widget.bookId});
                    Navigator.pop(context);
                    await bp.getBookById(widget.bookId);
                    if (response.statusCode == 200) {
                      Utils.flushBarSuccessMessage(bp.success, context);
                    } else {
                      Utils.flushBarErrorMessage(bp.error, context);
                    }
                  } else {
                    try {
                      final response = await bp.addDirectCompleteBook({
                        "bookId": widget.bookId,
                        "startTime": DateFormat('yyyy-MM-dd')
                            .format(context.read<DateProvider>().start),
                        "endTime": DateFormat('yyyy-MM-dd')
                            .format(context.read<DateProvider>().end),
                      });
                      Navigator.pop(context);
                      await bp.getBookById(widget.bookId);
                      Utils.flushBarSuccessMessage(bp.success, context);
                    } on DioError catch (error) {
                      Navigator.pop(context);
                      Utils.flushBarErrorMessage(bp.error, context);
                    }
                  }
                },
                child: Text(
                  "저장",
                  style: const TextStyle(color: brandColor300, fontSize: 14),
                ),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OpenDateButton extends StatefulWidget {
  final bool isStart;
  const OpenDateButton({
    super.key,
    required this.isStart,
  });

  @override
  State<OpenDateButton> createState() => _OpenDateButtonState();
}

class _OpenDateButtonState extends State<OpenDateButton> {
  DateTime datetime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    dynamic start = context.watch<DateProvider>().start;
    dynamic end = context.watch<DateProvider>().end;
    return ElevatedButton(
      onPressed: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: widget.isStart ? start : end,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (widget.isStart) {
          context.read<DateProvider>().changeStartDate(selectedDate!);
        } else {
          context.read<DateProvider>().changeEndDate(selectedDate!);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_month,
                color: grayColor600,
              ),
              const SizedBox(width: 6),
              Text(
                widget.isStart ? "시작일" : "종료일",
                style: TextStyle(
                  color: grayColor600,
                ),
              ),
            ],
          ),
          Text(
            widget.isStart
                ? "${start.year} - ${start.month} - ${start.day}"
                : "${end.year} - ${end.month} - ${end.day}",
            style: TextStyle(
              color: grayColor600,
            ),
          ),
        ],
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return brandColor000;
        } else {
          return brandColor000;
        }
      })),
    );
  }
}
