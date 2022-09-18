import 'package:code_mmunity/view/style.dart';
import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/rust.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/dart.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';

/// 게시글 작성을 누르면 나오는 다이얼로그 창이다.
///
/// [WritePostDialog]위젯은 포스트 작성 시 필요한 옵션과 코드에디터로 구성된 다이얼로그이다. 별도의 매개변수는 가지지 않는다.
/// 게시글을 작성할 시 설정 변경에 따라 글자가 변경되어야 하므로 [StatefulWidget]을 상속한다.
///
/// {@tool snippet}
///
/// 이 예제는 [WritePostDialog]창을 띄우는 예제를 보여준다.
///
/// ```dart
/// IconButton(
///     icon: const Icon(Icons.edit_outlined),
///     tooltip: '코드 작성',
///     onPressed: () {
///       showDialog(context: context, builder: (BuildContext context) => WritePostDialog());
///     },
///   )
///  ```
/// {@end-tool}
///
///
class WritePostDialog extends StatefulWidget {
  final bool? isDarkMode;
  const WritePostDialog({this.isDarkMode, Key? key}) : super(key: key);

  @override
  State<WritePostDialog> createState() => _WritePostDialogState();
}

class _WritePostDialogState extends State<WritePostDialog> {
  /// [CodeField]에 사용되는 controller 이다.
  ///
  /// [CodeField]위젯을 사용하기 위해서는 `controller`가 필요하다. `controller`를 통해
  /// 에디터의 글자를 가져온다던가 변화에 따른 동작을 추가하는 등의 작업이 가능하다.
  late CodeController _controller;

  /// 포스트 작성 시 보여지는 프로그래밍 언어의 종류를 보여주는 변수이다.
  late String _language;

  /// 게시글 작성 다이얼로그를 연 직후인가 확인할 때 사용되는 변수이다.
  ///
  /// Flutter 특성 상 변경이 발생하면 [initState()]를 실행하는데 불필요한 동작이 발생되며
  /// 특정 경우에는 오동작이 발생하기 때문에 이를 막는 목적으로 사용된다.
  bool _isFirstRun = true;

  /// 프로그래밍 언어 목록이다. 언어를 추가 구현하기 위해서는 제일 먼저 해당 변수에 값을 추가해야 한다.
  final List<String> _languages = ['자동 감지', 'Rust', 'C++', 'Dart'];

  /// [DropdownButton]을 위한 프로그래밍 언어 목록이다.
  ///
  /// [DropdownMenuItem]에 아이템으로 등록하기 위해서는 [DropdownMenuItem]으로 변환을 해주어야 한다. 이 작업을 위해 만든 변수이다.
  final List<DropdownMenuItem> _menuItem = [];

  /// 다크모드 여부에 따라 코드 에디터의 테마를 변경시키는 메서드이다.
  ///
  /// [isDarkMode]가 `true`인 경우 코드 에디터의 테마가 [atomOneDarkTheme]로 적용되며, 반대의 경우
  /// [atomOneLightTheme]로 적용된다.
  Map<String, TextStyle> _getTheme() {
    if ((widget.isDarkMode == null) || !(widget.isDarkMode!)) {
      return atomOneLightTheme;
    }
    return atomOneDarkTheme;
  }

  /// 코드 에디터에서 프로그래밍 언어를 자동으로 감지해주는 메서드이다.
  ///
  /// 코드 에디터에서 특정 키워드가 발견되면 프로그래밍 언어를 전환시킨다.
  /// [text]매개변수는 사용자가 직접 전달하는 것이 아니다. [CodeController]의 [onChange]
  /// 매개변수에 이 메서드를 전달하면 알아서 사용된다.
  void languageDetector(String text) {
    String newLanguage = _languages[0];

    if (!(_menuItem[0].value == '자동 감지됨(C++)') &&
        (text.contains('#include') ||
            text.contains('printf') ||
            text.contains('cout'))) {
      setState(() {
        newLanguage = '자동 감지됨(C++)';
        _menuItem[0] =
            DropdownMenuItem(value: newLanguage, child: Text(newLanguage));
        if (_language.contains('자동 감지')) {
          _language = newLanguage;
        }
      });
    } else if (!(_menuItem[0].value == '자동 감지됨(Rust)') &&
        (text.contains('fn'))) {
      setState(() {
        newLanguage = '자동 감지됨(Rust)';
        _menuItem[0] =
            DropdownMenuItem(value: newLanguage, child: Text(newLanguage));
        if (_language.contains('자동 감지')) {
          _language = newLanguage;
        }
      });
    }
  }

  /// 언어 선택에 따라 코드 에디터의 문법을 바꿔주는 메서드이다.
  ///
  /// [newLanguage]에는 `C++`과 같은 언어 이름이 들어간다. 언어 이름에 따라 코드에디터의 문법을 바꾸어 준다. 자동 감지로 설정된 경우
  /// 우측에 있는 언어에 맞는 문법 적용 버튼을 눌러야 한다.
  void applyLanguage(String newLanguage) {
    _language = newLanguage;
    if (newLanguage.contains('Rust')) {
      _controller = CodeController(
          language: rust,
          theme: _getTheme(),
          onChange: languageDetector,
          text: _controller.text);
    } else if (newLanguage.contains('C++')) {
      _controller = CodeController(
          language: cpp,
          theme: _getTheme(),
          onChange: languageDetector,
          text: _controller.text);
    } else if (newLanguage.contains('Dart')) {
      _controller = CodeController(
          language: dart,
          theme: _getTheme(),
          onChange: languageDetector,
          text: _controller.text);
    }
  }

  @override
  void initState() {
    super.initState();
    if (_isFirstRun) {
      _language = _languages[0];
      for (String value in _languages) {
        _menuItem.add(DropdownMenuItem(
          value: value,
          child: Text(value),
        ));
      }
      _controller = CodeController(
          language: rust, theme: _getTheme(), onChange: languageDetector);
      _isFirstRun = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('게시글 작성'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Text('언어 설정: '),
                DropdownButton(
                    value: _language,
                    items: _menuItem,
                    onChanged: (value) => setState(() {
                          applyLanguage(value.toString());
                        })),
                if (_language.contains('자동 감지'))
                  SubmitButton(
                      buttonTitle: '언어에 맞는 문법 적용',
                      onClick: () => setState(() {
                            applyLanguage(_language);
                          })),
              ],
            ),
          ),
          SizedBox(
            width: 800,
            height: 500,
            child: CodeField(
                textStyle: const TextStyle(fontFamily: 'JetBrainsMono'),
                expands: true,
                controller: _controller),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소')),
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('작성'))
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
