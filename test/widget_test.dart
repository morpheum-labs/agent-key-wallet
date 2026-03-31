import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('smoke: MaterialApp renders', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('Rainbow'),
        ),
      ),
    );
    expect(find.text('Rainbow'), findsOneWidget);
  });
}
