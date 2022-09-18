import 'package:code_mmunity/model/post.dart';
import 'package:code_mmunity/view/style.dart';
import 'package:code_mmunity/view/write_post.dart';
import 'package:flutter/material.dart';

/// 대시보드 화면이다.
///
/// 대시보드 화면의 상단 영역을 담당하며, 실질적인 게시글이 나타나는 영역은
/// [PostsPage]가 담당한다.
///
/// 같이보기
///
/// - [PostsPage]
/// - [PostCard]
///
class Dashboard extends StatelessWidget {
  /// 대시보드의 화면을 나타내는 생성자이다.
  const Dashboard({Key? key}) : super(key: key);

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
              '로그인 하지 않음',
              style: TextStyle(fontSize: 16.0),
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
  final List<String> _dummyPosts = [
    'Test1',
    'Test2',
    'Test3',
    'Test4',
    'Test5'
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: PostCard(
            title: '시작하기',
            data: Column(
              children: const [
                Text('우측 상단 연필 아이콘을 눌러 새로운 포스팅을 시작해보세요!'),
              ],
            ),
            isNotice: true,
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 600) {
                return GridView.count(
                  crossAxisCount: (constraints.maxWidth.toInt() - 200) ~/ 200,
                  childAspectRatio: 2.0,
                  children: List.generate(_dummyPosts.length, (index) {
                    return PostCard(
                        title: '테스트 게시글', data: Text(_dummyPosts[index]));
                  }),
                );
              }
              return ListView.builder(
                  itemCount: _dummyPosts.length,
                  itemBuilder: (BuildContext context, int count) {
                    return PostCard(
                        title: '테스트 게시글', data: Text(_dummyPosts[count]));
                  });
            },
          ),
        )
      ],
    );
  }
}
