import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.abc,
                  size: 56,
                ),
                SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('닉네임이다'),
                    Row(
                      children: [
                        Text('팔로잉  0'),
                        SizedBox(width: 24),
                        Text('팔로워  0'),
                      ],
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
