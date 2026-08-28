import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/digital_theme.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/faces/pixel/pixel_digital_clock_face.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/faces/standard/standard_digital_clock_face.dart';

void main() {
  testWidgets('Pixel Digital keeps the pixel font and neutral alignment', (
    tester,
  ) async {
    const snapshot = ClockSnapshot(
      hour: 11,
      minute: 21,
      second: 31,
      dateLabel: 'FRI · AUG 28',
      showSeconds: true,
      showDate: true,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: PixelDigitalClockFace(
          snapshot: snapshot,
          landscape: true,
          theme: DigitalThemeId.digitalBlue.theme,
        ),
      ),
    );

    expect(find.byType(PixelDigitalClockFace), findsOneWidget);
    expect(find.byType(StandardDigitalClockFace), findsNothing);
    final time = tester.widget<Text>(
      find.byKey(const ValueKey('digital-time')),
    );
    expect(time.data, '11:21:31');
    expect(time.style!.fontFamily, 'DotGothic16');
    final transform = tester.widget<Transform>(
      find.byKey(const ValueKey('digital-time-optical-offset')),
    );
    expect(transform.transform.getTranslation().x, 0);
  });
}
