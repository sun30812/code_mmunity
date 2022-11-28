import 'dart:convert';
import 'package:code_mmunity/model/post.dart';
import 'package:code_mmunity/model/types.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// [Post]객체를 생성하거나 객체의 내용을 수정할 때 사용되는 컨트롤러이다.
///
/// 해당 컨트롤러를 통해 공감 수와 같은 데이터를 접근 및 수정할 수 있다.
/// DB 연계작업과 관련하여 사용될 예정으로 아직 사용해보지 않았으며 많은 변경이 발생할 수 있다.
/// 따라서 메서드들의 설명은 제공되지 않는다.
class PostController {
  late final Post _post;

  /// 서버에서 [PostController]리스트를 생성하기 위해 존재하는 메서드이다.
  ///
  /// [serverIp]에 제공된 서버 주소를 통해 포스트를 가져오는 명령을 수행할 수 있도록 한다.
  /// [compute()]메서드를 통해서 내부에서 독립적으로 처리할 수 있도록 하여 사용자에게는
  /// 쾌적하게 동작하도록 설계되었다.
  static Future<List<PostController>> fromServerAllPostList(
      {required String serverIp}) async {
    try {
      final response = await http.get(Uri.parse('$serverIp/api/posts'));

      return compute(_parsePosts, response.body);
    } catch (_) {
      rethrow;
    }
  }

  /// 서버에서 [PostController]객체를 가죠오기 위해 존재하는 메서드이다.
  ///
  /// [serverIp]에 제공된 서버 주소를 통해 단일 포스트를 가져오는 명령을 수행할 수 있도록 한다.
  /// [compute()]메서드를 통해서 내부에서 독립적으로 처리할 수 있도록 하여 사용자에게는
  /// 쾌적하게 동작하도록 설계되었다.
  static Future<PostController> fromServerPost(
      {required String serverIp, required int postId}) async {
    final response = await http.get(Uri.parse('$serverIp/api/posts/$postId'));
    if (response.statusCode == 404) {
      return PostController.none();
    }
    return compute(_parsePost, response.body);
  }

  /// json 리스트를 받아서 [PostController] 리스트로 변환하기 위해 사용되는 메서드이다.
  ///
  /// json리스트의 각 원소를 [PostController.fromJson()]메서드를 통해 변환해준다.
  ///
  /// ## 같이보기
  /// - [PostController.fromJson]
  /// - [PostController.fromServerAllPostList]
  static List<PostController> _parsePosts(String response) {
    final List<dynamic> parsed = jsonDecode(response);
    return parsed.map((json) => PostController.fromJson(json)).toList();
  }

  /// json을 받아서 [PostController]객체로 변환하기 위해 사용되는 메서드이다.
  ///
  /// json에서 받은 값을 [PostController]로 반환해준다.
  ///
  /// ## 같이보기
  /// - [PostController.fromJson]
  /// - [PostController.fromServerAllPostList]
  static PostController _parsePost(String response) {
    return PostController.fromJson(jsonDecode(response));
  }

  PostController({
    int id = -1,
    required String title,
    required String userId,
    required String userName,
    required ProgrammingLanguage language,
    required String data,
    int likes = 0,
    int reportCount = 0,
    String createAt = '2022-10-11 21:29:30',
    bool isNotice = false,
  }) {
    _post = Post(
      id: id,
      userId: userId,
      title: title,
      userName: userName,
      language: language,
      data: data,
      likes: likes,
      reportCount: reportCount,
      createAt: createAt,
      isNotice: isNotice,
    );
  }

  factory PostController.dummy() {
    return PostController(
      userId: 'g\$34d%j234',
      title: 'Dummy',
      userName: 'dummy_user',
      language: ProgrammingLanguage.rust,
      data: 'Dummy Data',
    );
  }

  factory PostController.notice({required String title, required String data}) {
    return PostController(
      isNotice: true,
      userId: 'admin',
      title: title,
      userName: 'Admin',
      language: ProgrammingLanguage.rust,
      data: data,
    );
  }

  /// 아무 정보도 없는 포스트를 만들기 위한 메서드이다.
  ///
  /// 어떠한 문제로 인해 포스트를 넘겨줄 수 없을 때 `null`대신 넘길 수 있는 포스트를 만들어준다.
  /// 프로그램 오류 없이 [userId]가 `null`로 설정되기 때문에 포스트 정보를 받는 입장에서는 이러한 포스트를
  /// 받았을 때 적절한 처리가 가능해진다.
  factory PostController.none() {
    return PostController(
      userId: 'null',
      title: '',
      userName: '',
      language: ProgrammingLanguage.rust,
      data: '',
    );
  }

  /// json으로된 값을 [PostController]로 역직렬화 시키기 위한 메서드이다.
  ///
  /// 대시보드에 들어가면 서버상에 존재하는 포스트를 보여주는데 이 때 사용되며, 리스트 형식의 json을
  /// [List<PostController>]로 변환할 때 사용이 된다.
  ///
  /// ## 같이보기
  ///
  /// - [PostController]
  /// - [Post]
  factory PostController.fromJson(Map<String, dynamic> json) {
    return PostController(
      id: json['post_id'] as int,
      userId: json['user_id'],
      title: json['title'],
      userName: json['user_name'],
      language: ProgrammingLanguage.values.byName(json['language']),
      data: json['data'],
      likes: json['likes'] as int,
      reportCount: json['report_count'] as int,
      createAt: json['create_at'],
    );
  }

  /// 작성한 포스트를 API서버로 전송하기 위한 형태로 변환하는 메서드이다.
  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'title': title,
        'language': language.name,
        'data': data
      };

  /// 포스트의 id를 가져온다.
  int get id => _post.id;

  /// 포스트의 UID를 가져온다.
  String get userId => _post.userId;

  /// 포스트 작성자 정보를 가져온다.
  String get userName => _post.userName;

  /// 포스트의 제목을 가져온다.
  String get title => _post.title;

  /// 포스트에 작성된 프로그래밍 언어 종류를 가져온다..
  ProgrammingLanguage get language => _post.language;

  /// 포스트 내용을 가져온다.
  String get data => _post.data;

  /// 공감 수를 가져온다.
  int get likes => _post.likes;

  /// 포스트 작성 날짜를 가져온다.
  String get createAt => _post.createAt;

  /// 포스트를 삭제하는 메서드이다.
  Future<void> deletePost(String serverIp)  {
    return http.delete(Uri.parse(
        '$serverIp/api/posts?user_id=${_post.userId}&post_id=${_post.id}'));
  }

  /// 공감 버튼을 누를 시 공감수를 추가해주는 메서드이다.
  Future<void> incrementLikes(String serverIp, String userId) {
    return http.patch(
        Uri.parse('$serverIp/api/likes?user_id=$userId&post_id=${_post.id}&mode=Increment'));
  }

  /// 공감 버튼을 다시 누를 시 공감수를 감소시켜주는 메서드이다.
  Future<void> decrementLikes(String serverIp, String userId) {
    return http.patch(
        Uri.parse('$serverIp/api/likes?user_id=$userId&post_id=${_post.id}&mode=Decrement'));
  }

  /// 신고버튼을 누를 시 신고 횟수를 올려주는 메서드이다.
  void report() {
    _post.reportCount++;
  }
}
