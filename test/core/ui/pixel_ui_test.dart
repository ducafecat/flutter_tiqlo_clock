import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/core/ui/pixel/pixel_theme_sheet_style.dart';
import 'package:flutter_tiqlo_clock/core/ui/ui.dart';

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

  testWidgets('PixelSwitch uses the Settings 64 by 40 control geometry', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        home: const Scaffold(
          body: PixelSwitch(
            label: 'Show Seconds',
            value: false,
            onChanged: null,
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(const ValueKey('pixel-switch-control'))),
      const Size(64, 40),
    );
  });

  testWidgets('PixelSwitch compact mode aligns with sheet action rows', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        home: const Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: PixelSwitch(
              label: 'Night Mode',
              value: false,
              onChanged: null,
              compact: true,
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(PixelSwitch)).height, 48);
    expect(
      tester.getSize(find.byKey(const ValueKey('pixel-switch-control'))),
      const Size(64, 40),
    );
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
    expect(tokens.chromeHighlight, const Color(0xFF1A1916));
    expect(tokens.accent, const Color(0xFFED780C));
    expect(PixelTheme.darkTheme.colorScheme.primary, tokens.accent);
    expect(PixelTheme.darkTheme.colorScheme.surface, tokens.surface);
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

  testWidgets('PixelPageScaffold supplies the shared page shell', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    var backed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        home: PixelPageScaffold(
          title: 'Details',
          portraitMaxWidth: 426,
          onBack: () => backed = true,
          builder: (context, layout) =>
              Text(layout.isLandscape ? 'Landscape body' : 'Portrait body'),
        ),
      ),
    );

    expect(find.text('Details'), findsOneWidget);
    expect(find.text('Portrait body'), findsOneWidget);
    expect(find.byType(AdaptivePageFrame), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Back'));
    expect(backed, isTrue);
  });

  testWidgets('Pixel content rows share semantics and interaction styling', (
    tester,
  ) async {
    var opened = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        home: Scaffold(
          body: PixelSection(
            title: 'Project',
            showDividers: false,
            children: [
              const PixelInfoRow(label: 'Version', value: '1.0.0'),
              PixelLinkTile(
                label: 'Website',
                value: 'https://example.com',
                onPressed: () => opened = true,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('PROJECT'), findsOneWidget);
    expect(find.text('1.0.0'), findsOneWidget);
    final link = find.bySemanticsLabel('Website: https://example.com');
    expect(link, findsOneWidget);
    await tester.tap(link);
    expect(opened, isTrue);
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

  testWidgets(
    'PixelToolbar uses full-width stacked actions on portrait phones',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(393, 852);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: PixelTheme.darkTheme,
          home: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: PixelToolbar(
                actions: [
                  PixelToolbarAction(label: 'Theme', onPressed: () {}),
                  PixelToolbarAction(label: 'More', onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
      );

      final themeRect = tester.getRect(find.bySemanticsLabel('Theme'));
      final moreRect = tester.getRect(find.bySemanticsLabel('More'));
      expect(themeRect, const Rect.fromLTWH(8, 732, 377, 56));
      expect(moreRect, const Rect.fromLTWH(8, 796, 377, 56));
      expect(
        find.descendant(
          of: find.byType(PixelToolbar),
          matching: find.byType(PixelPanel),
        ),
        findsNWidgets(2),
      );

      tester.binding.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(
        tester.binding.platformDispatcher.clearTextScaleFactorTestValue,
      );
      await tester.pump();
      expect(
        tester.getSize(find.bySemanticsLabel('Theme')).height,
        greaterThan(56),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('PixelToolbar has no enclosing frame in landscape', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(852, 393);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: PixelToolbar(
              actions: [
                PixelToolbarAction(label: 'Theme', onPressed: () {}),
                PixelToolbarAction(label: 'More', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.byType(PixelPanel), findsNWidgets(2));
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

  testWidgets('all PixelSheet layouts share the Theme chrome', (tester) async {
    Future<void> pumpSheet(PixelSheetLayout layout) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: PixelTheme.darkTheme,
          home: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: PixelSheet(
                layout: layout,
                child: const SizedBox(height: 80, child: Text('Content')),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    await pumpSheet(PixelSheetLayout.content);
    expect(find.byType(PixelThemeSheetFrame), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const ValueKey('pixel-theme-drag-handle'))),
      const Size(44, 8),
    );

    await pumpSheet(PixelSheetLayout.theme);
    expect(find.byType(PixelThemeSheetFrame), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const ValueKey('pixel-theme-drag-handle'))),
      const Size(44, 8),
    );
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
  testWidgets('PixelPageIndicator announces its current page', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PixelPageIndicator(pageCount: 3, currentPage: 1)),
      ),
    );

    expect(
      tester.getSemantics(find.byType(PixelPageIndicator)),
      matchesSemantics(label: '第 2 页，共 3 页'),
    );
  });
}
