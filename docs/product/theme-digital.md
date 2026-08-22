我重新看了 `digitalclock.live` 首页。当前 **Digital Clock** 一共能确认有 **9 个 Clock Template**：

**Digital、Digital-Blue、Digital-Red、Digital-Amber、Digital-Orange、Pure Dark、Dark、Light、Classic**。([数字时钟在线][1])

网站自己的说明也把其中一部分归类为经典 LED 风格：**Green / Blue / Red / Amber**，以及现代极简风格：**Pure Dark / Dark / Light**。([数字时钟在线][2])

需要说明一下：网站公开页面没有直接暴露每套主题源码里的 Hex 值，因此下面的颜色是我按照页面视觉效果整理的**高相似度复刻配色**，适合直接拿来做你的时钟主题。

### Digital 主题整理

| Theme          | 中文   | 背景      | 数字      | 风格         |
| -------------- | ------ | --------- | --------- | ------------ |
| Digital        | 数码绿 | `#000000` | `#39FF14` | 经典绿色 LED |
| Digital-Blue   | 数码蓝 | `#000000` | `#00BFFF` | 蓝色 LED     |
| Digital-Red    | 数码红 | `#000000` | `#FF3030` | 红色 LED     |
| Digital-Amber  | 琥珀色 | `#000000` | `#FFBF00` | 老式电子钟   |
| Digital-Orange | 数码橙 | `#000000` | `#FF7A00` | 暖橙 LED     |
| Pure Dark      | 纯黑   | `#000000` | `#F5F5F5` | OLED 黑白    |
| Dark           | 深色   | `#171717` | `#F5F5F5` | 现代深色     |
| Light          | 浅色   | `#F5F5F5` | `#171717` | 极简浅色     |
| Classic        | 经典   | `#000000` | `#FFFFFF` | 传统电子钟   |

我建议 Digital 系列不只定义 `color`，还要加入一点 **LED glow**，效果会明显更接近真实数码管。

```css
/* ===============================
   Digital Clock Theme Tokens
   =============================== */

.digital-clock {
  --background: #000000;
  --digit: #39ff14;
  --secondary: #269f18;

  /* LED 发光 */
  --glow: 0 0 4px currentColor, 0 0 12px currentColor;

  background: var(--background);
  color: var(--digit);
}
```

然后 9 套主题可以这样整理。

```css
/* 1. Digital / Green LED */
[data-theme="digital"] {
  --background: #000000;
  --digit: #39ff14;
  --secondary: #168b12;

  --glow: 0 0 4px rgba(57, 255, 20, 0.8), 0 0 14px rgba(57, 255, 20, 0.35);
}

/* 2. Digital Blue */
[data-theme="digital-blue"] {
  --background: #000000;
  --digit: #00bfff;
  --secondary: #087fa8;

  --glow: 0 0 4px rgba(0, 191, 255, 0.8), 0 0 14px rgba(0, 191, 255, 0.35);
}

/* 3. Digital Red */
[data-theme="digital-red"] {
  --background: #000000;
  --digit: #ff3030;
  --secondary: #a81919;

  --glow: 0 0 4px rgba(255, 48, 48, 0.8), 0 0 14px rgba(255, 48, 48, 0.35);
}

/* 4. Digital Amber */
[data-theme="digital-amber"] {
  --background: #000000;
  --digit: #ffbf00;
  --secondary: #9d7600;

  --glow: 0 0 4px rgba(255, 191, 0, 0.8), 0 0 14px rgba(255, 191, 0, 0.35);
}

/* 5. Digital Orange */
[data-theme="digital-orange"] {
  --background: #000000;
  --digit: #ff7a00;
  --secondary: #a54f00;

  --glow: 0 0 4px rgba(255, 122, 0, 0.8), 0 0 14px rgba(255, 122, 0, 0.35);
}

/* 6. Pure Dark */
[data-theme="pure-dark"] {
  --background: #000000;
  --digit: #f5f5f5;
  --secondary: #737373;

  --glow: none;
}

/* 7. Dark */
[data-theme="dark"] {
  --background: #171717;
  --digit: #f5f5f5;
  --secondary: #737373;

  --glow: none;
}

/* 8. Light */
[data-theme="light"] {
  --background: #f5f5f5;
  --digit: #171717;
  --secondary: #737373;

  --glow: none;
}

/* 9. Classic */
[data-theme="classic"] {
  --background: #000000;
  --digit: #ffffff;
  --secondary: #666666;

  --glow: 0 0 3px rgba(255, 255, 255, 0.35);
}
```

实际数字：

```css
.digital-clock__time {
  color: var(--digit);
  text-shadow: var(--glow);
}

.digital-clock__date,
.digital-clock__ampm {
  color: var(--secondary);
}
```

### 如果做成你的 App，我建议再简化

其实可以把这 9 套分成两个系列：

**LED 系列**

```text
Digital Green
Digital Blue
Digital Red
Digital Amber
Digital Orange
```

特点统一：

```css
background: #000;
font-family: "DSEG7 Classic";
text-shadow: LED glow;
```

**Minimal 系列**

```text
Pure Dark
Dark
Light
Classic
```

其中我认为最值得保留的是这 6 套：

**Green / Blue / Amber / Orange / Pure Dark / Light**

尤其是 **DSEG7 Classic Bold + Pure Dark** 和 **DSEG7 Classic Bold + Amber**，很适合做桌面全屏时钟。([数字时钟在线][2])

如果你接下来要把这些主题加入 **Tiqlo Flutter**，主题数据也可以直接抽象为：

```dart
class DigitalTheme {
  final Color background;
  final Color digit;
  final Color secondary;
  final Color glow;
}
```

这样 Flip Theme 和 Digital Theme 就可以各自独立维护。

[1]: https://digitalclock.live/ "Digital Clock Online"
[2]: https://digitalclock.live/blog/clock-for-second-monitor/?utm_source=chatgpt.com "Clock for Second Monitor - Digital Clock"
