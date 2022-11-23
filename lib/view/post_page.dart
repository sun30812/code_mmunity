import 'dart:convert';

import 'package:code_mmunity/controller/comment_controller.dart';
import 'package:code_mmunity/controller/post_controller.dart';
import 'package:code_mmunity/view/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

/// 포스트를 클릭할 시 보여주는 상세 페이지이다.
///
class PostPage extends StatefulWidget {
  final int postId;
  const PostPage({required this.postId, Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String title = '게시글 상세보기';
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/')),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Icon(Icons.chat_outlined),
                Text(
                  ' 댓글',
                  style: TextStyle(fontSize: 23.0),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('새로운 댓글 작성하기'),
                    TextField(
                      controller: controller,
                      maxLines: 1,
                      maxLength: 120,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () async {
                              if (controller.text.isEmpty) {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text('오류'),
                                          content:
                                              const Text('댓글이 작성되지 않았습니다.'),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('닫기'))
                                          ],
                                        ));
                                return;
                              }
                              CommentController sendData = CommentController(
                                  postId: widget.postId,
                                  userId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  userName: '',
                                  data: controller.text);
                              http.Response result = await http.post(
                                  Uri.parse(
                                      '${const String.fromEnvironment('API_SERVER_IP')}/api/comments'),
                                  headers: {'Content-Type': 'application/json'},
                                  body: jsonEncode(sendData));
                              if (!mounted) {
                                return;
                              }
                              if (result.statusCode == 201) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('댓글이 업로드 되었습니다.')));
                                context.go('/refresh-post',
                                    extra: widget.postId);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        '댓글이 업로드 되지 않았습니다. [http 오류코드: ${result.statusCode}]')));
                              }
                            },
                            child: const Text('작성')),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<CommentController>>(
              future: CommentController.fromServer(
                  serverIp: const String.fromEnvironment('API_SERVER_IP'),
                  postId: widget.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                } else if (snapshot.hasData) {
                  List<CommentController> lists = snapshot.data!;
                  return ListView.builder(
                    itemCount: lists.length,
                    itemBuilder: (context, index) {
                      return CommentCard(
                        userName: lists[index].userName,
                        data: lists[index].data,
                      );
                    },
                  );
                } else {
                  return ServerErrorPage(error: snapshot.error);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
