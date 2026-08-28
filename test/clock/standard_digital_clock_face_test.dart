import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/digital_theme.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/faces/pixel/pixel_digital_clock_face.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/faces/standard/standard_digital_clock_face.dart';

void main() {
  testWidgets('Standard Digital owns DSEG7, seconds, date, and 1 correction', (
    tester,
  ) async {
    const snapshot = ClockSnapshot(
      hour: 10,
      minute: 20,
      dateLabel: 'FRI · AUG 28',
      showDate: true,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: StandardDigitalClockFace(
          snapshot: snapshot,
          landscape: false,
          theme: DigitalThemeId.digital.theme,
        ),
      ),
    );

    expect(find.byType(StandardDigitalClockFace), findsOneWidget);
    expect(find.byType(PixelDigitalClockFace), findsNothing);
    final time = tester.widget<Text>(
      find.byKey(const ValueKey('standard-digital-time')),
    );
    expect(time.data, '10:20');
    expect(time.style!.fontFamily, 'DSEG7Classic');
    final transform = tester.widget<Transform>(
      find.byKey(const ValueKey('standard-digital-time-optical-offset')),
    );
    expect(transform.transform.getTranslation().x, closeTo(-36.96, 0.001));
    expect(find.text('FRI · AUG 28'), findsOneWidget);
  });

  testWidgets('Standard Digital applies every DigitalTheme color', (
    tester,
  ) async {
    const snapshot = ClockSnapshot(
      hour: 20,
      minute: 28,
      second: 45,
      dateLabel: '',
      showSeconds: true,
    );
    for (final id in DigitalThemeId.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: StandardDigitalClockFace(
            snapshot: snapshot,
            landscape: true,
            theme: id.theme,
          ),
        ),
      );
      final time = tester.widget<Text>(
        find.byKey(const ValueKey('standard-digital-time')),
      );
      expect(time.data, '20:28:45');
      expect(time.style!.color, id.theme.digit);
    }
  });
}
