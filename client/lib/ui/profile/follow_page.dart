import 'package:flutter/material.dart';

class FollowPage extends StatelessWidget {
  const FollowPage({
    super.key,
    required this.userId,
    required this.category,
  });

  final String userId, category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('$userId의 $category페이지')),
    );
  }
}
