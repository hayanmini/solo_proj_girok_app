import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/theme/colors.dart';
import 'package:flutter_girok_app/presentation/pages/home/main_tab_page.dart';
import 'package:flutter_girok_app/presentation/pages/login/login_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 로딩 속도 조절 가능
    )..forward();

    Future.delayed(const Duration(seconds: 2), () async {
      final fbUser = fb.FirebaseAuth.instance.currentUser;
      if (fbUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainTabPage()),
        );
      } else {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backPointColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 360),

            Image.asset("assets/logo.png", width: 200),
            const SizedBox(height: 24),
            const Text(
              "미루기를 관리하는 스마트 기록,\nAI가 함께하는 나만의 기록 파트너",
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              height: 8,
              child: AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(12),
                    value: _progressController.value,
                    backgroundColor: AppColors.pointColor,
                    color: AppColors.level1Color,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
