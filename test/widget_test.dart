import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:delivery_partner_app/main.dart';

void main() {
  testWidgets('App should render login page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: DeliveryPartnerApp()));

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify the login page loads with expected elements
    expect(find.text('Delivery Partner'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
