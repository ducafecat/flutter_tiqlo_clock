import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/core/ui/pixel/pixel_ui.dart';

void main() {
  testWidgets('PixelSwitch exposes one toggleable semantic node', (
    tester,
  ) async {
    var enabled = true;

    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        home: Scaffold(
          body: PixelPanel(
            child: PixelSwitch(
              label: 'Night Mode',
              value: enabled,
              onChanged: (value) => enabled = value,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(PixelPanel), findsOneWidget);
    expect(
      tester.getSemantics(find.byType(PixelSwitch)),
      matchesSemantics(
        label: 'Night Mode',
        hasEnabledState: true,
        isEnabled: true,
        hasCheckedState: true,
        isChecked: true,
        hasTapAction: true,
      ),
    );

    await tester.tap(find.byType(PixelSwitch));
    await tester.pump();

    expect(enabled, isFalse);
  });

  testWidgets('PixelTheme provides fixed semantic tokens', (tester) async {
    late PixelTokens tokens;

    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        home: Builder(
          builder: (context) {
            tokens = PixelTokens.of(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(tokens.background, const Color(0xFF000000));
    expect(tokens.chrome, const Color(0xFF171612));
    expect(tokens.accent, const Color(0xFFED780C));
  });

  testWidgets('PixelButton exposes its label and invokes its callback', (
    tester,
  ) async {
    var presses = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        home: Scaffold(
          body: PixelButton(label: 'Save', onPressed: () => presses++),
        ),
      ),
    );

    final button = find.bySemanticsLabel('Save');
    expect(button, findsOneWidget);
    expect(
      tester.getSemantics(button),
      matchesSemantics(
        label: 'Save',
        hasEnabledState: true,
        isEnabled: true,
        isButton: true,
        hasTapAction: true,
      ),
    );

    await tester.tap(button);
    expect(presses, 1);
  });
}
