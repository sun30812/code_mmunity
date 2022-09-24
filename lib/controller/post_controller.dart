import 'package:code_mmunity/model/post.dart';

/// [Post]객체를 생성하거나 객체의 내용을 수정할 때 사용되는 컨트롤러이다.
///
/// 해당 컨트롤러를 통해 공감 수와 같은 데이터를 접근 및 수정할 수 있다.
/// DB 연계작업과 관련하여 사용될 예정으로 아직 사용해보지 않았으며 많은 변경이 발생할 수 있다.
/// 따라서 메서드들의 설명은 제공되지 않는다.
class PostController {
  late final Post _post;

  static List<PostController> fromServer({required String serverIp}) {
    List<PostController> list = [];
    // TODO: list 변수에 서버에서 받아와서 추가하는 과정 필요
    return list;
  }

  PostController(
      {String id = 'null',
      String title = 'Dummy',
      String data = 'Dummy Data'}) {
    _post = Post(
        id: id,
        title: title,
        data: data,
        likes: 0,
        reportCount: 0,
        leftDays: 0);
  }

  /// 포스트의 id를 가져온다.
  String get id => _post.id;

  /// 포스트의 제목을 가져온다.
  String get title => _post.title;

  /// 포스트 내용을 가져온다.
  String get data => _post.data;

  /// 공감 수를 가져온다.
  int get likes => _post.likes;

  /// 공감 버튼을 누를 시 공감수를 추가해주는 메서드이다.
  void incrementLikes() {
    _post.likes++;
    print('현재 공감 수: ${_post.likes}');
  }

  /// 공감 버튼을 다시 누를 시 공감수를 감소시켜주는 메서드이다.
  void decrementLikes() {
    _post.likes--;
    print('현재 공감 수: ${_post.likes}');
  }

  /// 신고버튼을 누를 시 신고 횟수를 올려주는 메서드이다.

  void report() {
    _post.reportCount++;
  }
}
