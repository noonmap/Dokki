import 'package:dokki/utils/routes/routes_name.dart';
import 'package:dokki/view/profile/widget/profile_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.userId,
    required this.nickname,
    required this.isMine,
    required this.keys,
  }) : super(key: key);

  final String userId, nickname;
  final bool isMine;
  final Map<String, GlobalKey> keys;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ProfileMenuItem(
            icon: Ionicons.heart_outline,
            label: '찜한 책',
            onTap: () {
              Navigator.pushNamed(context, RoutesName.wishlist,
                  arguments: {"loginUserId": userId});
            },
          ),
          isMine
              ? ProfileMenuItem(
                  icon: Ionicons.book_outline,
                  label: '감정 일기',
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.diary);
                  },
                )
              : ProfileMenuItem(
                  icon: Ionicons.library_outline,
                  label: '서재',
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.library,
                        arguments: {'userId': userId, 'nickname': nickname});
                  },
                ),
          ProfileMenuItem(
            icon: Ionicons.calendar_outline,
            label: '독서 달력',
            onTap: () {
              Scrollable.ensureVisible(keys['calendar']!.currentContext!,
                  duration: const Duration(seconds: 1));
            },
          ),
          ProfileMenuItem(
            icon: Ionicons.bar_chart_outline,
            label: '한 해 기록',
            onTap: () {
              Scrollable.ensureVisible(keys['chart']!.currentContext!,
                  duration: const Duration(seconds: 1));
            },
          ),
        ],
      ),
    );
  }
}
