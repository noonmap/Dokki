import 'package:dokki/ui/profile/widgets/profile_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ProfileMenuItem(
            icon: Ionicons.library_outline,
            label: '서재',
          ),
          ProfileMenuItem(
            icon: Ionicons.leaf_outline,
            label: '텃밭',
          ),
          ProfileMenuItem(
            icon: Ionicons.calendar_outline,
            label: '독서 달력',
          ),
          ProfileMenuItem(
            icon: Ionicons.bar_chart_outline,
            label: '한 해 기록',
          ),
        ],
      ),
    );
  }
}
