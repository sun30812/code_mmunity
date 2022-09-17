import 'package:code_mmunity/view/style.dart';
import 'package:code_mmunity/view/write_post.dart';
import 'package:flutter/material.dart';

/// 실질적으로 포스트가 보이는 대시보드 화면이다.
///
/// 포스트를 가져오는 동작이 포함된 곳으로써 포스트 가져오기 관련 동작을 수정할 때에는
/// 해당 코드를 수정하면 된다.
///
/// 포스트 디자인을 수정 하는 경우 [PostCard]를 통해 수정할 수 있다.
///
/// 같이보기
///
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
            },
            icon: const Icon(Icons.settings_outlined),
            tooltip: '환경설정',
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: '코드 쓰기',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostCard(
            title: '시작하기',
            data: Column(
              children: const [
                Text('우측 상단 연필 아이콘을 눌러 새로운 포스팅을 시작해보세요!'),
              ],
            ),
            isNotice: true,
          ),
          Row(
            children: const [
              PostCard(title: '테스트 게시글', data: Text('sdsdd')),
              PostCard(title: '테스트 게시글', data: Text('sdsdd')),
            ],
          ),
        ],
      ),
    );
  }
}
