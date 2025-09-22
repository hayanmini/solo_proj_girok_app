import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_girok_app/domain/models/user.dart' as domain_user;
import 'package:flutter_girok_app/presentation/pages/home/main_tab_page.dart';
import 'package:flutter_girok_app/presentation/providers/auth_provider.dart';
import 'package:flutter_girok_app/presentation/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  Future<void> _signInWithGoogle(BuildContext context, WidgetRef ref) async {
    final authRepo = ref.read(authRepositoryProvider);
    final userRepo = ref.read(userRepositoryProvider);

    try {
      final fbUser = await authRepo.signInWithGoogle();

      if (fbUser != null) {
        final domainUser = domain_user.User(
          id: fbUser.id,
          email: fbUser.email ?? "",
          displayName: fbUser.displayName ?? "",
          photoUrl: fbUser.photoUrl ?? "",
        );
        await userRepo.addUser(domainUser);
      }

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainTabPage()),
        );
      }
    } catch (e) {
      debugPrint("Google 로그인 오류 : $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('로그인 실패: $e')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      body: currentUserAsync.when(
        data: (fb.User? user) {
          if (user == null) {
            return Center(
              child: ElevatedButton.icon(
                onPressed: () => _signInWithGoogle(context, ref),
                icon: const Icon(Icons.login),
                label: const Text('Google로 로그인'),
              ),
            );
          } else {
            // 이미 로그인 된 상태면 바로 메인으로
            Future.microtask(() {
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const MainTabPage()),
                );
              }
            });
            return const Center(child: CircularProgressIndicator());
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("오류 발생 : $err")),
      ),
    );
  }
}
