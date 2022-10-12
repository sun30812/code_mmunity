/// 댓글에 관한 데이터를 담고있는 클래스 이다.
///
/// [Comment] 생성자를 통해 댓글에 필요한 데이터를 가진 인스턴스를 생성한다.
///
/// 하지만 해당 클래스는 객체 구조를 쉽게 확인하기 위해 분리한 것으로 직접 객체 생성은 금지한다.
/// [CommentController] 생성자를 통해 객체를 생성하기 바란다.
class Comment {
  final String uid, data, createAt;
  int id, likes, reportCount;

  /// 댓글 객체를 생성한다.
  ///
  /// 댓글 각각을 구분하기 위해 [id]가 반드시 표함되어야 한다.
  /// [data]에는 댓글 내용이 들어가고, 작성자를 확인하기 위해 [uid]가 사용된다.
  /// 댓글의 공감 수를 나타내는 [likes], 신고 횟수에 해당하는 [reportCount]가
  /// 존재하여 포스트처럼 댓글도 사용자의 공감이나 신고를 받을 수 있다.
  /// 댓글의 작성 날짜는 [createAt]을 통해 받는다.
  Comment({
    /// 댓글의 고유 ID 부분에 해당된다. `null`이 될 수 없다.
    required this.id,

    /// 댓글의 작성자를 식별하는 ID 부분에 해당된다. `null`이 될 수 없다.
    required this.uid,

    /// 댓글의 내용 부분에 해당된다. `null`이 될 수 없다.
    required this.data,

    /// 댓글이 공감받은 횟수에 해당된다. `null`이 될 수 없다.
    required this.likes,

    /// 댓글이 신고당한 횟수에 해당된다. `null`이 될 수 없다.
    required this.reportCount,

    /// 댓글이 작성된 날짜 및 시간에 해당된다. `null`이 될 수 없다.
    required this.createAt,
  });
}
