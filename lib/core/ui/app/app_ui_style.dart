import 'package:flutter/widgets.dart';

enum AppUiStyle { pixel, standard }

class AppUiScope extends InheritedWidget {
  const AppUiScope({super.key, required this.style, required super.child});

  final AppUiStyle style;

  static AppUiStyle of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppUiScope>()?.style ??
        AppUiStyle.pixel;
  }

  @override
  bool updateShouldNotify(AppUiScope oldWidget) => style != oldWidget.style;
}
