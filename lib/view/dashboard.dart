import 'package:code_mmunity/controller/post_controller.dart';
import 'package:code_mmunity/model/post.dart';
import 'package:code_mmunity/view/style.dart';
import 'package:code_mmunity/view/write_post.dart';
import 'package:flutter/material.dart';

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
class TestDashboard extends StatelessWidget {
  /// 시연용 대시보드의 화면을 나타내는 생성자이다.
  const TestDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '대시보드',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '시연용',
              style: TextStyle(fontSize: 16.0, color: Colors.redAccent),
            )
          ],
        ),
        actions: [
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
              showDialog(
                  context: context,
                  builder: (BuildContext context) => WritePostDialog(
                        isDarkMode: darkMode,
                      ));
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
  final _demoInfoPost =
      PostController(title: '시작하기', data: '우측 상단 연필 아이콘을 눌러 새로운 포스팅을 시작해보세요!');
  final List<PostController> _dummyPosts = [
    PostController(),
    PostController(title: 'Dummy2'),
    PostController(title: 'Dummy3'),
    PostController(title: 'Dummy4'),
    PostController(title: 'Dummy5'),
  ];
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
              future:
                  PostController.fromServer(serverIp: 'http://127.0.0.1:8080'),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (snapshot.hasData) {
                  return LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      List<PostController> posts =
                          snapshot.data as List<PostController>;
                      return GridView.count(
                        crossAxisCount:
                            (constraints.maxWidth.toInt() - 200) ~/ 200,
                        childAspectRatio: 2.0,
                        children: List.generate(posts.length, (index) {
                          return PostCard(post: posts[index]);
                        }),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
              }),
        )
      ],
    );
  }
}
