import 'package:flutter_test/flutter_test.dart';
import 'package:dodgeit/main.dart';

void main() {
  testWidgets('DodgeIt home screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const DodgeItApp());

    expect(find.text('DodgeIt'), findsOneWidget);
    expect(find.text('Explore Features'), findsOneWidget);
  });
}
