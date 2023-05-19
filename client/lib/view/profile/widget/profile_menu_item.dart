import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ProfileMenuItem extends StatelessWidget {
  final IoniconsData icon;
  final String label;
  final dynamic onTap;
  // final RoutesName route;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    // required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 68,
          child: Column(
            children: [
              Icon(
                icon,
                color: grayColor400,
                size: 36,
              ),
              const SizedBox(height: 12),
              Paragraph(
                text: label,
                color: grayColor400,
                size: 14,
              ),
            ],
          ),
        ));
  }
}
