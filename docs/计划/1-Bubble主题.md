可以。这次按你的真实目标重新定义：**不是做一个“类似 Bubble Clock”的主题，而是在 Tiqlo 里实现一套接近 iPhone StandBy Digital Clock 的数字时钟体验**。

技术上我建议不要依赖某个 Rounded 字体去“碰运气”，而是把 **0–9 数字和冒号当成 Tiqlo 自己的矢量字形系统** 来实现。这样 Flutter 在 iOS、Android、Web、Desktop 上都能保持一致，也最容易把你截图里的 `2 / 3 / 5` 这些特殊造型调到接近目标效果。

# Tiqlo StandBy Digital Clock 技术方案

## 1. 最终目标

在 Tiqlo 当前 Clock 中新增主题：

```dart
enum ClockThemeType {
  defaultClock,
  pixel,
  standbyDigital,
}
```

视觉目标：

```text
┌──────────────────────────────────────────┐
│                                          │
│             5 ● 3 2                      │
│               ●                          │
│                                          │
└──────────────────────────────────────────┘
```

实际需要实现：

- 超大圆润数字
- 数字笔画粗
- 极大的圆角
- `:` 为两个独立圆形
- 小时/分钟甚至每个数字都可以独立着色
- 深色背景
- 多套预设配色
- 配色即时切换
- 横屏优先
- Portrait 也正常显示
- 分钟切换有动画
- 用户选择自动保存

主题命名建议：

```text
Standby Digital
```

代码 ID：

```text
standby_digital
```

---

# 2. 最关键的技术决策

**不要直接使用：**

```dart
Text(
  '5:32',
  style: TextStyle(
    fontFamily: 'Fredoka',
  ),
)
```

这样最多只能达到 60%～70% 的相似度。

Apple 这种效果辨识度主要来自数字字形本身，例如：

```text
2
3
5
8
```

普通圆体字库的形状差距会非常明显。

建议：

```text
StandbyClock
        │
        ▼
Custom Vector Glyph Engine
        │
 ┌──────┼────────────┐
 0      1            9
        +
      Colon
```

每一个数字都是一个 Flutter `Path`。

最终：

```dart
StandbyDigit(
  digit: 5,
  color: palette.digit1,
)
```

而不是 `Text("5")`。

这是整个方案里最重要的决定。

---

# 3. 字形坐标系统

所有数字使用统一逻辑画布：

```text
width  = 100
height = 160
```

比如：

```dart
const Size glyphSize = Size(100, 160);
```

然后定义：

```dart
abstract class StandbyGlyph {
  Path buildPath(Size size);
}
```

实现：

```text
Digit0Glyph
Digit1Glyph
Digit2Glyph
Digit3Glyph
...
Digit9Glyph
```

文件：

```text
standby_glyphs/
├── standby_glyph.dart
├── digit_0.dart
├── digit_1.dart
├── digit_2.dart
├── digit_3.dart
├── digit_4.dart
├── digit_5.dart
├── digit_6.dart
├── digit_7.dart
├── digit_8.dart
└── digit_9.dart
```

最终通过：

```dart
Path getDigitPath(int digit);
```

统一调用。

---

# 4. 为什么推荐 Path 而不是 SVG 图片

SVG 也可以实现，但我更推荐 Flutter Path。

因为后面要做：

```text
颜色动画
缩放
数字 morph
阴影
渐变
动态主题
响应式尺寸
```

CustomPainter 更灵活。

结构：

```dart
class StandbyDigitPainter extends CustomPainter {
  final int digit;
  final Color color;

  StandbyDigitPainter({
    required this.digit,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = StandbyGlyphFactory.build(
      digit,
      size,
    );

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(
    covariant StandbyDigitPainter oldDelegate,
  ) {
    return digit != oldDelegate.digit ||
        color != oldDelegate.color;
  }
}
```

---

# 5. 数字不要用 Stroke 画

这一点很重要。

不要这样：

```dart
Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 30
  ..strokeCap = StrokeCap.round;
```

因为复杂数字：

```text
2
3
4
5
8
```

很难得到正确造型。

应该：

> **每个数字直接定义填充轮廓 Path。**

即：

```text
一个闭合矢量 Shape
```

而不是“拿粗线画一个数字”。

这样边缘、转角、开口全部可以精确控制。

---

# 6. 推荐的字形制作流程

第一阶段可以让 UI 设计师根据参考图画：

```text
0.svg
1.svg
2.svg
3.svg
4.svg
5.svg
6.svg
7.svg
8.svg
9.svg
```

统一：

```text
ViewBox:
0 0 100 160
```

然后：

```text
SVG
 ↓
Path 数据
 ↓
Flutter Path
```

或者 MVP 直接使用 SVG：

```yaml
flutter_svg: ^x.x.x
```

例如：

```dart
SvgPicture.asset(
  'assets/clocks/standby/5.svg',
  colorFilter: ColorFilter.mode(
    color,
    BlendMode.srcIn,
  ),
)
```

### 实际开发顺序

我建议：

```text
V1
SVG

↓

V2
必要时转 CustomPainter
```

因为开发速度更快。

---

# 7. Clock 组件结构

建议：

```text
StandbyDigitalClockView
│
├── StandbyClockBackground
│
└── Center
    └── StandbyTimeDisplay
        │
        ├── StandbyDigit    H1
        ├── StandbyDigit    H2
        │
        ├── StandbyColon
        │
        ├── StandbyDigit    M1
        └── StandbyDigit    M2
```

Flutter：

```dart
Row(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    StandbyDigit(
      digit: h1,
      color: palette.digit1,
    ),

    StandbyDigit(
      digit: h2,
      color: palette.digit2,
    ),

    StandbyColon(
      color: palette.colon,
    ),

    StandbyDigit(
      digit: m1,
      color: palette.digit3,
    ),

    StandbyDigit(
      digit: m2,
      color: palette.digit4,
    ),
  ],
)
```

---

# 8. 为什么每个数字单独配色

参考图不要简单理解成：

```text
HourColor
MinuteColor
```

最好直接支持：

```dart
class StandbyClockPalette {
  final Color background;

  final Color digit1;
  final Color digit2;
  final Color digit3;
  final Color digit4;

  final Color colonTop;
  final Color colonBottom;
}
```

例如截图这一套可以：

```dart
StandbyClockPalette(
  background: Color(0xFF030506),

  digit1: Color(0xFF65BE54),
  digit2: Color(0xFF65BE54),

  digit3: Color(0xFF299166),
  digit4: Color(0xFF65BE54),

  colonTop: Color(0xFFD9B4C2),
  colonBottom: Color(0xFFD9B4C2),
);
```

这样以后能做到：

```text
5   3 2
绿  深绿 浅绿
```

视觉会比“小时一种颜色，分钟一种颜色”更接近参考效果。

---

# 9. Colon 不使用字体

冒号独立实现：

```dart
class StandbyColon extends StatelessWidget {
  final Color topColor;
  final Color bottomColor;
  final double diameter;

  const StandbyColon({
    super.key,
    required this.topColor,
    required this.bottomColor,
    required this.diameter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _bubble(topColor),
        SizedBox(height: diameter * 0.72),
        _bubble(bottomColor),
      ],
    );
  }

  Widget _bubble(Color color) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
```

视觉比例建议从：

```text
bubble diameter
≈ 数字高度 × 0.14
```

开始调。

例如：

```text
Digit Height = 300

Colon Bubble ≈ 42
```

---

# 10. 尺寸比例

不要根据 `fontSize`。

应该把整个 Clock 当成一个图形。

例如逻辑比例：

```text
单数字宽度：100
数字高度：160

数字间距：2~7
冒号宽度：35~45
```

大致：

```text
H1 H2 : M1 M2

100 + 100 + 45 + 100 + 100
≈ 445
```

整体宽高比：

```text
约 2.7 : 1
```

实际 Flutter：

```dart
AspectRatio(
  aspectRatio: 2.75,
  child: StandbyTimeDisplay(),
)
```

再通过：

```dart
FittedBox(
  fit: BoxFit.contain,
)
```

缩放。

---

# 11. 横屏布局

这个主题最重要的是横屏。

推荐：

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final landscape =
        constraints.maxWidth > constraints.maxHeight;

    if (landscape) {
      return buildLandscape();
    }

    return buildPortrait();
  },
);
```

Landscape：

```text
Clock width:
屏幕宽度 × 0.72 ~ 0.84

Clock height:
屏幕高度 × 0.55 ~ 0.72
```

先以：

```dart
final clockWidth =
    constraints.maxWidth * 0.78;
```

开始调试。

---

# 12. Portrait

Portrait 不要直接把 Landscape 缩小得特别小。

建议：

```text
宽度：

screenWidth × 0.90
```

例如：

```dart
SizedBox(
  width: constraints.maxWidth * 0.90,
  child: const StandbyTimeDisplay(),
)
```

---

# 13. 背景颜色

Apple 这类效果的重点之一是：

> 黑不是完全死黑。

建议：

```dart
const Color standbyBackground =
    Color(0xFF030507);
```

或者：

```text
#020304
#050607
#07090B
```

第一版不要：

```dart
Colors.black
```

稍微带蓝黑，会更有质感。

---

# 14. Palette 系统

建议 Tiqlo 内置至少 10 套。

```dart
enum StandbyPaletteType {
  blue,
  violet,
  coral,
  pink,
  orange,
  red,
  green,
  cyan,
  greenMix,
  blueOrange,
}
```

---

# 15. 推荐预设

例如：

```dart
const standbyPalettes = [
  StandbyClockPalette(
    id: 'blue',
    digit1: Color(0xFF69A5FF),
    digit2: Color(0xFF69A5FF),
    digit3: Color(0xFF427AFF),
    digit4: Color(0xFF69A5FF),
    colonTop: Color(0xFFF4DBF2),
    colonBottom: Color(0xFFF4DBF2),
    background: Color(0xFF030507),
  ),

  StandbyClockPalette(
    id: 'green',
    digit1: Color(0xFF68BF55),
    digit2: Color(0xFF68BF55),
    digit3: Color(0xFF238D61),
    digit4: Color(0xFF68BF55),
    colonTop: Color(0xFFDAB5C3),
    colonBottom: Color(0xFFDAB5C3),
    background: Color(0xFF030507),
  ),

  StandbyClockPalette(
    id: 'purple',
    digit1: Color(0xFFAA85FF),
    digit2: Color(0xFFAA85FF),
    digit3: Color(0xFF7554D8),
    digit4: Color(0xFFA77BFF),
    colonTop: Color(0xFFFFDDEB),
    colonBottom: Color(0xFFFFDDEB),
    background: Color(0xFF040306),
  ),
];
```

数值后续通过真机视觉调整。

---

# 16. Color Picker

交互做成你第二张截图的方式。

点击 Clock 后：

```text
Clock
 ↓

─────────────
    Color

● ● ● ● ● ● ● ◐ ◐
```

建议用：

```dart
showModalBottomSheet()
```

但是 BottomSheet 不要使用默认 Material 风格。

推荐：

```dart
showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  barrierColor: Colors.transparent,
  builder: (_) {
    return const StandbyColorPanel();
  },
);
```

Panel：

```dart
Container(
  decoration: const BoxDecoration(
    color: Color(0xF5101317),
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(20),
    ),
  ),
)
```

---

# 17. Color Dot

单色：

```text
●
```

双色：

```text
◐
```

尺寸：

```text
点击区域：48 × 48
圆形尺寸：30~34
```

当前选择：

```text
白色边框
```

例如：

```dart
Container(
  width: 38,
  height: 38,
  padding: const EdgeInsets.all(3),
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(
      color: selected
          ? Colors.white
          : Colors.transparent,
      width: 2,
    ),
  ),
)
```

---

# 18. 双色圆一定要 CustomPaint

```dart
class DualColorCirclePainter extends CustomPainter {
  final Color left;
  final Color right;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.save();
    canvas.clipOval(rect);

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width / 2,
        size.height,
      ),
      Paint()..color = left,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        size.width / 2,
        0,
        size.width / 2,
        size.height,
      ),
      Paint()..color = right,
    );

    canvas.restore();
  }
}
```

---

# 19. 配色切换动画

这一点也很重要。

不要：

```text
绿色
啪
蓝色
```

推荐：

```text
250ms
ColorTween
```

例如：

```dart
TweenAnimationBuilder<Color?>(
  tween: ColorTween(
    end: color,
  ),
  duration: const Duration(
    milliseconds: 260,
  ),
  builder: (_, value, child) {
    return CustomPaint(
      painter: StandbyDigitPainter(
        digit: digit,
        color: value!,
      ),
    );
  },
)
```

Curve：

```dart
Curves.easeOutCubic
```

---

# 20. 时间变化动画

不要 Flip Clock。

这种主题最适合：

```text
Scale
+
Fade
```

分钟：

```text
32
 ↓
33
```

旧数字：

```text
scale 1
→
0.90

opacity
1
→
0
```

新数字：

```text
scale
1.08
→
1

opacity
0
→
1
```

时长：

```text
260 ~ 320 ms
```

---

# 21. 只动画发生变化的数字

不要每分钟：

```text
05:32

四个数字全部动画
```

应该比较：

```dart
oldDigits
newDigits
```

例如：

```text
05:32
 ↓
05:33
```

只有：

```text
最后一个 2
```

动画。

```text
05:39
 ↓
05:40
```

则：

```text
3
9
```

两个分钟数字变化。

这样质感会明显好很多。

---

# 22. StandbyDigit 内部结构

```dart
class StandbyDigit extends StatelessWidget {
  final int digit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: 280,
      ),
      transitionBuilder: (
        child,
        animation,
      ) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.92,
              end: 1,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
            ),
            child: child,
          ),
        );
      },
      child: CustomPaint(
        key: ValueKey(digit),
        painter: StandbyDigitPainter(
          digit: digit,
          color: color,
        ),
      ),
    );
  }
}
```

---

# 23. 冒号动画

第一版建议：

```text
不要闪烁
```

Apple 这种设计语言靠的是静态构图，不是传统电子钟。

后续可以加入极微弱：

```text
Scale:
0.98
→
1.02
→
0.98
```

周期：

```text
3 秒
```

不是每秒闪。

---

# 24. Clock Timer

如果没有秒：

```text
HH:mm
```

没有必要 60 FPS 更新时间。

甚至没有必要每秒重建整个 Clock。

正确方案：

```text
计算下一分钟开始时间
        ↓
Timer
        ↓
只刷新一次
```

例如：

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

  timer = Timer(
    next.difference(now),
    () {
      updateTime();
      scheduleNextMinute();
    },
  );
}
```

能明显减少无意义 rebuild。

---

# 25. Riverpod 状态

Tiqlo 继续沿用 Riverpod 会比较合适。

建议：

```text
clockTimeProvider

clockThemeProvider

standbyClockSettingsProvider
```

设置：

```dart
class StandbyClockSettings {
  final String paletteId;
  final bool use24Hour;
  final bool animationsEnabled;

  const StandbyClockSettings({
    required this.paletteId,
    required this.use24Hour,
    required this.animationsEnabled,
  });
}
```

不要把 DateTime 每秒塞进整个 Theme Provider。

---

# 26. 本地持久化

保存：

```text
clock.theme = standby_digital

standby.palette = green

standby.use24Hour = true

standby.animations = true
```

用户选择：

```text
Green
```

立即：

```text
更新 UI

+

持久化
```

下一次启动直接恢复。

---

# 27. 推荐目录

```text
lib/
└── features/
    └── clock/
        │
        ├── clock_view.dart
        │
        ├── themes/
        │   │
        │   ├── default/
        │   ├── pixel/
        │   │
        │   └── standby/
        │       │
        │       ├── standby_clock_view.dart
        │       ├── standby_time_display.dart
        │       ├── standby_digit.dart
        │       ├── standby_colon.dart
        │       │
        │       ├── painter/
        │       │   ├── standby_digit_painter.dart
        │       │   └── dual_color_circle_painter.dart
        │       │
        │       ├── glyphs/
        │       │   ├── standby_glyph.dart
        │       │   ├── digit_0.dart
        │       │   ├── ...
        │       │   └── digit_9.dart
        │       │
        │       ├── model/
        │       │   ├── standby_clock_palette.dart
        │       │   └── standby_clock_settings.dart
        │       │
        │       ├── data/
        │       │   └── standby_palettes.dart
        │       │
        │       └── widgets/
        │           ├── standby_color_panel.dart
        │           └── standby_color_item.dart
        │
        └── providers/
            ├── clock_provider.dart
            └── standby_clock_provider.dart
```

---

# 28. Full Screen Mode

这个主题最好一进入横屏就支持：

```text
全屏
隐藏 BottomNavigation
隐藏 AppBar
隐藏状态栏
隐藏导航条
```

Flutter：

```dart
SystemChrome.setEnabledSystemUIMode(
  SystemUiMode.immersiveSticky,
);
```

离开：

```dart
SystemChrome.setEnabledSystemUIMode(
  SystemUiMode.edgeToEdge,
);
```

注意生命周期恢复，否则退出 Clock 后整个 Tiqlo 还会保持全屏。

---

# 29. Orientation

Clock 页面最好允许：

```text
Portrait
+
LandscapeLeft
+
LandscapeRight
```

例如：

```dart
SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  DeviceOrientation.landscapeLeft,
  DeviceOrientation.landscapeRight,
]);
```

Tiqlo 其他页面仍然可以保持 Portrait。

---

# 30. OLED Burn-in

既然目标场景是桌面长期显示，这个最好一开始就预留。

不要明显移动。

比如：

```text
每 2~5 分钟

整体 Clock：

X ±3 px
Y ±2 px
```

平滑移动：

```text
5~10 秒
```

用户基本察觉不到。

实现：

```dart
AnimatedSlide
```

或者：

```dart
Transform.translate()
```

后面甚至可以提供设置：

```text
Burn-in Protection

On
```

---

# 31. 夜间模式

这个很适合 Tiqlo。

当用户开启：

```text
Night Mode
```

整个 Palette：

```text
绿色 / 蓝色 / 紫色
        ↓
深红色
```

例如：

```text
Background
#020000

Digit
#8F1717

Colon
#B52A2A
```

并降低亮度感。

注意 App 无法随意真正改变系统屏幕亮度的话，就通过视觉颜色达到类似效果。

---

# 32. Theme Resolver

现有 Clock：

```dart
Widget resolveClockTheme(
  ClockThemeType theme,
) {
  return switch (theme) {
    ClockThemeType.defaultClock =>
      const DefaultClockView(),

    ClockThemeType.pixel =>
      const PixelClockView(),

    ClockThemeType.standbyDigital =>
      const StandbyDigitalClockView(),
  };
}
```

这样这个主题只是：

> Clock Renderer

而不是新的 Page。

---

# 33. 推荐 MVP 开发顺序

工程师不要一次做完所有效果。

按下面顺序最稳：

1. 建立 `StandbyDigitalClockView`
2. 先用临时 Rounded 字体完成布局
3. 做 HH:mm 组件拆分
4. 实现独立 Colon
5. 完成 Landscape / Portrait
6. 加 Palette 系统
7. 加 Color Picker
8. 保存 Palette
9. 替换成自定义 SVG 数字
10. 精修 `0–9`
11. 加数字切换动画
12. 加 Fullscreen
13. 加 Burn-in Protection

**第 9～10 步才是最终质感的关键。**

---

# 34. 第一阶段可以先这样快速验证

为了别让工程师一开始就在 Path 上耗几天，可以：

```text
V0.1

Rounded Font
+
独立 Colon
+
Palette
+
Landscape
```

一天左右就可以验证交互方向。

结构仍然：

```dart
StandbyDigit
```

但是内部暂时：

```dart
Text()
```

例如：

```dart
class StandbyDigit extends StatelessWidget {
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        fontFamily: 'RoundedPrototype',
        fontSize: 160,
        height: 1,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}
```

确认整体布局没问题以后：

```text
Text

↓

SvgPicture

↓

CustomPainter
```

UI 上层完全不用动。

这是比较合理的工程实现方式。

---

# 35. 最终架构

最终我建议 Tiqlo Clock 做成这样：

```text
                     Clock
                       │
                Theme Resolver
                       │
        ┌──────────────┼───────────────┐
        │              │               │
     Default         Pixel        Standby Digital
                                        │
                     ┌──────────────────┼──────────────────┐
                     │                  │                  │
                   Glyph              Palette           Motion
                     │                  │                  │
                 0 ~ 9              Color Presets      Digit Fade
                 Colon              Night Mode         Scale
                 SVG/Path           Dark Mode          Burn-in
```

## 最值得工程师注意的 5 件事

这五条可以直接放到开发任务最顶部：

> **1. 不要把 `05:32` 当成一个 Text。**
> 必须拆成 `0 / 5 / Colon / 3 / 2` 五个独立组件。
>
> **2. Colon 是两个真实圆形，不是字体 `:`。**
>
> **3. 每一个 Digit 支持独立颜色。**
>
> **4. 第一版可以用 Rounded Font 验证，但正式版本用 SVG / Path 自定义 0–9 字形。**
>
> **5. Landscape 是这个主题的主要使用场景，Portrait 是兼容场景。**

如果你按这个方案做，真正决定最终能不能达到你截图中 **iPhone StandBy 那种感觉的，不是 Flutter 动画，而是 `0–9` 这套数字字形画得准不准**。所以我会把开发资源重点放在 **数字 SVG + 比例校准** 上，而不是先堆复杂动画。
