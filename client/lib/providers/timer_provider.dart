import 'dart:async';
import 'dart:math';

import 'package:dokki/data/repository/timer_repository.dart';
import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  final TimerRepository _timerRepository = TimerRepository();
  Timer? _timer;
  Timer? _rotateTimer;
  double rotateValue = 0.0;
  int currentTime = 0;
  int resumeTime = 0;
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

  void rotateStart() {
    _rotateTimer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      if (rotateValue > 360 * pi / 180) rotateValue = 0.0;
      rotateValue += 1 * pi / 180;
      notifyListeners();
    });
  }

  void rotatePause() {
    _rotateTimer?.cancel();
    notifyListeners();
  }

  void pause(int bookStatusId) async {
    _timer?.cancel();
    timerPlaying = false;
    resumeTime += tempTime;
    tempTime = currentTime - resumeTime;
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
    rotateValue = 0.0;
    tempTime = 0;
    resumeTime = 0;
    timerList = [];
    timerPlaying = false;
  }
}
