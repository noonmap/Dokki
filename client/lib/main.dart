import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

// 모든 widget은 build 메서드를 구현해줘야 한다.
// 앱의 root widget은 두개의 옵션 중 하나를 리턴해야 한다.
// 1. material 앱을 리턴한다.
// 2. cupertino 앱을 리턴한다.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: Scaffold(
          backgroundColor: Color(0xFF181818),
        ));
  }
}
