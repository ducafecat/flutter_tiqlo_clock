import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'clock_engine.dart';
import 'clock_settings_store.dart';
import 'session_alerts.dart';

class LocalSessionAlerts implements SessionAlerts {
  LocalSessionAlerts(this._store);

  static const _id = 1;
  static final _plugin = FlutterLocalNotificationsPlugin();
  static var _tzReady = false;

  final ClockSettingsStore _store;
  var _ready = false;

  @override
  Future<void> requestPermissionOnFirstStart() async {
    if (_store.loadNotificationAsked()) return;
    var granted = false;
    try {
      await _ensureReady();
      granted = await _requestPermission();
    } catch (_) {}
    _store.saveNotificationAsked(true);
    _store.saveNotificationGranted(granted);
  }

  @override
  Future<void> schedule(Duration remaining, SessionKind kind) async {
    if (remaining <= Duration.zero) return;
    if (!_store.loadNotificationGranted()) return;
    try {
      await _ensureReady();
      await _plugin.cancel(id: _id);
      final sound = _store.loadSoundEnabled();
      final vibration = _store.loadVibrationEnabled();
      await _plugin.zonedSchedule(
        id: _id,
        title: kind == SessionKind.focus ? 'FOCUS' : 'TIMER',
        body: 'Complete',
        scheduledDate: tz.TZDateTime.now(tz.UTC).add(remaining),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'session',
            'Session',
            channelDescription: 'Focus and Timer complete',
            importance: Importance.high,
            priority: Priority.high,
            playSound: sound,
            enableVibration: vibration,
          ),
          iOS: DarwinNotificationDetails(presentSound: sound),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (_) {}
  }

  @override
  Future<void> cancel() async {
    try {
      await _plugin.cancel(id: _id);
    } catch (_) {}
  }

  Future<void> _ensureReady() async {
    if (_ready) return;
    if (!_tzReady) {
      tzdata.initializeTimeZones();
      _tzReady = true;
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _ready = true;
  }

  Future<bool> _requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, sound: true) ?? false;
    }
    return true;
  }
}
