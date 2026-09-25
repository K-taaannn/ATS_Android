import 'package:flutter_test/flutter_test.dart';
import 'package:ats_android/main.dart';

void main() {
  testWidgets('Birthday Countdown smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BirthdayCountdownApp());
    await tester.pump();

    // Verify that the title and key components are rendered.
    expect(find.text('Birthday Countdown'), findsOneWidget);
    expect(find.text('Daftar Pengingat'), findsOneWidget);
  });
}
