import 'package:code_mmunity/model/post.dart';

/// [Post]객체를 생성하거나 객체의 내용을 수정할 때 사용되는 컨트롤러이다.
///
/// 해당 컨트롤러를 통해 공감 수와 같은 데이터를 접근 및 수정할 수 있다.
/// DB 연계작업과 관련하여 사용될 예정으로 아직 사용해보지 않았으며 많은 변경이 발생할 수 있다.
/// 따라서 메서드들의 설명은 제공되지 않는다.
class PostController {
  late final Post _post;

  PostController() {
    _post = Post(
        title: 'Test',
        data: 'This content is test',
        likes: 0,
        reportCount: 0,
        leftDays: 5);
  }

  int get likes => _post.likes;

  void incrementLikes() {
    _post.likes++;
  }

  void decrementLikes() {
    _post.likes--;
  }

  void report() {
    _post.reportCount++;
  }
}
