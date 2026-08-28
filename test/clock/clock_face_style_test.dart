import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/clock_theme.dart';
import 'package:flutter_tiqlo_clock/clock/digital_theme.dart';
import 'package:flutter_tiqlo_clock/clock/flip_palette.dart';
import 'package:flutter_tiqlo_clock/core/ui/app/app_ui_style.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/clock_face.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/faces/pixel/pixel_clock_face.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/faces/standard/standard_clock_face.dart';

void main() {
  const snapshot = ClockSnapshot(
    hour: 21,
    minute: 38,
    second: 42,
    dateLabel: 'FRI · AUG 28',
    showSeconds: true,
    showDate: true,
  );

  testWidgets('facade selects only the requested adapter', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ClockFace(
          style: AppUiStyle.pixel,
          themeId: ClockThemeId.flip,
          digitalThemeId: DigitalThemeId.digitalBlue,
          flipPaletteId: FlipPaletteId.orange,
          snapshot: snapshot,
          landscape: false,
        ),
      ),
    );

    expect(find.byType(PixelClockFace), findsOneWidget);
    expect(find.byType(StandardClockFace), findsNothing);

    await tester.pumpWidget(
      const MaterialApp(
        home: ClockFace(
          style: AppUiStyle.standard,
          themeId: ClockThemeId.flip,
          digitalThemeId: DigitalThemeId.digitalBlue,
          flipPaletteId: FlipPaletteId.orange,
          snapshot: snapshot,
          landscape: false,
        ),
      ),
    );

    expect(find.byType(PixelClockFace), findsNothing);
    final face = tester.widget<StandardClockFace>(
      find.byType(StandardClockFace),
    );
    expect(face.snapshot, same(snapshot));
    expect(face.themeId, ClockThemeId.flip);
    expect(face.digitalThemeId, DigitalThemeId.digitalBlue);
    expect(face.flipPaletteId, FlipPaletteId.orange);
  });
}
