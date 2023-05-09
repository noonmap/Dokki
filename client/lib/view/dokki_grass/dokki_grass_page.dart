import 'package:flutter/material.dart';

class DokkiGrassPage extends StatelessWidget {
  const DokkiGrassPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("독끼풀"));
  }
}
