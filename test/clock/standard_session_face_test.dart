import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiqlo_clock/clock/clock_engine.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/faces/standard/focus_sprite_assets.dart';
import 'package:flutter_tiqlo_clock/features/clock/widgets/faces/standard/standard_session_face.dart';

void main() {
  testWidgets('Standard Session uses the system font and reference layout', (
    tester,
  ) async {
    const session = SessionSnapshot(
      kind: SessionKind.focus,
      status: SessionStatus.paused,
      duration: Duration(minutes: 25),
      remaining: Duration(minutes: 12, seconds: 34),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StandardSessionFace(session: session, landscape: false),
        ),
      ),
    );

    final primary = tester.widget<Text>(
      find.byKey(const ValueKey('standard-session-primary-label')),
    );
    expect(primary.data, '12:34');
    expect(primary.style!.fontFamily, isNull);
    expect(find.text('FOCUS'), findsOneWidget);
    expect(find.text('PAUSED'), findsOneWidget);
    expect(
      _assetPath(tester, const ValueKey('standard-session-machine')),
      FocusSpriteAssets.machineReady,
    );
    expect(
      _assetPath(tester, const ValueKey('standard-session-progress')),
      FocusSpriteAssets.coffee50,
    );
    expect(
      tester.getSemantics(find.byType(StandardSessionFace)),
      matchesSemantics(label: '12:34, FOCUS, PAUSED'),
    );
  });

  testWidgets('Standard Session shows brewing and completion artwork', (
    tester,
  ) async {
    const running = SessionSnapshot(
      kind: SessionKind.timer,
      status: SessionStatus.running,
      duration: Duration(minutes: 20),
      remaining: Duration(minutes: 5),
    );
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StandardSessionFace(session: running, landscape: true),
        ),
      ),
    );

    expect(
      _assetPath(tester, const ValueKey('standard-session-machine')),
      FocusSpriteAssets.machineBrewing,
    );
    expect(
      _assetPath(tester, const ValueKey('standard-session-progress')),
      FocusSpriteAssets.coffee75,
    );

    const complete = SessionSnapshot(
      kind: SessionKind.timer,
      status: SessionStatus.complete,
      duration: Duration(minutes: 20),
      remaining: Duration.zero,
    );
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StandardSessionFace(session: complete, landscape: true),
        ),
      ),
    );

    expect(find.text('COMPLETE'), findsOneWidget);
    expect(
      _assetPath(tester, const ValueKey('standard-session-machine')),
      FocusSpriteAssets.machineComplete,
    );
    expect(
      _assetPath(tester, const ValueKey('standard-session-progress')),
      FocusSpriteAssets.coffeeCupSteam,
    );
  });
}

String _assetPath(WidgetTester tester, Key key) {
  return tester.widget<FocusSprite>(find.byKey(key)).asset;
}
