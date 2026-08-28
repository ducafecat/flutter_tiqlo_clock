import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/core/ui/app/app_sheet.dart';
import 'package:flutter_tiqlo_clock/core/ui/app/app_ui_style.dart';
import 'package:flutter_tiqlo_clock/core/ui/pixel/pixel_theme.dart';
import 'package:flutter_tiqlo_clock/core/ui/standard/standard_theme.dart';

void main() {
  testWidgets('Standard AppSheet closes when tapping the blank barrier', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: StandardTheme.darkTheme,
        builder: (context, child) => AppUiScope(
          style: AppUiStyle.standard,
          child: child ?? const SizedBox.shrink(),
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: FilledButton(
              onPressed: () => AppSheet.show<void>(
                context: context,
                builder: (_) =>
                    const SizedBox(height: 120, child: Text('Sheet content')),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Sheet content'), findsOneWidget);

    await tester.tapAt(const Offset(195, 100));
    await tester.pumpAndSettle();

    expect(find.text('Sheet content'), findsNothing);
  });

  testWidgets('Pixel AppSheet closes when tapping the blank barrier', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PixelTheme.darkTheme,
        builder: (context, child) => AppUiScope(
          style: AppUiStyle.pixel,
          child: child ?? const SizedBox.shrink(),
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: FilledButton(
              onPressed: () => AppSheet.show<void>(
                context: context,
                builder: (_) =>
                    const SizedBox(height: 120, child: Text('Sheet content')),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Sheet content'), findsOneWidget);

    await tester.tapAt(const Offset(4, 4));
    await tester.pumpAndSettle();

    expect(find.text('Sheet content'), findsNothing);
  });
}
