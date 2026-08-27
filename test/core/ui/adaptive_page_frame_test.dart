import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/core/ui/adaptive_page_frame.dart';

void main() {
  testWidgets('uses the portrait maximum width', (tester) async {
    tester.view.physicalSize = const Size(600, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    AdaptivePageLayout? layout;
    await tester.pumpWidget(
      _testApp(onLayout: (value) => layout = value, portraitMaxWidth: 426),
    );

    expect(layout!.isLandscape, isFalse);
    expect(layout!.contentWidth, 426);
    expect(tester.getSize(find.byKey(_contentKey)).width, 426);
  });

  testWidgets('uses the complete safe-area width in landscape', (tester) async {
    tester.view.physicalSize = const Size(1200, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    AdaptivePageLayout? layout;
    await tester.pumpWidget(
      _testApp(onLayout: (value) => layout = value, portraitMaxWidth: 426),
    );

    expect(layout!.isLandscape, isTrue);
    expect(layout!.contentWidth, 1200);
    expect(tester.getSize(find.byKey(_contentKey)).width, 1200);
  });
}

const _contentKey = ValueKey('adaptive-page-content');

Widget _testApp({
  required ValueChanged<AdaptivePageLayout> onLayout,
  required double portraitMaxWidth,
}) => MaterialApp(
  home: Scaffold(
    body: AdaptivePageFrame(
      portraitMaxWidth: portraitMaxWidth,
      builder: (context, layout) {
        onLayout(layout);
        return const ColoredBox(key: _contentKey, color: Colors.transparent);
      },
    ),
  ),
);
