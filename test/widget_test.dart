import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:moviedb/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Строим наше приложение и запускаем кадр.
    await tester.pumpWidget(MyApp()); // Убрали const

    // Проверяем, что наш счетчик начинает с 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Нажимаем на иконку '+' и запускаем новый кадр.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Проверяем, что наш счетчик увеличился.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
