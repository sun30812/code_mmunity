import 'package:code_mmunity/view/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

/// 제일 먼저 앱을 실행하면 보이는 화면이다.
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  Future<UserCredential> signInWithGoogle() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Co{de}mmunity',
              style: TextStyle(
                  fontFamily: 'D2Coding',
                  fontSize: 62.0,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              '코드로 통하는 우리들의 커뮤니티.\n코드뮤니티에 오신걸 환영합니다.',
              style: TextStyle(
                fontSize: 32.0,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: SubmitButton(
                    buttonTitle: '시작하기(시연 모드)',
                    iconData: Icons.login,
                    onClick: () => context.go('/test_dashboard'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: SubmitButton(
                    buttonTitle: '로그인 없이 살펴보기',
                    iconData: Icons.view_carousel_outlined,
                    onClick: () => context.go('/posts'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: SubmitButton(
                    buttonTitle: 'Google로 로그인하기',
                    iconData: Icons.key_outlined,
                    onClick: () async {
                      await signInWithGoogle().then((value) {
                        if (value.user != null) {
                          context.go('/posts');
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
