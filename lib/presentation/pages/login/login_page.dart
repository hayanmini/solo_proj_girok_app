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
  // 네비게이션 중복 방지
  bool _hasNavigated = false;

  Future<void> _signInWithSNS({required bool isGoogle}) async {
    if (_isLoggingIn) {
      return;
    }

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

        _navigateToMain();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('로그인 실패: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingIn = false;
        });
      }
    }
  }

  void _navigateToMain() {
    if (_hasNavigated) {
      return;
    }
    _hasNavigated = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasNavigated) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainTabPage()),
        (route) => false,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    final authRepo = ref.read(authRepositoryProvider);
    if (authRepo.getCurrentUser() != null) {
      _navigateToMain();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.backGrey,
      body: SafeArea(
        child: currentUserAsync.when(
          data: (fb.User? user) {
            // 로그인된 상태 - 메인으로 이동
            if (user != null && !_hasNavigated) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text('메인 화면으로 이동 중...'),
                  ],
                ),
              );
            }

            // 네비게이션 예약되었지만 아직 user가 있는 경우
            if (user != null && _hasNavigated) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text('잠시만 기다려주세요...'),
                  ],
                ),
              );
            }

            // 로그인되지 않은 상태 - 로그인 버튼 표시
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Girok App',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 200),

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
                              icon: const Icon(Icons.login),
                              label: const Text('Google 로그인'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: () => _signInWithSNS(isGoogle: false),
                              icon: const Icon(Icons.login),
                              label: const Text('Apple 로그인'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
          loading: () {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text('인증 상태 확인 중...'),
                ],
              ),
            );
          },
          error: (err, stack) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text("인증 오류가 발생했습니다"),
                    SizedBox(height: 8),
                    Text("$err", style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _hasNavigated = false;
                        });
                        ref.invalidate(currentUserProvider);
                      },
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
