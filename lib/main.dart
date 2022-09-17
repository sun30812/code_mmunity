import 'package:code_mmunity/view/dashboard.dart';
import 'package:code_mmunity/view/style.dart';
import 'package:flutter/material.dart';

void main() => runApp(const App());

/// 앱의 시작 부분에 해당되는 영역이다.
///
/// 테마나 각 경로에 대한 설정만을 표현하며, 실질적인 화면은 [MainPage]로 구분
/// 되어있다.
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/dashboard': (context) => const Dashboard(),
      },
    );
  }
}

/// 제일 먼저 앱을 실행하면 보이는 화면이다.
class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

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
                  fontFamily: 'JetBrainsMono',
                  fontSize: 62.0,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              '코드로 통하는 우리들의 커뮤니티.\n코드뮤니티에 오신걸 환영합니다.',
              style: TextStyle(
                fontSize: 32.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: SubmitButton(
                buttonTitle: '로그인 없이 살펴보기',
                iconData: Icons.login,
                onClick: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('현재 이 기능은 동작하지 않습니다.'),
                    duration: Duration(seconds: 2),
                  ));
                  Navigator.pushNamed(context, '/dashboard');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
