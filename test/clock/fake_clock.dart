import 'package:flutter_tiqlo_clock/clock/clock.dart';

class FakeClock implements Clock {
  FakeClock({required this.wall, this.monotonic = Duration.zero});

  DateTime wall;
  Duration monotonic;

  @override
  DateTime wallNow() => wall;

  @override
  Duration elapsed() => monotonic;

  void advanceWall(Duration duration) {
    wall = wall.add(duration);
  }

  void advanceElapsed(Duration duration) {
    monotonic += duration;
  }
}
