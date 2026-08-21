import 'clock_engine.dart';

abstract class SessionAlerts {
  Future<void> requestPermissionOnFirstStart();
  Future<void> schedule(Duration remaining, SessionKind kind);
  Future<void> cancel();
}

class SilentSessionAlerts implements SessionAlerts {
  const SilentSessionAlerts();

  @override
  Future<void> requestPermissionOnFirstStart() async {}

  @override
  Future<void> schedule(Duration remaining, SessionKind kind) async {}

  @override
  Future<void> cancel() async {}
}
