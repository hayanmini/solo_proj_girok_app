import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/theme/colors.dart';
import 'package:flutter_girok_app/domain/models/user.dart' as domain_user;
import 'package:flutter_girok_app/presentation/pages/home/main_tab_page.dart';
import 'package:flutter_girok_app/presentation/providers/auth_provider.dart';
import 'package:flutter_girok_app/presentation/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isLoggingIn = false;
  // // 네비게이션 중복 방지
  // bool _hasNavigated = false;

  Future<void> _signInWithSNS({required bool isGoogle}) async {
    if (_isLoggingIn) return;

    setState(() {
      _isLoggingIn = true;
    });

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final userRepo = ref.read(userRepositoryProvider);

      final fbUser = isGoogle
          ? await authRepo.signInWithGoogle()
          : await authRepo.signInWithApple();

      if (fbUser != null && mounted) {
        final domainUser = domain_user.User(
          id: fbUser.id,
          email: fbUser.email,
          displayName: fbUser.displayName ?? "",
          photoUrl: fbUser.photoUrl ?? "",
        );
        await userRepo.addUser(domainUser);

        Future.microtask(() {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainTabPage()),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('로그인 실패: $e')));
      }
    } finally {
      if (mounted && fb.FirebaseAuth.instance.currentUser == null) {
        setState(() {
          _isLoggingIn = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backPointColor,
      body: SafeArea(
        // 로그인되지 않은 상태 - 로그인 버튼 표시
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 130),
                Image.asset(
                  "assets/logo.png",
                  width: 250,
                  height: 180,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 12),

                Text(
                  "기록이",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.level2Color,
                  ),
                ),
                SizedBox(height: 140),

                if (_isLoggingIn)
                  Column(
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text('로그인 중...'),
                    ],
                  )
                else
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => _signInWithSNS(isGoogle: true),
                          icon: const Icon(Icons.login_rounded),
                          label: const Text('Google 로그인'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => _signInWithSNS(isGoogle: false),
                          icon: const Icon(Icons.apple_rounded),
                          label: const Text('Apple 로그인'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      // SignInWithAppleButton(
                      //   onPressed: () {},
                      //   style: SignInWithAppleButtonStyle.black,
                      //   height: 50,
                      //   borderRadius: BorderRadius.circular(12),
                      //   text: "Apple 로그인",
                      // ),
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
