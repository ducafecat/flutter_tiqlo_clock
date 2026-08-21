import 'clock.dart';

class SystemClock implements Clock {
  final Stopwatch _elapsed = Stopwatch()..start();

  @override
  DateTime wallNow() => DateTime.now();

  @override
  Duration elapsed() => _elapsed.elapsed;
}
