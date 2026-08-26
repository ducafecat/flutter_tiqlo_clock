import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  testWidgets('PixelActionTile exposes one button and invokes its action', (
    tester,
  ) async {
    var presses = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        home: Scaffold(
          body: PixelActionTile(label: 'Settings', onPressed: () => presses++),
        ),
      ),
    );

    final tile = find.bySemanticsLabel('Settings');
    expect(tile, findsOneWidget);
    expect(
      tester.getSemantics(tile),
      matchesSemantics(
        label: 'Settings',
        hasEnabledState: true,
        isEnabled: true,
        isButton: true,
        hasTapAction: true,
      ),
    );

    await tester.tap(tile);
    expect(presses, 1);
  });

  testWidgets('PixelSelectionTile exposes selected state without color alone', (
    tester,
  ) async {
    var selected = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        home: Scaffold(
          body: PixelSelectionTile(
            label: 'Digital',
            selected: selected,
            onSelected: () => selected = true,
          ),
        ),
      ),
    );

    final tile = find.bySemanticsLabel('Digital');
    expect(
      tester.getSemantics(tile),
      matchesSemantics(
        label: 'Digital',
        hasEnabledState: true,
        isEnabled: true,
        hasSelectedState: true,
        isSelected: false,
        isButton: true,
        hasTapAction: true,
      ),
    );

    await tester.tap(tile);
    expect(selected, isTrue);
  });

  testWidgets('PixelColorOption is at least 144dp and exposes its selection', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        home: const Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: PixelColorOption(
              label: 'Purple',
              colors: [Colors.purple, Colors.white],
              selected: true,
              onSelected: null,
            ),
          ),
        ),
      ),
    );

    final option = find.bySemanticsLabel('Purple');
    expect(
      tester.getSize(find.byType(PixelColorOption)).width,
      greaterThanOrEqualTo(144),
    );
    expect(
      tester.getSemantics(option),
      matchesSemantics(
        label: 'Purple',
        hasEnabledState: true,
        isEnabled: false,
        hasSelectedState: true,
        isSelected: true,
        isButton: true,
      ),
    );
  });

  testWidgets('PixelToolbar exposes semantic actions supplied by the page', (
    tester,
  ) async {
    var stopped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        home: Scaffold(
          body: PixelToolbar(
            actions: [
              PixelToolbarAction(label: 'Pause', onPressed: () {}),
              PixelToolbarAction(
                label: 'Stop',
                tone: PixelButtonTone.danger,
                onPressed: () => stopped = true,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Pause'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Stop'));
    expect(stopped, isTrue);
  });

  testWidgets('PixelSheet closes with Escape and restores trigger focus', (
    tester,
  ) async {
    final triggerFocus = FocusNode();
    addTearDown(triggerFocus.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        home: Builder(
          builder: (context) => Scaffold(
            body: PixelButton(
              label: 'Open',
              focusNode: triggerFocus,
              onPressed: () => PixelSheet.show<void>(
                context: context,
                restoreFocus: triggerFocus,
                builder: (_) => const Text('Sheet content'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Sheet content'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('Sheet content'), findsNothing);
    expect(triggerFocus.hasFocus, isTrue);
  });

  testWidgets('PixelSheet closes from the barrier and a downward drag', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        home: Builder(
          builder: (context) => Scaffold(
            body: PixelButton(
              label: 'Open',
              onPressed: () => PixelSheet.show<void>(
                context: context,
                builder: (_) =>
                    const SizedBox(height: 120, child: Text('Sheet content')),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Open'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(4, 4));
    await tester.pumpAndSettle();
    expect(find.text('Sheet content'), findsNothing);

    await tester.tap(find.bySemanticsLabel('Open'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PixelSheet), const Offset(0, 500));
    await tester.pumpAndSettle();
    expect(find.text('Sheet content'), findsNothing);
  });

  testWidgets('PixelSheet keeps Tab focus inside the sheet', (tester) async {
    final firstFocus = FocusNode();
    final secondFocus = FocusNode();
    addTearDown(firstFocus.dispose);
    addTearDown(secondFocus.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        home: Builder(
          builder: (context) => Scaffold(
            body: PixelButton(
              label: 'Open',
              onPressed: () => PixelSheet.show<void>(
                context: context,
                builder: (_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PixelButton(
                      label: 'First',
                      focusNode: firstFocus,
                      onPressed: () {},
                    ),
                    PixelButton(
                      label: 'Second',
                      focusNode: secondFocus,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Open'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(firstFocus.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(secondFocus.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(firstFocus.hasFocus, isTrue);
  });
}
