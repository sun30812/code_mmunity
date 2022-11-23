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
      body: Column(
        children: [
          FutureBuilder<PostUserController>(
              future: PostUserController.getUser(
                  serverIp: const String.fromEnvironment('API_SERVER_IP'),
                  userId: FirebaseAuth.instance.currentUser!.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<PostUserController> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Card(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Card(
                    child: Center(child: Icon(Icons.error_outline)),
                  );
                } else {
                  return SettingsCard(
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
                            const TextButton(
                                onPressed: null, child: Text('변경하기')),
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
                          ]));
                }
              }),
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
                            content: const Text('이 작업은 되돌릴 수 없습니다. 계속 하시겠습니까?'),
                            actions: [
                              const TextButton(
                                  onPressed: null, child: Text('확인')),
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('취소')),
                            ],
                          )),
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.redAccent)),
                  child: const Text('삭제하기'),
                )
              ])),
        ],
      ),
    );
  }
}
