import 'package:code_mmunity/model/types.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
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
  final bool disableTap;
  final bool isPage;

  /// 포스트를 보여주는 카드이다.
  ///
  ///
  /// 만일 공지용 포스트로 제작하는 경우 [isNotice] 매개변수의 값을 `true`로 해야한다.
  const PostCard(
      {Key? key,
      required this.post,
      this.isNotice,
      this.disableTap = false,
      this.isPage = false})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLike = false;
  bool _isClicked = false;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _likes = widget.post.likes;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post.userId == 'null') {
      return const NotFoundPostErrorPage();
    }
    return GestureDetector(
      onTapDown: (_) {
        if (widget.isNotice ?? false || widget.disableTap) {
          return;
        }
        setState(() {
          _isClicked = true;
        });
      },
      onTapUp: (_) {
        if (widget.isNotice ?? false || widget.disableTap) {
          return;
        }
        setState(() {
          _isClicked = false;
        });
      },
      onTapCancel: () {
        if (widget.isNotice ?? false || widget.disableTap) {
          return;
        }
        setState(() {
          _isClicked = false;
        });
      },
      onTap: () {
        if (widget.isNotice ?? false || widget.disableTap) {
          return;
        }
        context.push('/posts/${widget.post.id}', extra: widget.post.title);
      },
      child: Card(
        elevation: _isClicked ? 2.5 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.post.title,
                          style: const TextStyle(fontSize: 24.0)),
                      if (!(widget.isNotice ?? false))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.edit_note_outlined),
                                Text(
                                  widget.post.language.stringValue,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.person_outline),
                                Text(
                                  widget.post.userName,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                    ],
                  ),
                  if (widget.isNotice ?? false) ...[
                    Text(widget.post.data)
                  ] else ...[
                    HighlightView(widget.post.data,
                        language: widget.post.language.name,
                        theme: atomOneLightTheme,
                        textStyle: const TextStyle(
                            fontSize: 18.0, fontFamily: 'D2Coding')),
                  ]
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.isNotice == null || !widget.isNotice!)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined),
                            if (widget.isPage)
                              Text(widget.post.createAt)
                            else
                              Text(widget.post.createAt.substring(0, 10))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (widget.isPage) ...[
                              OutlinedButton(
                                  onPressed: () => setState(() {
                                        if (!_isLike) {
                                          widget.post.incrementLikes(
                                              const String.fromEnvironment(
                                                  'API_SERVER_IP'));
                                          _isLike = true;
                                          _likes++;
                                        } else {
                                          widget.post.decrementLikes(
                                              const String.fromEnvironment(
                                                  'API_SERVER_IP'));
                                          _isLike = false;
                                          _likes--;
                                        }
                                      }),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        _isLike
                                            ? Icons.favorite
                                            : Icons.favorite_border_outlined,
                                        color: Colors.pinkAccent,
                                      ),
                                      Text(_likes.toString())
                                    ],
                                  )),
                              const IconButton(
                                  onPressed: null, icon: Icon(Icons.share)),
                              const IconButton(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.notification_important_outlined,
                                    color: Colors.amber,
                                  )),
                              if ((FirebaseAuth.instance.currentUser != null) &&
                                  (widget.post.userId ==
                                      FirebaseAuth.instance.currentUser!.uid))
                                OutlinedButton(
                                    style: const ButtonStyle(),
                                    onPressed: () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('삭제 안내'),
                                            content: const Text(
                                                '정말로 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('취소')),
                                              TextButton(
                                                  onPressed: () {
                                                    widget.post
                                                        .deletePost(const String
                                                                .fromEnvironment(
                                                            'API_SERVER_IP'))
                                                        .then((_) => context.go(
                                                            '/refresh-post'));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    '게시글이 삭제 되었습니다.')));
                                                  },
                                                  child: const Text('확인')),
                                            ],
                                          ),
                                        ),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.delete_outline),
                                        Text('게시글 삭제')
                                      ],
                                    ))
                            ] else ...[
                              IconButton(
                                  onPressed: () => setState(() {
                                        if (!_isLike) {
                                          widget.post.incrementLikes(
                                              const String.fromEnvironment(
                                                  'API_SERVER_IP'));
                                          _isLike = true;
                                        } else {
                                          widget.post.decrementLikes(
                                              const String.fromEnvironment(
                                                  'API_SERVER_IP'));
                                          _isLike = false;
                                        }
                                      }),
                                  icon: Icon(
                                    _isLike
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
                            ]
                          ],
                        ),
                      ],
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final String userName;
  final String data;
  const CommentCard({required this.userName, required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [Text(userName), Text(data)],
          )),
    );
  }
}

class ServerErrorPage extends StatelessWidget {
  final dynamic error;
  const ServerErrorPage({
    required this.error,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.desktop_access_disabled_sharp),
            const Text('서버에 접속할 수 없습니다.'),
            Text('\n개발자에게 다음 메세지를 보고하세요!: [${error.toString()}]'),
          ],
        ),
      ),
    );
  }
}

/// 존재하지 않는 페이지를 방문할 시 화면이다.
class NotFoundErrorPage extends StatelessWidget {
  const NotFoundErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('오류: 존재하지 않는 페이지'),
          backgroundColor: Colors.orangeAccent,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '404 Not Found',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '현재 존재하지 않는 페이지로 접속하셨습니다.\n아래와 같은 이유로 해당 문제가 발생하였습니다.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const ListTile(
                      leading: Icon(Icons.link_off_outlined),
                      title: Text('주소창에 존재하지 않는 주소를 작성한 경우'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.toggle_off_outlined),
                      title: Text('개발자가 아직 구현하지 않은 기능에 접근한 경우'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.adb_outlined),
                      title: Text('개발자가 실수한 경우'),
                    ),
                    const Divider(),
                    const Text('아래 버튼을 눌러 조치를 취하세요'),
                    ListTile(
                      leading: const Icon(Icons.mail_outline),
                      title: const Text('(오류인 것으로 보인다면) 개발자에게 이메일 보내기'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('개발자에게 메일 보내기'),
                              content: Column(
                                children: [
                                  const Text(
                                      '아래 주소로 현재 사이트 주소와 문제 사항을 보내주세요.\n'),
                                  Row(
                                    children: [
                                      const Text(
                                          '이메일 주소: orgsun30812+code_mmunity@gmail.com'),
                                      IconButton(
                                          onPressed: () => Clipboard.setData(
                                                  const ClipboardData(
                                                      text:
                                                          'orgsun30812+code_mmunity@gmail.com'))
                                              .then((value) => ScaffoldMessenger
                                                      .of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          '이메일 주소가 복사되었습니다.')))),
                                          icon: const Icon(Icons.copy))
                                    ],
                                  )
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('확인'))
                              ],
                            );
                          },
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.home_outlined),
                      title: const Text('대시보드로 이동'),
                      onTap: () => context.go('/'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

/// 존재하지 않는 포스트를 방문할 시 화면이다.
class NotFoundPostErrorPage extends StatelessWidget {
  const NotFoundPostErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '포스트를 찾을 수 없음',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '현재 존재하지 않는 포스트에 접근하셨습니다.\n이 문제는 아래 이유들로 인해 발생합니다.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const ListTile(
                  leading: Icon(Icons.link_off_outlined),
                  title: Text('주소창에 존재하지 않는 포스트 ID를 작성한 경우'),
                ),
                const ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text('포스트 작성자가 글을 지운 경우'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
