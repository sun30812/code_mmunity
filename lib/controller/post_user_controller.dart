import 'package:code_mmunity/model/post_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class PostUserController {
  late final PostUser _user;

  PostUserController(User user) {
    _user = PostUser(userId: user.uid, userName: user.displayName ?? '[이름 없음]');
  }

  /// 사용자 이름을 서버에 등록시키는 메서드이다.
  Future<void> registerUser(String serverIp) async {
    http.post(Uri.parse(
        '$serverIp/api/users?user_id=${_user.userId}&user_name=${_user.userName}'));
  }
}
