import 'dart:convert';
import 'package:code_mmunity/model/post_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PostUserController {
  late final PostUser _user;

  PostUserController(User user) {
    _user = PostUser(userId: user.uid, userName: user.displayName ?? '[이름 없음]');
  }
  PostUserController.fromPostUser(PostUser postuser) {
    _user = postuser;
  }

  /// 사용자 이름을 가져온다.
  String get userName => _user.userName;

  /// 서버에서 사용자 정보를 가져오는 메서드이다.
  ///
  /// Google이 아닌 코드뮤니티 서버에서 사용자에 대한 정보를 가져온다.
  static Future<PostUserController> getUser(
      {required String serverIp, required String userId}) async {
    try {
      final response = await http.get(Uri.parse('$serverIp/api/users/$userId'));
      return compute(_parseUser, response.body);
    } catch (_) {
      rethrow;
    }
  }

  /// 사용자 이름을 서버에 등록시키는 메서드이다.
  Future<void> registerUser(String serverIp) async {
    if ((await http.get(Uri.parse(
                '$serverIp/api/users/${FirebaseAuth.instance.currentUser!.uid}')))
            .statusCode !=
        404) {
      return;
    }
    http.post(Uri.parse(
        '$serverIp/api/users?user_id=${_user.userId}&user_name=${_user.userName}'));
  }

  static PostUserController _parseUser(String response) {
    return PostUserController.fromJson(jsonDecode(response));
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
  factory PostUserController.fromJson(Map<String, dynamic> json) {
    PostUser user =
        PostUser(userId: json['user_id'], userName: json['user_name']);
    return PostUserController.fromPostUser(user);
  }
}
