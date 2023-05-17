import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:dokki/providers/user_provider.dart';
import 'package:flutter/material.dart';

class UserMonthCalendar extends StatefulWidget {
  const UserMonthCalendar({
    super.key,
    required this.up,
    required this.userId,
    required this.year,
    required this.month,
  });

  final UserProvider up;
  final String userId;
  final int year, month;

  @override
  State<UserMonthCalendar> createState() => _UserMonthCalendarState();
}

class _UserMonthCalendarState extends State<UserMonthCalendar> {
  late int _year, _month;
  List<String> week = ['일', '월', '화', '수', '목', '금', '토'];
  List<dynamic> days = [];

  void insertDays(year, month) {
    days.clear();

    // 이번 달의 마지막 날을 구한 다음, days에 1일~마지막 날 추가
    int lastDay = DateTime(year, month + 1, 0).day;
    for (var i = 1; i <= lastDay; i++) {
      days.add({
        'day': i,
        'inMonth': true,
        'read': false,
        'bookCoverPath': null,
      });
    }

    var data = widget.up.userMonthlyCalendar;
    for (var i = 0; i < data.length; i++) {
      days[data[i].day - 1]['read'] = true;
      days[data[i].day - 1]['bookCoverPath'] = data[i].bookCoverPath;
    }

    // 이번 달 1일의 요일(firstWeekday)가 7(일요일)이 아니면
    // 비어 있는 요일만큼 지난 달 채우기
    int firstWeekday = DateTime(year, month, 1).weekday;
    if (firstWeekday != 7) {
      var tmp = [];
      for (var i = firstWeekday - 1; i >= 0; i--) {
        tmp.add({
          'day': 0,
          'inMonth': false,
          'read': false,
          'bookCoverPath': null,
        });
      }
      days = [...tmp, ...days];
    }
  }

  void makeCalendar(year, month) async {
    await widget.up.getUserMonthlyCalendar(
        userId: widget.userId, year: year, month: month);
    insertDays(year, month);
  }

  @override
  void didUpdateWidget(covariant UserMonthCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.year != widget.year || oldWidget.month != widget.month) {
      _year = widget.year;
      _month = widget.month;
      makeCalendar(_year, _month);
    }
  }

  @override
  void initState() {
    super.initState();
    insertDays(widget.year, widget.month);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double containerWidth = constraints.maxWidth / 7;
      double containerHeight = containerWidth * 10 / 7;
      return Column(
        children: [
          // 요일
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < 7; i++)
                Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: grayColor200))),
                  width: containerWidth,
                  child: Center(
                    child: Paragraph(
                      text: week[i],
                      size: 12,
                      color: grayColor300,
                    ),
                  ),
                )
            ],
          ),
          // 날짜
          Wrap(
            children: [
              for (var i = 0; i < days.length; i++)
                Container(
                  width: containerWidth,
                  height: containerHeight,
                  alignment: Alignment.topCenter,
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: grayColor200))),
                  child: days[i]['read']
                      ? Image.network(
                          days[i]['bookCoverPath'],
                          width: 42,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : days[i]['inMonth']
                          ? Paragraph(
                              text: days[i]['day'].toString(),
                              size: 12,
                              color: grayColor300)
                          : null,
                )
            ],
          ),
        ],
      );
    });
  }
}
