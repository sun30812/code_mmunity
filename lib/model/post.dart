import 'package:code_mmunity/model/types.dart';

/// 포스트에 관한 데이터를 담고있는 클래스 이다.
///
/// [Post] 생성자를 통해 포스트에 필요한 데이터를 가진 인스턴스를 생성한다.
///
/// 하지만 해당 클래스는 객체 구조를 쉽게 확인하기 위해 분리한 것으로 직접 객체 생성은 금지한다.
/// [PostController] 생성자를 통해 객체를 생성하기 바란다.
class Post {
  /// 공지용 포스트인지 여부를 지정할 수 있다. 기본값은 `false`로 지정된다.
  final bool isNotice;

  /// 포스트의 작성자의 고유 ID 부분에 해당된다. `null`이 될 수 없다.
  final String userId;

  /// 포스트의 제목 부분에 해당된다. `null`이 될 수 없다.
  final String title;

  /// 포스트 작성자 이름에 해당한다. `null`이 될 수 없다.
  final String userName;

  /// 포스트에 기재된 프로그래밍 언어 이름이다.. `null`이 될 수 없다.
  final ProgrammingLanguage language;

  /// 포스트의 내용 부분에 해당된다. `null`이 될 수 없다.
  final String data;

  /// 포스트가 작성된 날짜 및 시간에 해당된다. `null`이 될 수 없다.

  final String createAt;

  /// 포스트의 고유 ID 부분에 해당된다. `null`이 될 수 없다.
  final int id;

  /// 포스트가 공감받은 회수에 해당한다. `null`이 될 수 없다.
  int likes;

  /// 포스트가 신고당한 횟수에 해당된다. `null`이 될 수 없다.

  int reportCount;

  /// 포스트의 객체를 생성한다.
  ///
  /// 포스트를 구분하기 위해 [id]가 반드시 표함되어야 한다.
  /// [title]에 제목이 들어가야 하며, [data]에는 포스트의 내용이 들어간다.
  /// [isNotice]를 `true`로 지정하므로써 공지용 포스트라 알릴 수 있다.
  ///
  /// 이 경우 공감 수를 나타내는 [likes], 신고 횟수에 해당하는 [reportCount]를
  /// 지정하지 않아도 된다.
  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.userName,
    required this.language,
    required this.data,
    this.isNotice = false,
    required this.likes,
    required this.reportCount,
    required this.createAt,
  });
}
