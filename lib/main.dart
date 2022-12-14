import 'package:code_mmunity/view/dashboard.dart';
import 'package:code_mmunity/view/refresh_page.dart';
import 'package:code_mmunity/view/login.dart';
import 'package:code_mmunity/view/post_page.dart';
import 'package:code_mmunity/view/refresh_post_page.dart';
import 'package:code_mmunity/view/settings.dart';
import 'package:code_mmunity/view/style.dart';
import 'package:code_mmunity/view/write_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance.setPersistence(Persistence.SESSION);
  runApp(App());
}

/// 앱의 시작 부분에 해당되는 영역이다.
///
/// 테마나 각 경로에 대한 설정만을 표현하며, 실질적인 화면은 [LoginPage]로 구분
/// 되어있다.
class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: '코드뮤니티',
      themeMode: ThemeMode.system,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
    );
  }

  final GoRouter _router = GoRouter(
      errorBuilder: (context, state) => const NotFoundErrorPage(),
      routes: [
        GoRoute(
          path: '/',
          redirect: (context, state) {
            if (FirebaseAuth.instance.currentUser != null) {
              return '/posts';
            } else {
              return null;
            }
          },
          builder: (context, state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: '/posts',
          redirect: (context, state) {
            if (FirebaseAuth.instance.currentUser == null) {
              return '/';
            } else {
              return null;
            }
          },
          builder: (context, state) {
            return const Dashboard();
          },
        ),
        GoRoute(
          path: '/settings',
          redirect: (context, state) {
            if (FirebaseAuth.instance.currentUser == null) {
              return '/';
            } else {
              return null;
            }
          },
          builder: (context, state) => SettingsPage(),
        ),
        GoRoute(
          path: '/posts/new',
          redirect: (context, state) {
            if (FirebaseAuth.instance.currentUser == null) {
              return '/';
            } else {
              return null;
            }
          },
          builder: (context, state) {
            return WritePostPage(
                isDarkMode: state.extra != null ? state.extra as bool : false);
          },
        ),
        GoRoute(
          path: '/refresh-posts',
          redirect: (context, state) {
            if (FirebaseAuth.instance.currentUser == null) {
              return '/';
            } else {
              return null;
            }
          },
          builder: (context, state) {
            return const RefreshPage();
          },
        ),
        GoRoute(
          path: '/refresh-post',
          builder: (context, state) {
            return RefreshPostPage(postId: state.extra as int);
          },
        ),
        GoRoute(
          path: '/posts/:postId',
          builder: (context, state) {
            return PostPage(postId: int.parse(state.params['postId']!));
          },
        ),
      ]);
}
