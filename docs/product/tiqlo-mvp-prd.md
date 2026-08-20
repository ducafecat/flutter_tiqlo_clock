# Tiqlo 时钟 App MVP PRD

## 1. 产品概述

### 1.1 产品名称

**Tiqlo**

### 1.2 产品定位

Tiqlo 是一款基于 Flutter 开发的极简桌面时钟 App。

核心定位：

> **把手机变成一台漂亮、沉浸、适合专注的桌面时钟。**

Tiqlo 第一版不追求“功能最多”，而是重点做好：

- 漂亮的全屏时钟
- 横屏桌面使用
- Focus 专注计时
- 多种时钟主题
- 夜间床头时钟

------

## 2. 产品目标

MVP 主要验证以下几件事：

1. 用户是否愿意把 Tiqlo 长时间放在桌面显示。
2. 用户是否喜欢不同 Clock Theme。
3. Focus 是否能够提高用户使用频率。
4. Theme / Widget 是否具备后续付费价值。

核心目标：

> 让用户打开 Tiqlo 后，愿意把手机放在桌面上一小时以上。

------

# 3. 目标用户

| 用户     | 使用场景                   |
| -------- | -------------------------- |
| 程序员   | 工作、编码时作为桌面时钟   |
| 学生     | 学习、复习、番茄专注       |
| 办公用户 | 手机横放显示时间           |
| 创作者   | 剪辑、设计、写作时专注计时 |
| 居家用户 | 床头时钟、夜间查看时间     |

------

# 4. 核心产品结构

Tiqlo 不采用传统复杂工具 App 的结构。

核心围绕：

```text
Tiqlo

        Clock
          │
    ┌─────┼─────┐
    ↓     ↓     ↓

 Theme  Focus  Timer

    │     │     │
    └─────┼─────┘
          ↓

       Settings
```

默认打开 App：

> **直接进入 Clock。**

不显示复杂首页。

------

# 5. MVP 功能范围

## P0 核心功能

| 功能         | 说明               |
| ------------ | ------------------ |
| 当前时间     | 实时显示小时和分钟 |
| 日期         | 星期、年月日       |
| 全屏时钟     | 沉浸式显示         |
| 横屏模式     | 桌面主要使用场景   |
| 竖屏模式     | 普通手机使用       |
| 屏幕常亮     | 防止桌面使用时熄屏 |
| Clock Theme  | 多种时钟视觉主题   |
| Focus        | 专注倒计时         |
| Timer        | 普通倒计时         |
| Night Mode   | 夜间床头模式       |
| 12/24 小时制 | 用户自由选择       |
| 本地设置保存 | 重启后保持设置     |

------

# 6. MVP 暂不包含

以下功能不进入 V1.0：

- Alarm 闹钟
- Stopwatch 秒表
- 世界时钟
- 天气
- 用户登录
- 云同步
- 后端服务
- AI
- 社交
- Todo
- 任务管理
- 睡眠监测
- Apple Health
- Health Connect
- 白噪音
- Home Widget
- Lock Screen Widget
- Dynamic Island
- Apple Watch
- Wear OS

原则：

> **MVP 先把 Clock + Focus 做好。**

------

# 7. 首页 Clock

## 7.1 页面目标

用户打开 App 后立即看到时间。

页面尽量不出现：

- AppBar
- Bottom Navigation
- 大量按钮
- 广告
- 复杂文字

默认界面：

```text
        21:38

     THU · AUG 20
```

------

# 8. 时钟显示

默认显示：

- Hour
- Minute
- Weekday
- Date

可选显示：

- Second
- AM / PM

示例：

```text
21:38

THU · AUG 20
```

或者：

```text
09:38 PM

THU · AUG 20
```

------

# 9. 全屏模式

进入 Clock 后默认采用沉浸式设计。

点击屏幕显示操作栏：

```text
Theme     Focus     Timer     More
```

几秒无操作后自动隐藏。

再次点击屏幕可以重新显示。

目标：

> 大部分时间屏幕上只有“时间”。

------

# 10. 横屏模式

用户横置手机后自动进入桌面布局。

示例：

```text
┌──────────────────────────────┐
│                              │
│            21:38             │
│                              │
│        THU · AUG 20          │
│                              │
└──────────────────────────────┘
```

要求：

- 字号自动放大
- 内容保持居中
- 不出现 Overflow
- 操作按钮自动隐藏
- 横屏体验优先于竖屏

------

# 11. Clock Theme

Theme 是 Tiqlo MVP 的核心功能。

第一版提供至少 4 套主题。

## 11.1 Minimal

极简数字时钟。

```text
21:38
```

## 11.2 Flip

经典翻页时钟。

```text
┌────┐ ┌────┐
│ 21 │ │ 38 │
└────┘ └────┘
```

支持简单翻页动画。

## 11.3 OLED

黑色背景、大数字、低干扰。

适合：

- 夜间
- OLED 屏幕
- 床头

## 11.4 Retro

复古电子时钟风格。

```text
21:38
THU 20
```

------

# 12. Theme 数据结构

Theme 不只是简单颜色。

每个 Theme 包含：

```text
Theme

id
name

background

timeFont
timeSize
timeStyle

dateFont
dateStyle

showSeconds

animation

layout
```

后续可以方便扩展：

```text
Pixel
Terminal
Cyber
Studio
Analog
Mechanical
```

------

# 13. Theme 选择

点击：

**Theme**

从底部弹出主题选择：

```text
Themes

Minimal

Flip

OLED

Retro
```

点击后即时预览。

选择完成后：

- 自动保存
- 下次打开继续使用该 Theme

------

# 14. Focus

Focus 是 Tiqlo MVP 第二核心模块。

设计原则：

> Focus 不能让用户离开 Clock。

点击：

**Focus**

显示：

```text
Focus

15 min

25 min

45 min

60 min

Custom
```

默认突出：

**25 min**

------

# 15. 开始 Focus

用户点击：

```text
25 min
```

然后：

```text
Start
```

进入：

```text
        24:59

        FOCUS
```

Clock 自动变成 Focus Clock。

------

# 16. Focus 操作

Focus 运行过程中支持：

- Pause
- Resume
- Stop

点击屏幕显示：

```text
Pause

Stop
```

无操作时自动隐藏。

------

# 17. Focus 完成

时间结束：

```text
25:00

Focus Complete ✓
```

同时：

- 播放提示音
- 震动一次

显示：

```text
Done
```

点击后返回普通 Clock。

------

# 18. Focus 数据

MVP 只记录简单数据。

显示：

```text
Today

3 Sessions

75 Minutes
```

只统计：

- 今日完成次数
- 今日专注分钟数

暂不做：

- 周统计
- 月统计
- 图表
- 排行榜
- Achievement
- Streak

------

# 19. Timer

Timer 为普通倒计时。

入口：

```text
Timer
```

提供快捷选项：

```text
1 min

5 min

10 min

30 min

Custom
```

开始后：

```text
09:58

TIMER
```

支持：

- Pause
- Resume
- Cancel

结束后：

- 声音提醒
- 震动提醒

------

# 20. Night Mode

Night Mode 用于床头场景。

进入后：

- 黑色背景
- 降低视觉亮度
- 时间颜色变暗
- 隐藏日期或减少信息
- 保持屏幕常亮

示例：

```text
03:26
```

尽可能减少光线干扰。

------

# 21. 屏幕常亮

设置项：

```text
Keep Screen Awake

ON / OFF
```

开启后：

Clock、Focus、Timer 页面不会自动熄屏。

离开相关页面后恢复正常系统策略。

------

# 22. 设置

Settings 页面：

```text
Settings

Time Format
24 Hour

Show Seconds
OFF

Keep Screen Awake
ON

Sound
ON

Vibration
ON

Default Theme
Minimal

Night Mode
Auto / Manual

About Tiqlo

Version 1.0.0
```

------

# 23. 导航设计

MVP 不使用传统 Bottom Navigation。

主页面点击后出现：

```text
Theme

Focus

Timer

More
```

More 中：

```text
Night Mode

Settings

About
```

这样可以保证：

> Clock 永远是整个 App 的中心。

------

# 24. 本地数据

Tiqlo MVP 不需要服务器。

全部数据存储在本机。

包含：

```text
Theme Settings

Clock Settings

Focus Settings

Focus Sessions

Timer Settings

App Settings
```

------

# 25. 数据模型

## AppSettings

```text
AppSettings

timeFormat

showSeconds

keepAwake

soundEnabled

vibrationEnabled

themeId

nightMode
```

------

## FocusSession

```text
FocusSession

id

duration

startTime

endTime

completed
```

------

## ClockTheme

```text
ClockTheme

id

name

type

config
```

------

# 26. 页面清单

MVP 页面控制在：

| 页面           | 优先级 |
| -------------- | ------ |
| Clock          | P0     |
| Clock 横屏     | P0     |
| Theme Selector | P0     |
| Focus Selector | P0     |
| Focus Running  | P0     |
| Focus Complete | P0     |
| Timer Selector | P0     |
| Timer Running  | P0     |
| Night Clock    | P0     |
| Settings       | P0     |
| About          | P1     |

约：

**10 个核心页面。**

------

# 27. 核心用户流程

## Clock

```text
启动 Tiqlo
    ↓
Clock
    ↓
选择 Theme
    ↓
横屏
    ↓
全屏桌面使用
```

------

## Focus

```text
Clock
  ↓
Focus
  ↓
25 min
  ↓
Start
  ↓
Focus Clock
  ↓
完成
  ↓
返回 Clock
```

------

## Timer

```text
Clock
  ↓
Timer
  ↓
选择时间
  ↓
Start
  ↓
倒计时
  ↓
完成提醒
```

------

# 28. Flutter 技术方案

建议：

```text
Flutter

Riverpod

GoRouter

Freezed

SharedPreferences / Isar

wakelock_plus

just_audio

vibration
```

时间核心：

```text
Clock Engine

├── System Clock
├── Focus Countdown
└── Timer Countdown
```

Theme：

```text
Clock Engine
       ↓
Theme Renderer
       ↓
UI
```

这样不同主题可以复用相同时间逻辑。

------

# 29. Flutter 工程结构

```text
lib/

├── app/

├── core/
│   ├── theme/
│   ├── storage/
│   ├── timer/
│   └── utils/

├── features/
│   ├── clock/
│   ├── focus/
│   ├── timer/
│   ├── theme/
│   ├── night/
│   └── settings/

└── main.dart
```

每个模块：

```text
feature/

├── data/
├── domain/
└── presentation/
```

------

# 30. 性能要求

Clock 属于长时间运行页面，需要特别关注性能。

要求：

- 时间更新不能造成整个页面频繁 rebuild
- 分钟模式不需要每秒 rebuild
- 显示秒时只刷新时间区域
- Flip 动画保持流畅
- 横竖屏切换无明显卡顿
- 长时间运行内存稳定
- 尽量降低电量消耗

------

# 31. MVP 验收标准

-  App 打开后立即显示 Clock
-  时间显示准确
-  日期显示准确
-  支持 12 / 24 小时制
-  支持横屏
-  支持竖屏
-  支持全屏
-  支持屏幕常亮
-  至少提供 4 套 Theme
-  Theme 可以即时切换
-  Theme 设置可以持久保存
-  Flip 动画正常
-  Focus 可以选择时长
-  Focus 可以开始
-  Focus 可以暂停
-  Focus 可以继续
-  Focus 可以停止
-  Focus 完成正常提醒
-  Focus 数据可以保存
-  Timer 可以正常运行
-  Timer 完成可以提醒
-  Night Mode 正常
-  App 重启后设置不丢失
-  长时间运行无明显内存异常
-  iOS 正常运行
-  Android 正常运行
-  无严重 Crash

------

# 32. V1.0 上线范围

最终 MVP：

```text
Tiqlo V1.0

Clock
│
├── Minimal
├── Flip
├── OLED
└── Retro

Focus

Timer

Night Mode

Landscape

Fullscreen

Keep Awake

Settings
```

------

# 33. V1.5

上线后优先开发：

```text
Home Widget

Lock Screen Widget

StandBy

更多 Theme

Theme Pro
```

这个阶段开始强化：

> **Clock Everywhere**

------

# 34. V2.0

```text
Clock Scene

Ambient Sound

Focus Statistics

Custom Background

Custom Font

Premium Theme
```

产品从单纯 Clock 升级为：

> **Focus Clock Experience**

------

# 35. V2.5

再考虑加入：

```text
Alarm

Gentle Wake

Smart Alarm

Snooze

Wake-up Missions
```

不建议普通 Alarm 提前进入 MVP。

------

# 36. MVP 核心原则

Tiqlo 第一版开发过程中始终遵循三个原则：

### 1. Clock First

用户打开 App 第一眼必须是漂亮的 Clock。

### 2. Less Interaction

尽可能减少按钮、菜单和页面跳转。

### 3. Design is Feature

Theme、字体、布局、动画本身就是 Tiqlo 的核心功能。

最终产品应该让用户产生这样的感觉：

> **打开 Tiqlo，不是在使用一个工具，而是把手机变成了一台漂亮的桌面时钟。**