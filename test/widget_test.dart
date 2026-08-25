import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/clock_providers.dart';
import 'package:flutter_tiqlo_clock/features/clock/pages/clock_page.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/flip_clock_face.dart';
import 'package:flutter_tiqlo_clock/features/splash/pages/splash_page.dart';
import 'package:flutter_tiqlo_clock/features/welcome/pages/welcome_page.dart';
import 'package:flutter_tiqlo_clock/main.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'clock/fake_clock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  testWidgets('returning user sees splash then clock', (tester) async {
    SharedPreferences.setMockInitialValues({'app.has_seen_welcome': true});
    final preferences = await SharedPreferences.getInstance();
    final engine = ClockEngine(
      clock: FakeClock(wall: DateTime(2026, 8, 20, 21, 38)),
      locale: const Locale('en'),
    );
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        clockEngineProvider.overrideWithValue(engine),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MyApp()),
    );

    expect(find.byType(SplashPage), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pumpAndSettle();

    expect(find.byType(ClockPage), findsOneWidget);
    expect(find.byType(FlipClockFace), findsOneWidget);
    expect(find.text('21'), findsNWidgets(2));
    expect(find.text('38'), findsNWidgets(2));
    expect(find.text('THU · AUG 20'), findsNothing);
    expect(find.text('Welcome'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('first launch completes welcome flow', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MyApp()),
    );
    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomePage), findsOneWidget);
    expect(find.text('翻页时钟，重新想象'), findsOneWidget);

    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();
    expect(find.text('一眼，看清时间'), findsOneWidget);

    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();
    expect(find.text('少些打扰，多些专注'), findsOneWidget);

    await tester.tap(find.text('开始使用'));
    await tester.pumpAndSettle();

    expect(find.byType(ClockPage), findsOneWidget);
    expect(preferences.getBool('app.has_seen_welcome'), isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });
}
