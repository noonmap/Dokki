import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void logout() async {
      const storage = FlutterSecureStorage();
      await UserApi.instance.logout();
      await storage.deleteAll();
      Navigator.popAndPushNamed(context, RoutesName.login);
    }

    return GestureDetector(
      onTap: logout,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Paragraph(
            text: '로그아웃',
            color: brandColor300,
          ),
          SizedBox(width: 8),
          Icon(
            Icons.logout,
            color: brandColor300,
            size: 16,
          ),
        ],
      ),
    );
  }
}
