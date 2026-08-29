import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/core/ui/standard/standard_ui.dart';

void main() {
  test('StandardTheme exposes the documented dark design tokens', () {
    final theme = StandardTheme.darkTheme;

    expect(theme.useMaterial3, isTrue);
    expect(theme.scaffoldBackgroundColor, StandardColors.darkBackground);
    expect(theme.colorScheme.surface, StandardColors.darkCard);
    expect(theme.colorScheme.onSurface, StandardColors.darkCardForeground);
    expect(theme.colorScheme.primary, StandardColors.darkPrimary);
    expect(theme.colorScheme.outline, StandardColors.darkBorder);

    final cardShape = theme.cardTheme.shape! as RoundedRectangleBorder;
    expect(cardShape.borderRadius, StandardRadius.card);
    expect(cardShape.side.color, StandardColors.darkBorder);

    final elevatedStyle = theme.elevatedButtonTheme.style!;
    expect(
      elevatedStyle.minimumSize!.resolve(<WidgetState>{}),
      const Size(0, 40),
    );
    expect(
      elevatedStyle.padding!.resolve(<WidgetState>{}),
      const EdgeInsets.symmetric(horizontal: StandardSpacing.md),
    );
  });

  testWidgets('StandardSection owns its header, frame and dividers', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _StandardHost(
        child: StandardSection(
          title: 'Time & Date',
          children: [
            StandardSettingsTile(label: '24 Hour', onTap: () => taps++),
            const StandardSettingsTile(label: 'Show Seconds'),
          ],
        ),
      ),
    );

    expect(find.text('TIME & DATE'), findsOneWidget);
    expect(find.byType(StandardSettingsGroup), findsOneWidget);

    await tester.tap(find.text('24 Hour'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('Standard selection and color options expose one tap interface', (
    tester,
  ) async {
    var selectionTaps = 0;
    var colorTaps = 0;
    await tester.pumpWidget(
      _StandardHost(
        child: Column(
          children: [
            StandardSelectionTile(
              label: 'Flip',
              selected: true,
              onSelected: () => selectionTaps++,
            ),
            StandardColorOption(
              label: 'Blue',
              colors: const [Color(0xFF07111F), Color(0xFF2563EB)],
              selected: true,
              onSelected: () => colorTaps++,
              minWidth: 0,
            ),
          ],
        ),
      ),
    );

    expect(find.byIcon(Icons.check), findsWidgets);
    await tester.tap(find.text('Flip'));
    await tester.tap(find.text('Blue'));
    await tester.pump();

    expect(selectionTaps, 1);
    expect(colorTaps, 1);
  });

  testWidgets('StandardToolbar owns the Clock chrome presentation', (
    tester,
  ) async {
    await tester.pumpWidget(
      _StandardHost(
        child: StandardToolbar(
          actions: const [
            StandardToolbarAction(label: 'Theme', onPressed: null),
            StandardToolbarAction(label: 'More', onPressed: null),
          ],
        ),
      ),
    );

    final material = tester.widget<Material>(
      find
          .descendant(
            of: find.byType(StandardToolbar),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(material.color, StandardColors.clockChrome);
    expect(material.elevation, 16);
    expect(material.shape, isA<StadiumBorder>());
    expect(
      find.descendant(
        of: find.byType(StandardToolbar),
        matching: find.byType(TextButton),
      ),
      findsNWidgets(2),
    );
  });
}

class _StandardHost extends StatelessWidget {
  const _StandardHost({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: StandardTheme.darkTheme,
      home: Scaffold(body: Center(child: child)),
    );
  }
}
