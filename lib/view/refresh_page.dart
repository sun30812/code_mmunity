import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 정보를 강제로 갱신할 때 쓰이는 화면이다.
///
/// 특정 위젯을 보여주는 것이 아닌 강제로 데이터 새로고침이 필요할 때 사용한다. 해당 페이지로
/// 이동을 시킨 경우 대시보드(로그인 된 경우) 혹은 로그인 화면으로 다시 이동하게 된다.
///
/// {@tool snippet}
///
/// 이 예제는 게시글 정보를 갱신하는 방법을 나타낸다.
///
/// ```dart
/// // main.dart에 `routes`항목 추가
/// GoRoute(
/// path: '/refresh',
/// redirect: (context, state) {
///   if (FirebaseAuth.instance.currentUser == null) {
///     return '/';
///   } else {
///     return null;
///   }
/// },
/// builder: (context, state) {
///   return const RefreshPage();
///   },
/// ),
/// // 새로고침이 필요한 경우 `/refresh` 호출
/// context.go('/refresh')
///  ```
/// {@end-tool}
///
/// 같이보기
///
/// - [PostsPage]
/// - [PostCard]
/// - [GoRouter]
///
class RefreshPage extends StatelessWidget {
  const RefreshPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.go('/');
    return Container();
  }
}
