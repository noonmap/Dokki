import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/opacity_loading.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:dokki/common/widget/pink_button.dart';
import 'package:dokki/view/profile/widget/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({
    super.key,
  });

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final storage = const FlutterSecureStorage();
  String userId = '';
  String nickname = '';
  String profileImg = '';

  void getUserInfoFromStorage() async {
    String? tmpId = await storage.read(key: "userId");
    String? tmpName = await storage.read(key: 'nickname');
    String? tmpImg = await storage.read(key: 'profileImageUrl');

    if (tmpId != null && tmpName != null && tmpImg != null) {
      setState(() {
        userId = tmpId;
        nickname = tmpName;
        profileImg = tmpImg;
      });
    }
  }

  @override
  void initState() {
    getUserInfoFromStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onSaveButtonClicked() {
      // 저장 클릭 시 수행할 코드 작성
    }

    return profileImg == ''
        ? const OpacityLoading()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
              child: Column(
                children: [
                  // 상단 메뉴바
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const SizedBox(
                          width: 36,
                          height: 36,
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 22,
                            color: brandColor300,
                          ),
                        ),
                      ),
                      const Paragraph(
                        text: '프로필 편집',
                        size: 18,
                        weightType: WeightType.medium,
                      ),
                      GestureDetector(
                        onTap: onSaveButtonClicked,
                        child: const SizedBox(
                          width: 36,
                          height: 36,
                          child: Center(
                            child: Paragraph(
                              text: '저장',
                              size: 18,
                              color: brandColor400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // 프로필 사진
                  Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Image.network(
                            profileImg,
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PinkButton(
                              onTap: () {},
                              text: '이미지 선택',
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 닉네임
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Paragraph(
                          text: '닉네임',
                          size: 20,
                          weightType: WeightType.semiBold,
                        ),
                        TextField(
                          maxLength: 10,
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Paragraph(
                              text: '로그아웃',
                              color: brandColor300,
                            ),
                            SizedBox(width: 8),
                            LogoutButton(),
                          ],
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
