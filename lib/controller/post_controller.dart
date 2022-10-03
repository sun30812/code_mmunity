import 'dart:convert';

import 'package:code_mmunity/model/post.dart';
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
  static Future<List<PostController>> fromServer(
      {required String serverIp}) async {
    final response = await http.get(Uri.parse('$serverIp/posts'));
    return compute(_parsePosts, response.body);
  }

  /// json 리스트를 받아서 [PostController] 리스트로 변환하기 위해 사용되는 메서드이다.
  ///
  /// json리스트의 각 원소를 [PostController.fromJson()]메서드를 통해 변환해준다.
  ///
  /// ## 같이보기
  /// - [PostController.fromJson]
  /// - [PostController.fromServer]
  static List<PostController> _parsePosts(String response) {
    final List<dynamic> parsed = jsonDecode(response);
    return parsed.map((json) => PostController.fromJson(json)).toList();
  }

  PostController({
    String id = 'null',
    String title = 'Dummy',
    String user = 'dummy_user',
    String data = 'Dummy Data',
    int likes = 0,
    int reportCount = 0,
    int leftDays = 0,
  }) {
    _post = Post(
        id: id,
        title: title,
        user: user,
        data: data,
        likes: 0,
        reportCount: 0,
        leftDays: 0);
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
        id: json['id'],
        title: json['title'],
        user: json['user'],
        data: json['data'],
        likes: json['likes'] as int,
        reportCount: json['report_count'] as int,
        leftDays: json['left_days'] as int);
  }

  /// 작성한 포스트를 API서버로 전송하기 위한 형태로 변환하는 메서드이다.
  Map<String, dynamic> toJson() => {'title': title, 'user': user, 'data': data};

  /// 포스트의 id를 가져온다.
  String get id => _post.id;

  /// 포스트 작성자 정보를 가져온다.
  String get user => _post.user;

  /// 포스트의 제목을 가져온다.
  String get title => _post.title;

  /// 포스트 내용을 가져온다.
  String get data => _post.data;

  /// 공감 수를 가져온다.
  int get likes => _post.likes;

  /// 공감 버튼을 누를 시 공감수를 추가해주는 메서드이다.
  void incrementLikes() async {
    http.Response result = await http
        .post(Uri.parse('http://127.0.0.1:8080/add_likes'), body: _post.id);
    _post.likes++;
  }

  /// 공감 버튼을 다시 누를 시 공감수를 감소시켜주는 메서드이다.
  void decrementLikes() async {
    http.Response result = await http.post(
        Uri.parse('http://127.0.0.1:8080/decrement_likes'),
        body: _post.id);
    _post.likes--;
  }

  /// 신고버튼을 누를 시 신고 횟수를 올려주는 메서드이다.
  void report() {
    _post.reportCount++;
  }
}
