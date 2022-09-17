import 'package:code_mmunity/view/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:code_mmunity/main.dart';

void main() {
  group('메인 화면 테스트', () {
    testWidgets('메인 화면상 위젯 점검', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      expect(find.text('Co{de}mmunity'), findsOneWidget);
      expect(find.byIcon(Icons.login), findsOneWidget);
    });

    testWidgets('대시보드 이동버튼 동작 확인', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      await tester.tap(find.byIcon(Icons.login));
      await tester.pumpAndSettle();

      expect(find.text('시작하기'), findsOneWidget);
    });
  });
  group('대시보드 테스트', () {
    testWidgets('대시보드 내 위젯 표시 여부 확인', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      await tester.tap(find.byIcon(Icons.login));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      expect(find.byType(PostCard), findsNWidgets(3));
    });

    testWidgets('글쓰기 버튼 동작 여부 확인', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      await tester.tap(find.byIcon(Icons.login));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      expect(find.text('게시글 작성'), findsOneWidget);
    });
  });
}
