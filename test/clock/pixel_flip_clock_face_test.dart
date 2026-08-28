import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/clock/flip_palette.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/faces/pixel/pixel_flip_clock_face.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/faces/standard/standard_flip_clock_face.dart';

void main() {
  testWidgets('Pixel Flip owns its cards and accessibility semantics', (
    tester,
  ) async {
    const snapshot = ClockSnapshot(
      hour: 9,
      minute: 41,
      second: 12,
      period: 'AM',
      dateLabel: 'FRI · AUG 28',
      showSeconds: true,
      showDate: true,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: PixelFlipClockFace(
          snapshot: snapshot,
          landscape: false,
          palette: FlipPaletteId.purple.palette,
        ),
      ),
    );

    expect(find.byType(PixelFlipClockFace), findsOneWidget);
    expect(find.byType(StandardFlipClockFace), findsNothing);
    expect(find.byKey(const ValueKey('flip-card-stack')), findsNWidgets(3));
    expect(find.text('AM'), findsOneWidget);
    expect(find.text('FRI · AUG 28'), findsOneWidget);
    expect(
      tester.getSemantics(find.byType(PixelFlipClockFace)),
      matchesSemantics(label: snapshot.timeLabel),
    );
  });
}
