我看了当前的 **DigitalClock.live Flip Clock** 页面。它的 Flip 主题一共可以确认有 **10 套**：

**Pure Dark、Dark、Light、Green、Blue、Red、Orange、Yellow、Purple、Pink**。网站本身也说明 Flip Clock 使用 CSS 动画模拟机械翻页效果。([数字时钟在线][1])

有一点先说明：网页抓取结果能确认**主题名称和视觉效果**，但没有暴露构建后的 CSS 颜色变量，所以我下面的 Hex 是按照页面效果整理的**接近原站、适合直接复刻的配色**，不是声称拿到了网站源码里的精确色值。

### Flip 主题整理

| 英文      | 中文 | 页面背景  | 翻页卡片  | 数字      | 风格          |
| --------- | ---- | --------- | --------- | --------- | ------------- |
| Pure Dark | 纯黑 | `#000000` | `#101010` | `#F5F5F5` | OLED / 极简黑 |
| Dark      | 深色 | `#121212` | `#252525` | `#F5F5F5` | 标准深色      |
| Light     | 浅色 | `#EEEEEE` | `#FFFFFF` | `#111111` | 黑字白卡      |
| Green     | 绿色 | `#07140D` | `#18864A` | `#FFFFFF` | 复古绿        |
| Blue      | 蓝色 | `#07111F` | `#2563EB` | `#FFFFFF` | 科技蓝        |
| Red       | 红色 | `#190707` | `#DC2626` | `#FFFFFF` | 醒目红        |
| Orange    | 橙色 | `#1A0C05` | `#EA580C` | `#FFFFFF` | 暖橙          |
| Yellow    | 黄色 | `#171305` | `#FACC15` | `#111111` | 明亮黄        |
| Purple    | 紫色 | `#10091A` | `#7C3AED` | `#FFFFFF` | 紫罗兰        |
| Pink      | 粉色 | `#190A11` | `#DB2777` | `#FFFFFF` | 玫红 / Pink   |

我建议不要只定义 `background + card + text`，Flip Clock 最好把**卡片上半部和下半部稍微做出色差**，中间再加一条暗线，这样才有你前面那张图里的机械翻页质感。

```css
/* =========================
   Flip Clock Theme Tokens
   ========================= */

.flip-clock {
  --page-bg: #000000;

  /* 翻页卡片 */
  --card-top: #101010;
  --card-bottom: #0d0d0d;

  /* 数字 */
  --digit: #f5f5f5;

  /* 翻页中缝 */
  --divider: rgba(0, 0, 0, 0.65);

  /* 卡片边缘/阴影 */
  --border: rgba(255, 255, 255, 0.03);
  --shadow: rgba(0, 0, 0, 0.45);
}
```

然后 10 个主题可以统一成：

```css
/* 1. Pure Dark */
[data-theme="pure-dark"] {
  --page-bg: #000000;
  --card-top: #101010;
  --card-bottom: #0b0b0b;
  --digit: #f5f5f5;
  --divider: #000000;
}

/* 2. Dark */
[data-theme="dark"] {
  --page-bg: #121212;
  --card-top: #292929;
  --card-bottom: #222222;
  --digit: #f5f5f5;
  --divider: #111111;
}

/* 3. Light */
[data-theme="light"] {
  --page-bg: #eeeeee;
  --card-top: #ffffff;
  --card-bottom: #f4f4f4;
  --digit: #111111;
  --divider: #d0d0d0;
}

/* 4. Green */
[data-theme="green"] {
  --page-bg: #07140d;
  --card-top: #18864a;
  --card-bottom: #14713e;
  --digit: #ffffff;
  --divider: rgba(0, 0, 0, 0.3);
}

/* 5. Blue */
[data-theme="blue"] {
  --page-bg: #07111f;
  --card-top: #2563eb;
  --card-bottom: #1d4ed8;
  --digit: #ffffff;
  --divider: rgba(0, 0, 0, 0.3);
}

/* 6. Red */
[data-theme="red"] {
  --page-bg: #190707;
  --card-top: #dc2626;
  --card-bottom: #b91c1c;
  --digit: #ffffff;
  --divider: rgba(0, 0, 0, 0.3);
}

/* 7. Orange */
[data-theme="orange"] {
  --page-bg: #1a0c05;
  --card-top: #ea580c;
  --card-bottom: #c2410c;
  --digit: #ffffff;
  --divider: rgba(0, 0, 0, 0.3);
}

/* 8. Yellow */
[data-theme="yellow"] {
  --page-bg: #171305;
  --card-top: #facc15;
  --card-bottom: #eab308;
  --digit: #111111;
  --divider: rgba(0, 0, 0, 0.25);
}

/* 9. Purple */
[data-theme="purple"] {
  --page-bg: #10091a;
  --card-top: #7c3aed;
  --card-bottom: #6d28d9;
  --digit: #ffffff;
  --divider: rgba(0, 0, 0, 0.3);
}

/* 10. Pink */
[data-theme="pink"] {
  --page-bg: #190a11;
  --card-top: #db2777;
  --card-bottom: #be185d;
  --digit: #ffffff;
  --divider: rgba(0, 0, 0, 0.3);
}
```

实际 Flip 卡片统一使用：

```css
.flip-clock {
  background: var(--page-bg);
}

.flip-card {
  color: var(--digit);
  border: 1px solid var(--border);
  box-shadow: 0 8px 24px var(--shadow);
}

.flip-card-top {
  background: var(--card-top);
}

.flip-card-bottom {
  background: var(--card-bottom);
}

.flip-card::after {
  content: "";
  position: absolute;
  left: 0;
  right: 0;
  top: 50%;
  height: 2px;
  background: var(--divider);
}
```

### 我比较推荐保留的 6 套

如果是做时钟 App，其实没必要机械照搬全部 10 套。我会优先保留：

**Pure Dark / Light / Green / Blue / Orange / Pink**

其中 **Pure Dark** 可以作为默认主题。黑色背景 + `#F5F5F5` 数字 + 接近黑色的 Flip 卡片，就是你最开始发给我的那种经典翻页钟感觉。

另外我建议主题数据最终抽象成这 5 个颜色就够了：

```css
--background
--card-top
--card-bottom
--digit
--divider
```

这样以后 Flutter 实现时，也可以直接一一对应成 `FlipTheme`，不需要在 Widget 里面写死颜色。网站当前主题列表可以直接参考这里。([数字时钟在线][1])

[DigitalClock.live Flip Clock](https://digitalclock.live/flip-clock/?utm_source=chatgpt.com)

[1]: https://digitalclock.live/flip-clock/ "Flip Clock Online"
