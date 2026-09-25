可以。既然 SVG 实际跑出来不理想，我建议 Tiqlo 的 **Bubble Clock 主题正式改成「字体 + 独立冒号 + 独立数字配色」方案**。这样实现简单、字形稳定，而且后面换字体只需要替换字体文件，不用维护 0~9 十几个 SVG。

# Tiqlo — Bubble Clock 主题 Flutter 技术说明

## 1. 实现目标

在 Tiqlo 当前 Clock 中增加：

```text
Theme: Bubble Clock
ID: bubble
```

目标视觉参考 iOS StandBy 的数字时钟：

```text
52 : 22
```

但技术上不要：

```dart
Text('52:22')
```

而是拆成：

```text
5
2
:
2
2
```

或者至少：

```text
52
:
22
```

这样才能分别控制颜色、间距、重叠和动画。

---

# 2. 最终技术路线

推荐结构：

```text
Bubble Clock
     │
     ├── Font
     │     └── Fredoka Bold
     │
     ├── Hour Digits
     │
     ├── Bubble Colon
     │     ├── ●
     │     └── ●
     │
     ├── Minute Digits
     │
     └── Color Palette
```

正式版建议：

> **数字用字体，冒号用 Flutter 圆形绘制。**

不再使用 SVG。

---

# 3. 字体选择

第一推荐：

```text
Fredoka Bold
```

建议 Weight：

```text
600 / 700
```

优先测试：

```text
Fredoka SemiBold
Fredoka Bold
```

我更建议最终：

```text
Fredoka Bold
```

原因是 Bubble Clock 大字号下需要足够饱满。

如果 Fredoka 真机效果还不满意，再依次测试：

```text
M PLUS Rounded 1c ExtraBold
Baloo 2 ExtraBold
Nunito ExtraBold
```

不要一次支持很多字体。

Bubble Clock 最终固定一套即可。

---

# 4. 字体不要在线加载

不要正式版直接：

```dart
GoogleFonts.fredoka()
```

建议下载字体后放入项目。

目录：

```text
assets/
└── fonts/
    └── bubble/
        ├── Fredoka-SemiBold.ttf
        └── Fredoka-Bold.ttf
```

`pubspec.yaml`：

```yaml
flutter:
  fonts:
    - family: BubbleClock
      fonts:
        - asset: assets/fonts/bubble/Fredoka-SemiBold.ttf
          weight: 600

        - asset: assets/fonts/bubble/Fredoka-Bold.ttf
          weight: 700
```

Flutter：

```dart
const TextStyle(
  fontFamily: 'BubbleClock',
  fontWeight: FontWeight.w700,
)
```

这样：

```text
iOS
Android
Web
macOS
Windows
```

都能保持基本一致。

---

# 5. 不要直接 Text("52:22")

不要：

```dart
Text(
  '52:22',
)
```

建议：

```dart
Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    BubbleDigit(...),
    BubbleDigit(...),

    BubbleColon(...),

    BubbleDigit(...),
    BubbleDigit(...),
  ],
)
```

最终 Widget Tree：

```text
BubbleClockView
        │
        └── BubbleTimeDisplay
                 │
                 ├── BubbleDigit H1
                 ├── BubbleDigit H2
                 │
                 ├── BubbleColon
                 │
                 ├── BubbleDigit M1
                 └── BubbleDigit M2
```

这是整个主题最重要的结构。

---

# 6. BubbleDigit

推荐：

```dart
class BubbleDigit extends StatelessWidget {
  const BubbleDigit({
    super.key,
    required this.value,
    required this.color,
    required this.fontSize,
  });

  final String value;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        fontFamily: 'BubbleClock',
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        height: 0.82,
        color: color,
      ),
    );
  }
}
```

这里：

```dart
height: 0.82
```

非常重要。

大字号字体默认 lineHeight 通常上下留白很多。

Bubble Clock 要尽量贴合实际字形。

实际可以测试：

```text
0.80
0.82
0.85
0.88
```

最终真机确定。

---

# 7. 冒号不要使用字体

不要：

```dart
Text(':')
```

自己画：

```dart
class BubbleColon extends StatelessWidget {
  const BubbleColon({
    super.key,
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 3.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _dot(),
          _dot(),
        ],
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
```

参考比例：

```text
数字高度：200
冒号直径：30~36
```

建议：

```dart
colonSize = fontSize * 0.15;
```

第一版从：

```dart
fontSize * 0.16
```

开始。

---

# 8. 时间拆分

例如：

```dart
final now = DateTime.now();

final hour = now.hour
    .toString()
    .padLeft(2, '0');

final minute = now.minute
    .toString()
    .padLeft(2, '0');
```

拆：

```dart
final h1 = hour[0];
final h2 = hour[1];

final m1 = minute[0];
final m2 = minute[1];
```

然后：

```dart
BubbleTimeDisplay(
  h1: h1,
  h2: h2,
  m1: m1,
  m2: m2,
)
```

---

# 9. 时间布局

推荐：

```dart
class BubbleTimeDisplay extends StatelessWidget {
  const BubbleTimeDisplay({
    super.key,
    required this.hour,
    required this.minute,
    required this.palette,
    required this.fontSize,
  });

  final String hour;
  final String minute;
  final BubblePalette palette;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final colonSize = fontSize * 0.15;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BubbleDigit(
          value: hour[0],
          color: palette.digit1,
          fontSize: fontSize,
        ),

        BubbleDigit(
          value: hour[1],
          color: palette.digit2,
          fontSize: fontSize,
        ),

        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: fontSize * 0.02,
          ),
          child: BubbleColon(
            color: palette.colon,
            size: colonSize,
          ),
        ),

        BubbleDigit(
          value: minute[0],
          color: palette.digit3,
          fontSize: fontSize,
        ),

        BubbleDigit(
          value: minute[1],
          color: palette.digit4,
          fontSize: fontSize,
        ),
      ],
    );
  }
}
```

---

# 10. 数字重叠

你前面运行出来难看的另一个重要原因就是：

> 数字重叠太多。

iOS StandBy 的感觉不是：

```text
数字压数字 20%
```

而是：

```text
紧凑
+
轻微视觉接触
```

建议第一版：

```dart
digitOverlap = fontSize * 0.02;
```

最多：

```dart
fontSize * 0.04
```

比如：

```text
fontSize = 200

overlap ≈ 4~8px
```

不要搞成：

```text
-30
-40
-50px
```

那样 `21`、`20`、`14` 都会变得很难看。

---

# 11. 不推荐直接使用 letterSpacing

类似：

```dart
Text(
  '52',
  style: TextStyle(
    letterSpacing: -20,
  ),
)
```

控制力不够。

建议数字独立：

```dart
Transform.translate(
  offset: Offset(-overlap, 0),
  child: BubbleDigit(...),
)
```

例如：

```dart
Row(
  children: [
    digit1,

    Transform.translate(
      offset: Offset(
        -fontSize * 0.025,
        0,
      ),
      child: digit2,
    ),
  ],
)
```

后面甚至可以针对不同组合调整：

```text
12
20
21
49
52
```

---

# 12. 更高级：Digit Kerning

如果追求接近 Apple，可以定义：

```dart
double bubbleKerning(
  String left,
  String right,
) {
  final pair = '$left$right';

  return switch (pair) {
    '12' => -0.025,
    '20' => -0.035,
    '21' => -0.020,
    '22' => -0.040,
    '49' => -0.025,
    '52' => -0.035,
    _ => -0.015,
  };
}
```

然后：

```dart
offsetX =
    fontSize *
    bubbleKerning(left, right);
```

这个办法比强行统一负间距好很多。

尤其：

```text
1
```

天然窄。

而：

```text
0
8
```

天然宽。

不同组合本来就应该不同 spacing。

---

# 13. Color Palette

数据模型：

```dart
class BubblePalette {
  const BubblePalette({
    required this.id,
    required this.background,
    required this.digit1,
    required this.digit2,
    required this.digit3,
    required this.digit4,
    required this.colon,
  });

  final String id;

  final Color background;

  final Color digit1;
  final Color digit2;
  final Color digit3;
  final Color digit4;

  final Color colon;
}
```

这样才能做出你参考图里的：

```text
5    蓝
2    深蓝

2    蓝
2    浅蓝

:    灰白
```

而不是：

```text
小时一个颜色
分钟一个颜色
```

---

# 14. 推荐 Green 配色

例如：

```dart
const BubblePalette greenPalette =
    BubblePalette(
  id: 'green',

  background: Color(0xFF020A07),

  digit1: Color(0xFF67C637),
  digit2: Color(0xFF00A875),

  digit3: Color(0xFF008F74),
  digit4: Color(0xFF67C637),

  colon: Color(0xFFE8B3DB),
);
```

Blue：

```dart
const BubblePalette bluePalette =
    BubblePalette(
  id: 'blue',

  background: Color(0xFF02060A),

  digit1: Color(0xFF5CA8F6),
  digit2: Color(0xFF1265C8),

  digit3: Color(0xFF1664C5),
  digit4: Color(0xFF5CA8F6),

  colon: Color(0xFFD5D7DB),
);
```

这些颜色先作为初始值，最终以真机调色为准。

---

# 15. 响应式字号

不要：

```dart
fontSize: 250
```

固定死。

使用：

```dart
LayoutBuilder(
  builder: (
    context,
    constraints,
  ) {
    final landscape =
        constraints.maxWidth >
        constraints.maxHeight;

    final fontSize = landscape
        ? constraints.maxHeight * 0.72
        : constraints.maxWidth * 0.25;

    return BubbleTimeDisplay(
      fontSize: fontSize,
      ...
    );
  },
)
```

横屏可以先尝试：

```text
fontSize =
screenHeight × 0.70
```

然后根据真机：

```text
0.65~0.78
```

微调。

---

# 16. 再套一层 FittedBox

推荐：

```dart
Center(
  child: Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 24,
    ),
    child: FittedBox(
      fit: BoxFit.contain,
      child: BubbleTimeDisplay(...),
    ),
  ),
)
```

这样即使：

```text
11:11
```

和：

```text
88:88
```

宽度差很大，也不会溢出。

---

# 17. 数字切换动画

不要每分钟整个：

```text
52:22
```

重新动画。

应该：

```text
只动画真正变化的数字
```

比如：

```text
52:22
↓
52:23
```

只让最后一位变化。

`BubbleDigit`：

```dart
AnimatedSwitcher(
  duration: const Duration(
    milliseconds: 280,
  ),
  switchInCurve:
      Curves.easeOutCubic,
  switchOutCurve:
      Curves.easeInCubic,
  transitionBuilder: (
    child,
    animation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 0.94,
          end: 1.0,
        ).animate(animation),
        child: child,
      ),
    );
  },
  child: Text(
    value,
    key: ValueKey(value),
    style: ...,
  ),
)
```

效果：

```text
2
↓
3

Fade
+
非常轻微 Scale
```

不要 Flip。

---

# 18. Timer

因为：

```text
HH:mm
```

只显示分钟。

实际上完全没必要：

```dart
Timer.periodic(
  const Duration(seconds: 1),
)
```

建议对齐分钟：

```dart
void scheduleNextMinute() {
  final now = DateTime.now();

  final next = DateTime(
    now.year,
    now.month,
    now.day,
    now.hour,
    now.minute + 1,
  );

  Timer(
    next.difference(now),
    () {
      updateClock();
      scheduleNextMinute();
    },
  );
}
```

这样长期放桌面上更合理。

---

# 19. Riverpod

Tiqlo 本身使用 Riverpod，可以继续沿用。

建议：

```text
bubbleClockProvider

负责：

currentTime
palette
24Hour
animation
```

但时间最好单独：

```text
clockTimeProvider
```

设置：

```text
bubbleSettingsProvider
```

不要让每一分钟更新时间导致整个设置树重建。

---

# 20. Setting Model

```dart
class BubbleClockSettings {
  const BubbleClockSettings({
    required this.paletteId,
    required this.use24Hour,
    required this.animationEnabled,
  });

  final String paletteId;

  final bool use24Hour;

  final bool animationEnabled;
}
```

保存：

```text
clock.theme = bubble
bubble.palette = blue
bubble.24hour = true
bubble.animation = true
```

---

# 21. Color Picker

颜色选择器继续按之前设计：

```text
           Color

● ● ● ● ● ● ◐ ◐
```

每次点击：

```text
选择 Palette
     ↓
更新 Provider
     ↓
Clock ColorTween
     ↓
写本地配置
```

颜色变化建议：

```text
220~280ms
```

---

# 22. 页面目录

推荐：

```text
lib/
└── features/
    └── clock/
        └── themes/
            └── bubble/
                ├── bubble_clock_view.dart
                ├── bubble_time_display.dart
                ├── bubble_digit.dart
                ├── bubble_colon.dart
                │
                ├── bubble_palette.dart
                ├── bubble_palettes.dart
                ├── bubble_settings.dart
                │
                ├── bubble_color_panel.dart
                ├── bubble_color_item.dart
                │
                └── bubble_kerning.dart
```

字体：

```text
assets/
└── fonts/
    └── bubble/
        └── Fredoka-Bold.ttf
```

---

# 23. 最终完整 Widget 结构

```text
BubbleClockView
│
├── Background
│
└── Center
    │
    └── FittedBox
        │
        └── BubbleTimeDisplay
            │
            ├── BubbleDigit H1
            │
            ├── BubbleDigit H2
            │
            ├── BubbleColon
            │   ├── Dot
            │   └── Dot
            │
            ├── BubbleDigit M1
            │
            └── BubbleDigit M2
```

---

# 24. Flutter 工程师实施顺序

建议就按下面顺序执行：

1. 引入 `Fredoka Bold`
2. 删除 Bubble Clock SVG 数字依赖
3. 建立 `BubbleDigit`
4. 建立 `BubbleColon`
5. 拆分 `HH:mm`
6. 每个 Digit 独立颜色
7. 用 `FittedBox` 完成横屏响应式
8. 调整 font height
9. 调整数字间距
10. 增加 Pair Kerning
11. 实现 Palette
12. 实现 Color Picker
13. 实现数字 AnimatedSwitcher
14. 最后真机微调

这里最值得花时间的不是动画，而是这三个参数：

```text
fontSize
digitSpacing / kerning
colonSize
```

这三个调好了，视觉上就会立刻提升很多。

---

## MVP 参数建议

可以先让工程师直接使用：

```dart
fontWeight = FontWeight.w700;

textHeight = 0.84;

digitOverlap =
    fontSize * 0.025;

colonSize =
    fontSize * 0.15;

colonHorizontalGap =
    fontSize * 0.025;

animationDuration =
    280ms;
```

然后拿：

```text
11:11
20:04
21:14
52:22
58:08
88:88
```

这几组时间专门做 UI 测试。

尤其一定要测试：

```text
21:14
```

因为你前面的截图已经证明：

> `1` 和 `4` 是最容易把整个布局搞难看的两个数字。

这次采用字体之后，**不要再针对单个数字手工修 SVG**，先把 Fredoka / M PLUS Rounded 在真机上各跑一遍。我会优先从 **Fredoka Bold** 开始，因为对 Tiqlo 这种 Bubble Clock 来说，它的工程稳定性和跨平台一致性比手工 SVG 高很多。
