import 'dart:convert';
import 'package:code_mmunity/model/comment.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// [Comment]객체를 생성하거나 객체의 내용을 수정할 때 사용되는 컨트롤러이다.
///
/// DB 연계작업과 관련하여 사용될 예정으로 아직 사용해보지 않았으며 많은 변경이 발생할 수 있다.
/// 따라서 메서드들의 설명은 제공되지 않는다.
class CommentController {
  late final Comment _comment;

  /// 서버에서 [CommentController]리스트를 생성하기 위해 존재하는 메서드이다.
  ///
  /// [serverIp]에 제공된 서버 주소를 통해 댓글를 가져오는 명령을 수행할 수 있도록 한다.
  /// [compute()]메서드를 통해서 내부에서 독립적으로 처리할 수 있도록 하여 사용자에게는
  /// 쾌적하게 동작하도록 설계되었다.
  static Future<List<CommentController>> fromServer(
      {required String serverIp, required int postId}) async {
    final response =
        await http.get(Uri.parse('$serverIp/api/comments/$postId'));
    return compute(_parseComments, response.body);
  }

  /// json 리스트를 받아서 [CommentController] 리스트로 변환하기 위해 사용되는 메서드이다.
  ///
  /// json리스트의 각 원소를 [CommentController.fromJson]메서드를 통해 변환해준다.
  ///
  /// ## 같이보기
  /// - [CommentController.fromJson]
  /// - [CommentController.fromServer]
  static List<CommentController> _parseComments(String response) {
    final List<dynamic> parsed = jsonDecode(response);
    return parsed.map((json) => CommentController.fromJson(json)).toList();
  }

  CommentController({
    int commentId = -1,
    required int postId,
    required String userId,
    required String userName,
    required String data,
    String createAt = '2022-10-11 21:29:30',
  }) {
    _comment = Comment(
      commentId: commentId,
      postId: postId,
      userId: userId,
      userName: userName,
      data: data,
      createAt: createAt,
    );
  }

  factory CommentController.dummy() {
    return CommentController(
      postId: -1,
      userId: 'g\$34d%j234',
      userName: 'dummy_user',
      data: 'Dummy Comment Data',
    );
  }

  /// 아무 내용이 없는 댓글를 만들기 위한 메서드이다.
  ///
  /// 어떠한 문제로 인해 댓글를 넘겨줄 수 없을 때 `null`대신 넘길 수 있는 댓글를 만들어준다.
  /// 프로그램 오류 없이 [userName]가 `null`로 설정되기 때문에 댓글 정보를 받는 입장에서는 이러한 댓글를
  /// 받았을 때 적절한 처리가 가능해진다.
  factory CommentController.none() {
    return CommentController(
      postId: -1,
      userId: 'null',
      userName: 'null',
      data: '',
    );
  }

  /// json으로된 값을 [CommentController]로 역직렬화 시키기 위한 메서드이다.
  ///
  /// 대시보드에 들어가면 서버상에 존재하는 댓글를 보여주는데 이 때 사용되며, 리스트 형식의 json을
  /// [List<CommentController>]로 변환할 때 사용이 된다.
  ///
  /// ## 같이보기
  ///
  /// - [CommentController]
  /// - [Comment]
  factory CommentController.fromJson(Map<String, dynamic> json) {
    return CommentController(
      commentId: json['comment_id'] as int,
      postId: json['post_id'] as int,
      userId: json['user_id'],
      userName: json['user_name'],
      data: json['data'],
      createAt: json['create_at'],
    );
  }

  /// 작성한 댓글을 API서버로 전송하기 위한 형태로 변환하는 메서드이다.
  Map<String, dynamic> toJson() =>
      {'post_id': postId, 'user_id': userId, 'data': data};

  /// 댓글의 id를 가져온다.
  int get id => _comment.commentId;

  /// 게시글의 id를 가져온다.
  int get postId => _comment.postId;

  /// 댓글의 작성자를 가져온다.
  String get userName => _comment.userName;

  /// 댓글의 작성자의 고유 ID를 가져온다.
  String get userId => _comment.userId;

  /// 댓글 내용을 가져온다.
  String get data => _comment.data;

  /// 댓글의 작성 날짜를 가져온다.
  String get createAt => _comment.createAt;
}
