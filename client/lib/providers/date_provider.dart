import 'package:flutter/material.dart';

class DateProvider extends ChangeNotifier {
  DateTime _start = DateTime.now().subtract(const Duration(days: 1));
  DateTime _end = DateTime.now();

  DateTime get start => _start;
  DateTime get end => _end;

  void changeStartDate(DateTime newDate) {
    _start = newDate;
    notifyListeners();
  }

  void changeEndDate(DateTime newDate) {
    _end = newDate;
    notifyListeners();
  }

  void initDateProvider() {
    _start = DateTime.now().subtract(const Duration(days: 1));
    _end = DateTime.now();
  }
}
