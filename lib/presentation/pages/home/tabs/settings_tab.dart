import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_girok_app/presentation/pages/login/login_page.dart';

class SettingsTab extends StatelessWidget {
  final ScrollController scrollController;
  const SettingsTab({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("설정")),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODO : 기능 구현 및 연결
              // 작성 설정
              titleText("작성 설정"),
              settingItem(Icons.font_download_outlined, "폰트 설정", () {}),
              Divider(),
              SizedBox(height: 5),

              // 시스템 설정
              titleText("시스템 설정"),
              settingItem(Icons.dark_mode, "다크 모드", () {}),
              Divider(),
              SizedBox(height: 5),

              // 계정 설정
              titleText("계정 설정"),
              settingItem(Icons.logout_outlined, "로그아웃", () async {
                FirebaseAuth.instance.signOut();

                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  // 설정 타이틀
  Widget titleText(String title) => Row(
    children: [
      SizedBox(width: 5),
      Padding(
        padding: const EdgeInsets.all(5),
        child: Text(title, style: TitleTextStyle.titleBold16),
      ),
    ],
  );

  // 설정 아이템
  Widget settingItem(dynamic icon, String title, Function tap) {
    return GestureDetector(
      onTap: () async => await tap(),
      child: Row(
        children: [
          SizedBox(width: 50, height: 50, child: Icon(icon)),
          Text(title),
        ],
      ),
    );
  }
}
