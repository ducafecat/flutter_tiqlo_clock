import 'package:flutter/widgets.dart';

abstract final class FocusSpriteAssets {
  static const root = 'assets/images/focus';

  static const machineReady = '$root/machine_ready.png';
  static const machineBrewing = '$root/machine_brewing.png';
  static const machineComplete = '$root/machine_complete.png';

  static const coffee00 = '$root/coffee_progress_00.png';
  static const coffee25 = '$root/coffee_progress_25.png';
  static const coffee50 = '$root/coffee_progress_50.png';
  static const coffee75 = '$root/coffee_progress_75.png';
  static const coffee100 = '$root/coffee_progress_100.png';

  static const coffeeCupSteam = '$root/coffee_cup_steam.png';
  static const tiqloWordmark = '$root/tiqlo_wordmark.png';

  static String coffeeProgress(double progress) {
    final normalized = progress.clamp(0.0, 1.0);
    if (normalized < 0.125) return coffee00;
    if (normalized < 0.375) return coffee25;
    if (normalized < 0.625) return coffee50;
    if (normalized < 0.875) return coffee75;
    return coffee100;
  }
}

class FocusSprite extends StatelessWidget {
  const FocusSprite(
    this.asset, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      filterQuality: FilterQuality.none,
      isAntiAlias: false,
      gaplessPlayback: true,
    );
  }
}
