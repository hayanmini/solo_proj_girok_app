import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_girok_app/presentation/pages/login/login_page.dart';
import 'package:flutter_girok_app/presentation/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsTab extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const SettingsTab({super.key, required this.scrollController});

  @override
  ConsumerState<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends ConsumerState<SettingsTab> {
  Future<void> _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // 네비게이션 스택 초기화 & 로그인 페이지 이동
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint("로그아웃 오류: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('로그아웃 실패: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 계정 정보
    final userId = ref.watch(userIdProvider);
    final userAsync = userId == null
        ? AsyncValue.data(null)
        : ref.watch(userProfileProvider(userId));

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          controller: widget.scrollController,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleText("계정 정보"),
              SizedBox(height: 10),
              userAsync.when(
                data: (user) {
                  final photoUrl = user?.photoUrl;
                  final email = user?.email ?? "이메일 없음";

                  return Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BorderBoxDecoration.commonBox,
                    child: Row(
                      children: [
                        const SizedBox(width: 15),
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[800],
                            image: photoUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(photoUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: photoUrl == null
                              ? const Icon(Icons.person, size: 40)
                              : null,
                        ),
                        const SizedBox(width: 20),

                        // 계정 정보
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "이메일",
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),

                            Text(
                              email,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text("오류: $e"),
              ),
              const SizedBox(height: 15),
              const Divider(),

              // 작성 설정
              // titleText("작성 설정"),
              // settingItem(Icons.font_download_outlined, "폰트 설정", () {}),
              // Divider(),
              // SizedBox(height: 5),

              // 시스템 설정
              // titleText("시스템 설정"),
              // settingItem(Icons.dark_mode, "다크 모드", () {}),
              // Divider(),
              // SizedBox(height: 5),

              // 계정 설정
              SizedBox(height: 5),
              titleText("설정"),
              settingItem(
                Icons.logout_outlined,
                "로그아웃",
                () => _handleLogout(context),
              ),
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
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Row(
          children: [
            SizedBox(width: 50, height: 50, child: Icon(icon)),
            Text(title),
          ],
        ),
      ),
    );
  }
}
