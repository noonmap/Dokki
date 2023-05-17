import 'dart:async';

import 'package:dokki/data/repository/timer_repository.dart';
import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  final TimerRepository _timerRepository = TimerRepository();
  Timer? _timer;
  int currentTime = 0;
  int tempTime = 0;
  bool timerPlaying = false;
  List<int> timerList = [];

  void start(int bookStatusId) async {
    timerPlaying = true;
    notifyListeners();
    await _timerRepository.readStart(bookStatusId);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime++;
      notifyListeners();
    });
  }

  void pause(int bookStatusId) async {
    _timer?.cancel();
    timerPlaying = false;
    tempTime = currentTime - tempTime;
    timerList.add(tempTime);
    notifyListeners();
    await _timerRepository.readEnd(bookStatusId);
  }

  void exit() {
    _timer ?? _timer?.cancel();
    timerPlaying = false;
    currentTime = 0;
  }

  void initTimer() {
    _timer?.cancel();
    currentTime = 0;
    timerPlaying = false;
  }
}
