import 'dart:async';

import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  late Timer timer;
  int currentTime = 0;
  bool timerPlaying = false;

  void start() {
    timerPlaying = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      currentTime++;
      notifyListeners();
    });
  }

  void pause() {
    timer.cancel();
    timerPlaying = false;
    notifyListeners();
  }

  void initTimer() {
    timer.cancel();
    currentTime = 0;
    timerPlaying = false;
  }
}
