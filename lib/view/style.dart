import 'package:flutter/material.dart';

import '../controller/post_controller.dart';

/// 기본 동작을 취하는 버튼이다.
///
/// [SubmitButton]위젯은 아이콘과 글자가 같이 있는 형태의 버튼이다. 매개변수로 버튼 제목, 아이콘, 동작 등을 넘겨받으며,
/// 경우에 따라 글자만 있는 버튼을 만들 수 있다.
///
/// {@tool snippet}
///
/// 이 예제는 로그인 버튼을 어떻게 만드는지 보여준다.
///
/// ```dart
/// SubmitButton(
///      buttonTitle: '로그인',
///      iconData: Icons.login,
///      onClick: () => print('로그인 되었습니다.')
///  )
///  ```
/// {@end-tool}
///
/// ## 비활성화 된 버튼
///
/// [onClick] 매개변수에 아무 값도 넘겨주지 않으므로써 비활성화 된 버튼을 제작할 수 있다.
/// 이 경우 버튼은 색상은 회색으로 표시되며 눌리지 않는다.
class SubmitButton extends StatelessWidget {
  /// 버튼의 테마 색상이다. 아직 지원되지 않는다.
  ///
  /// TODO: 버튼 색상을 변경 가능하도록 로직 수정 필요
  final Color buttonColor;

  /// 버튼의 텍스트이며 [iconData] 오른쪽에 위치한다. `null`이 될 수 없다.
  final String buttonTitle;

  /// 버튼의 동작을 알려주는 아이콘을 지정한다. `IconData`를 직접 매개변수로 넘겨주면 된다.
  final IconData? iconData;

  /// 버튼의 동작을 정의한다. `null`인 경우 버튼은 비활성화 된 모습으로 나타난다.
  final Function()? onClick;

  /// 아이콘과 글자가 포함된 기본 동작을 취하는 버튼이다.
  ///
  /// [iconData] 오른쪽에 [buttonTitle]이 위치한 버튼을 생성한다.
  /// [iconData]가 지정되지 않은 경우 아이콘은 나타나지 않는다.
  /// [onClick] 매개변수를 통해 버튼 클릭시 동작을 정의한다.정의되지 않은 경우 버튼은 비활성화 된 모습으로 나타난다.
  const SubmitButton(
      {Key? key,
      required this.buttonTitle,
      this.buttonColor = Colors.blueAccent,
      this.iconData,
      this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onClick,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconData != null)
                Row(
                  children: [
                    Icon(iconData),
                    const Padding(padding: EdgeInsets.only(right: 15.0)),
                  ],
                ),
              Text(
                buttonTitle,
                style: const TextStyle(fontSize: 20.0),
              ),
            ],
          ),
        ));
  }
}

/// 대시보드 화면에서 포스트로 나타나는 카드이다.
///
/// [PostCard]는 대시보드에서 게시글을 나타내는 카드 위젯이다. 제목, 내용(코드), 기타 동작이 포함된 형태가 기본이 된다.
/// 공지용으로 [PostCard]를 만드는 경우 [isNotice] 매개변수를 통해 기타 동작의 유무를 제어할 수 있다.
///
/// {@tool snippet}
///
/// 이 예제는 공지용 포스트를 어떻게 만드는지 보여준다.
///
/// ```dart
/// PostCard(
///   post: PostController(title: '시작하기', data: '우측 상단 연필 아이콘을 눌러 새로운 포스팅을 시작해보세요!');
///   isNotice: true,
///  )
/// ```
/// {@end-tool}
class PostCard extends StatefulWidget {
  /// 포스트에 대한 정보를 담고있는 [PostController]를 가진다.
  final PostController post;

  /// 공지용 포스트로 지정할 지를 결정한다. 이 매개변수가 `true`인 경우 해당 포스트는 닫을 수 있으며, 일부 기능이 포스트에 나타나지 않는다.
  ///
  /// ## 일부 기능
  ///
  /// - 감정표현
  /// - 공유하기
  /// - 신고
  /// - 차단
  final bool? isNotice;

  /// 포스트를 보여주는 카드이다.
  ///
  ///
  /// 만일 공지용 포스트로 제작하는 경우 [isNotice] 매개변수의 값을 `true`로 해야한다.
  const PostCard({Key? key, required this.post, this.isNotice})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLike = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.post.title, style: const TextStyle(fontSize: 24.0)),
                Text(widget.post.data),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isNotice == null || !widget.isNotice!)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () => setState(() {
                                if (!isLike) {
                                  widget.post.incrementLikes();
                                  isLike = true;
                                } else {
                                  widget.post.decrementLikes();
                                  isLike = false;
                                }
                              }),
                          icon: Icon(
                            isLike
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: Colors.pinkAccent,
                          )),
                      const IconButton(
                          onPressed: null, icon: Icon(Icons.share)),
                      const IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.notification_important_outlined,
                            color: Colors.amber,
                          ))
                    ],
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
