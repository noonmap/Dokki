import 'package:dokki/constants/colors.dart';
import 'package:dokki/providers/user_provider.dart';
import 'package:dokki/ui/common_widgets/paragraph.dart';
import 'package:dokki/ui/profile/widgets/profile_menu.dart';
import 'package:dokki/ui/profile/widgets/user_bio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🍇TODO :: userBio - 본인 프로필 여부에 따라 1️⃣팔로우 버튼, 2️⃣메뉴 구성 다르게 하기
// 🍇TODO :: menuItem - onTap 처리하기

class ProfilePage extends StatefulWidget {
  // 🍇 임시 유저 ID
  final int userId = 1;
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    final up = Provider.of<UserProvider>(context, listen: false);
    up.getUserBioById(1);
  }

  @override
  Widget build(BuildContext context) {
    final up = Provider.of<UserProvider>(context);
    up.getUserBioById(1);

    return Scaffold(
      body: up.isLoading || up.userBio == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 60, 28, 0),
              child: Column(
                children: [
                  const SizedBox(height: 36),
                  // 바이오
                  userBio(up: up),
                  const SizedBox(height: 48),
                  // 메뉴
                  const ProfileMenu(),
                  const SizedBox(height: 48),
                  // 독서 달력
                  Container(
                    width: double.infinity,
                    height: 448,
                    padding: const EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: brandColor100),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Paragraph(
                          text: '독서 달력',
                          size: 20,
                          weightType: WeightType.semiBold,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  // 한 해 기록
                  Container(
                    width: double.infinity,
                    height: 284,
                    padding: const EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: brandColor100),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Paragraph(
                          text: '한 해 기록',
                          size: 20,
                          weightType: WeightType.semiBold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
