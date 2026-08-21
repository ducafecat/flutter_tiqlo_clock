import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/clock_providers.dart';
import 'package:flutter_tiqlo_clock/features/clock/pages/clock_page.dart';
import 'package:flutter_tiqlo_clock/main.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'clock/fake_clock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  testWidgets('first frame is Clock with wall time', (tester) async {
    final engine = ClockEngine(
      clock: FakeClock(wall: DateTime(2026, 8, 20, 21, 38)),
      locale: const Locale('en'),
    );
    final container = ProviderContainer(
      overrides: [clockEngineProvider.overrideWithValue(engine)],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MyApp()),
    );

    expect(find.byType(ClockPage), findsOneWidget);
    expect(find.text('21:38'), findsOneWidget);
    expect(find.text('THU · AUG 20'), findsNothing);
    expect(find.text('Welcome'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });
}
