import 'package:code_mmunity/controller/post_user_controller.dart';
import 'package:code_mmunity/view/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/types.dart';

class SettingsPage extends StatefulWidget {
  /// [DropdownButton]을 위한 프로그래밍 언어 목록이다.
  ///
  /// [DropdownMenuItem]에 아이템으로 등록하기 위해서는 [DropdownMenuItem]으로 변환을 해주어야 한다. 이 작업을 위해 만든 변수이다.
  final List<DropdownMenuItem<ProgrammingLanguage>> _menuItem =
      ProgrammingLanguage.values
          .map((value) => DropdownMenuItem(
                value: value,
                child: Text(value.stringValue),
              ))
          .toList();

  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ProgrammingLanguage _currentLanguage = ProgrammingLanguage.rust;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('환경 설정'),
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/')),
      ),
      body: FutureBuilder<PostUserController>(
          future: PostUserController.getUser(
              serverIp: const String.fromEnvironment('API_SERVER_IP'),
              userId: FirebaseAuth.instance.currentUser!.uid),
          builder: (BuildContext context,
              AsyncSnapshot<PostUserController> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Icon(Icons.error_outline));
            } else {
              return Column(
                children: [
                  SettingsCard(
                      leadingIcon: Icons.supervised_user_circle_outlined,
                      title: '사용자 관련 설정',
                      settingHint: '사용자 관련 설정을 변경할 수 있습니다.',
                      content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID 변경하기',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text('현재 사용 중인 ID: ${snapshot.data!.userName}'),
                            TextButton(
                                onPressed: () {
                                  TextEditingController controller =
                                      TextEditingController();
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('ID 변경하기'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            const Text('새로운 ID를 입력해주세요'),
                                            TextField(
                                              controller: controller,
                                              maxLength: 255,
                                            ),
                                            const Text(
                                                '해당 변경사항은 재로그인 시 완전히 적용됩니다.')
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('취소')),
                                        TextButton(
                                            onPressed: () => snapshot.data!
                                                    .updateUser(
                                                        const String
                                                                .fromEnvironment(
                                                            'API_SERVER_IP'),
                                                        controller.text)
                                                    .then((value) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              '계정 ID가 변경되었습니다.')));
                                                  context.go('/');
                                                }),
                                            child: const Text('확인')),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text('변경하기')),
                            const Divider(),
                            Row(
                              children: [
                                const Text('선호하는 언어: '),
                                DropdownButton(
                                  value: _currentLanguage,
                                  items: widget._menuItem,
                                  onChanged: (value) => setState(() {
                                    _currentLanguage = value!;
                                  }),
                                )
                              ],
                            )
                          ])),
                  SettingsCard(
                      leadingIcon: Icons.disabled_by_default_outlined,
                      title: '계정 삭제',
                      settingHint: '사용자 정보와 사용자가 작성한 것들을 전부 삭제합니다.',
                      content: Column(children: [
                        TextButton(
                          onPressed: () => showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => AlertDialog(
                                    title: const Text('경고'),
                                    content: const Text(
                                        '이 작업은 되돌릴 수 없습니다. 계속 하시겠습니까?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () => snapshot.data!
                                                  .deleteUser(const String
                                                          .fromEnvironment(
                                                      'API_SERVER_IP'))
                                                  .then((value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            '계정이 삭제되었습니다.')));
                                                context.go('/');
                                              }),
                                          child: const Text('확인')),
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('취소')),
                                    ],
                                  )),
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.redAccent)),
                          child: const Text('삭제하기'),
                        )
                      ])),
                ],
              );
            }
          }),
    );
  }
}
