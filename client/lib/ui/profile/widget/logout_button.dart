import 'package:dokki/constants/colors.dart';
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
      child: const Icon(
        Icons.logout,
        color: brandColor300,
      ),
    );
  }
}
