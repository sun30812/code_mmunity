import 'package:code_mmunity/controller/post_controller.dart';
import 'package:code_mmunity/model/post.dart';
import 'package:code_mmunity/view/style.dart';
import 'package:code_mmunity/view/write_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 시연용 대시보드 화면이다.
///
/// 정확하게는 시연용 대시보드 화면의 상단 영역을 담당하며, 실질적인 게시글이 나타나는 영역은
/// [PostsPage]가 담당한다.
///
/// 같이보기
///
/// - [PostsPage]
/// - [PostCard]
///
class Dashboard extends StatelessWidget {
  /// 시연용 대시보드의 화면을 나타내는 생성자이다.
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '대시보드',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              FirebaseAuth.instance.currentUser!.displayName ?? '이름 없음',
              style: const TextStyle(fontSize: 16.0),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) => context.go('/'));
            },
            icon: const Icon(Icons.power_settings_new_outlined),
            tooltip: '로그아웃',
          ),
          IconButton(
            onPressed: () => context.go('/refresh-post'),
            icon: const Icon(Icons.refresh_outlined),
            tooltip: '새로고침',
          ),
          IconButton(
            onPressed: () {
              // TODO: 환경설정창으로 이동하는 동작 구현 필요
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('현재 이 기능은 동작하지 않습니다.'),
                duration: Duration(seconds: 2),
              ));
            },
            icon: const Icon(Icons.settings_outlined),
            tooltip: '환경설정',
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: '게시글 작성',
            onPressed: () {
              bool darkMode =
                  MediaQuery.of(context).platformBrightness == Brightness.dark;
              context.push('/posts/new', extra: darkMode);
            },
          )
        ],
      ),
      body: const PostsPage(),
    );
  }
}

/// 게시글이 나타나는 영역이다.
///
/// 실질적으로 게시글이 나타나는 영역으로 새로운 게시글을 받아오는 동작 또한 이곳에서 수행된다.
/// 해당 위젯은 실시간으로 내용이 변경되어야 하므로 [StatefulWidget]을 상속받는다.
///
/// 같이보기
///
/// - [PostsPage]
/// - [PostCard]
/// - [Post]
///
class PostsPage extends StatefulWidget {
  const PostsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  /// 화면 크기에 맞춰 한 행에 표시할 포스트 카드의 개수를 반환하는 메서드
  ///
  /// 화면 크기 별로 알맞은 크기의 카드를 제공하기 위해 화면의 너비를 [size]로 넘겨받아서
  /// 구한다.
  int getCrossAxisCount(int size) {
    if (size < 300) {
      return 1;
    } else if (size >= 300 && size < 550) {
      return 2;
    } else if (size >= 550 && size < 900) {
      return 3;
    }
    return 4;
  }

  final _demoInfoPost = PostController.notice(
      title: '시작하기', data: '우측 상단 연필 아이콘을 눌러 새로운 포스팅을 시작해보세요!');
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: PostCard(
            post: _demoInfoPost,
            isNotice: true,
          ),
        ),
        Expanded(
          child: FutureBuilder<List<PostController>>(
              future: PostController.fromServerAllPostList(
                  serverIp: const String.fromEnvironment('API_SERVER_IP')),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasError) {
                  return ServerErrorPage(error: snapshot.error);
                } else if (snapshot.hasData) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        List<PostController> posts =
                            snapshot.data as List<PostController>;
                        return GridView.count(
                          crossAxisCount: getCrossAxisCount(
                              constraints.maxWidth.toInt() - 300),
                          childAspectRatio: 1 / 0.5,
                          children: List.generate(posts.length, (index) {
                            return PostCard(post: posts[index]);
                          }),
                        );
                      },
                    ),
                  );
                } else {
                  return ServerErrorPage(
                    error: snapshot.error,
                  );
                }
              }),
        )
      ],
    );
  }
}
