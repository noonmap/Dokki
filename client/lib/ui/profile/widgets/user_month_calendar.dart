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
  final int userId, year, month;

  @override
  State<UserMonthCalendar> createState() => _UserMonthCalendarState();
}

class _UserMonthCalendarState extends State<UserMonthCalendar> {
  late int _year, _month;

  @override
  void initState() {
    super.initState();
    _year = widget.year;
    _month = widget.month;
    widget.up.getUserMonthlyCalendar(
        userId: widget.userId, year: _year, month: _month);
  }

  @override
  void didUpdateWidget(covariant UserMonthCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.year != widget.year || oldWidget.month != widget.month) {
      _year = widget.year;
      _month = widget.month;
      widget.up.getUserMonthlyCalendar(
          userId: widget.userId, year: _year, month: _month);
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = DateTime(_year, _month, 0).day;
    return const Text('...');
  }
}
