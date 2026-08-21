import 'clock.dart';

class SystemClock implements Clock {
  SystemClock({this._bootElapsed = Duration.zero});

  final Duration _bootElapsed;
  final Stopwatch _stopwatch = Stopwatch()..start();

  @override
  DateTime wallNow() => DateTime.now();

  @override
  Duration elapsed() => _bootElapsed + _stopwatch.elapsed;
}
