import 'package:code_mmunity/controller/post_user_controller.dart';
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Co',
                    style: TextStyle(
                        fontFamily: 'D2Coding',
                        fontSize: 31.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                  Text(
                    '{',
                    style: TextStyle(
                        fontFamily: 'D2Coding',
                        fontSize: 31.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  Text(
                    'de',
                    style: TextStyle(
                        fontFamily: 'D2Coding',
                        fontSize: 31.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                  Text(
                    '}',
                    style: TextStyle(
                        fontFamily: 'D2Coding',
                        fontSize: 31.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  Text(
                    'mmunity',
                    style: TextStyle(
                        fontFamily: 'D2Coding',
                        fontSize: 31.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                  Text(
                    ' [미리보기 버전]',
                    style: TextStyle(
                        fontFamily: 'D2Coding',
                        fontSize: 31.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Text(
                '코드로 통하는 우리들의 커뮤니티.\n코드뮤니티에 오신걸 환영합니다.',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SubmitButton(
                      buttonTitle: '로그인 없이 살펴보기',
                      iconData: Icons.view_carousel_outlined,
                      onClick: () => ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                        content: Text('현재 이 기능은 동작하지 않습니다.'),
                        duration: Duration(seconds: 2),
                      )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SubmitButton(
                      buttonTitle: 'Google로 로그인하기',
                      iconData: Icons.key_outlined,
                      onClick: () async {
                        await signInWithGoogle().then((value) {
                          if (value.user != null) {
                            PostUserController(value.user!)
                                .registerUser(const String.fromEnvironment(
                                    'API_SERVER_IP'))
                                .then((_) => context.go('/posts'));
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
      ),
    );
  }
}
