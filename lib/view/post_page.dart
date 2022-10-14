import 'package:code_mmunity/controller/post_controller.dart';
import 'package:code_mmunity/view/style.dart';
import 'package:flutter/material.dart';

/// 포스트를 클릭할 시 보여주는 상세 페이지이다.
///
/// 아직 상세페이지에 대한 작업을 준비중이다. 빠른 시일 내에 작업 진행 예정이다.
///
// TODO: 댓글 페이지 작업 필요
class PostPage extends StatefulWidget {
  final String postId;
  const PostPage({required this.postId, Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String title = '게시글 상세보기';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: FutureBuilder<PostController>(
              future: PostController.fromServerPost(
                  serverIp: const String.fromEnvironment('API_SERVER_IP'),
                  postId: widget.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                } else if (snapshot.hasData) {
                  return PostCard(
                    isPage: true,
                    disableTap: true,
                    post: snapshot.data!,
                  );
                } else {
                  return ServerErrorPage(error: snapshot.error);
                }
              },
            ),
          ),
          Expanded(
              child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 23.0,
                      ),
                      Text('댓글',
                          style: TextStyle(
                              fontSize: 23.0, fontWeight: FontWeight.w600))
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.code_off_outlined,
                            size: 32.0,
                          ),
                          Text('현재 미리보기 버전에서는 이 기능이 동작하지 않습니다.')
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
