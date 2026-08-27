abstract final class AppConfig {
  static const appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Tiqlo',
  );

  static const version = '1.0.0';

  static const buildNumber = '1';

  static const ui = UiConfig(designWidth: 390, designHeight: 844);
}

class UiConfig {
  const UiConfig({required this.designWidth, required this.designHeight});

  final double designWidth;
  final double designHeight;
}
