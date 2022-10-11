import 'package:flutter/material.dart';

/// 포스트를 클릭할 시 보여주는 상세 페이지이다.
///
/// 아직 상세페이지에 대한 작업을 준비중이다. 빠른 시일 내에 작업 진행 예정이다.
///
// TODO: 상세 페이지 작업 필요
class PostPage extends StatelessWidget {
  final String postId;
  const PostPage({required this.postId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('포스트 ID: $postId'),
        ),
      ),
    );
  }
}
