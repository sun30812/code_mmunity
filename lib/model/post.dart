/// 포스트에 관한 데이터를 담고있는 클래스 이다.
///
/// [Post] 생성자를 통해 포스트에 필요한 데이터를 가진 인스턴스를 생성한다.
///
/// 하지만 해당 클래스는 객체 구조를 쉽게 확인하기 위해 분리한 것으로 직접 객체 생성은 금지한다.
/// [PostController] 생성자를 통해 객체를 생성하기 바란다.
class Post {
  final bool isNotice;
  final String title, data;
  int likes, reportCount, leftDays;

  /// 포스트의 객체를 생성한다.
  ///
  /// [title]에 제목이 들어가야 하며, [data]에는 포스트의 내용이 들어간다.
  /// [isNotice]를 `true`로 지정하므로써 공지용 포스트라 알릴 수 있다.
  ///
  /// 이 경우 공감 수를 나타내는 [likes], 신고 횟수에 해당하는 [reportCount]
  /// , 삭제까지 남은 기간을 보여주는 [leftDays]를 지정하지 않아도 된다.
  Post(
      {

      /// 포스트의 제목 부분에 해당된다. `null`이 될 수 없다.
      required this.title,

      /// 포스트의 내용 부분에 해당된다. `null`이 될 수 없다.
      required this.data,

      /// 공지용 포스트인지 여부를 지정할 수 있다. 기본값은 `false`로 지정된다.
      this.isNotice = false,

      /// 포스트가 공감받은 횟수에 해당된다. `null`이 될 수 없다.
      required this.likes,

      /// 포스트가 신고당한 횟수에 해당된다. `null`이 될 수 없다.
      required this.reportCount,

      /// 포스트가 지워지기까지 남은 일자에 해당된다. `null`이 될 수 없다.
      required this.leftDays});
}
