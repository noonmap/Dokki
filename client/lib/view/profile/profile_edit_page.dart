import 'dart:io';
import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/opacity_loading.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:dokki/common/widget/pink_button.dart';
import 'package:dokki/providers/user_provider.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:dokki/view/profile/widget/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
  File? pickedImg;

  final TextEditingController _textEditingController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

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

  Future<void> getImageFromGallery() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        pickedImg = File(pickedFile.path);
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
    final up = Provider.of<UserProvider>(context);

    Future<void> onSaveButtonTap() async {
      String newNickname = _textEditingController.text;
      // 닉네임
      if (newNickname != '') {
        await up.putNickname(nickname: newNickname);
      }
      // 프로필 사진
      if (pickedImg != null) {
        await up.postProfileImage(img: pickedImg!);
      }
      Navigator.pushNamed(context, RoutesName.profile,
          arguments: {'userId': userId});
    }

    return profileImg == ''
        ? const OpacityLoading()
        : Scaffold(
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                                onTap: onSaveButtonTap,
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
                                  child: pickedImg != null
                                      ? Image.file(
                                          pickedImg!,
                                          width: 160,
                                          height: 160,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
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
                                      onTap: getImageFromGallery,
                                      text: '이미지 선택',
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          // 닉네임
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Paragraph(
                                  text: '닉네임',
                                  size: 20,
                                  weightType: WeightType.semiBold,
                                ),
                                TextField(
                                  controller: _textEditingController,
                                  maxLength: 20,
                                  decoration:
                                      InputDecoration(hintText: nickname),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          SizedBox(width: 4),
                          LogoutButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
