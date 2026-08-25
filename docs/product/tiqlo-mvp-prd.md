# Tiqlo 当前 MVP PRD

> 文档状态：与当前代码实现对齐（版本 1.0.0）。本文描述已面向用户交付的能力；仅存在于内部状态层、尚无 UI 入口的能力会单独标注，不视为已交付功能。

## 1. 产品概述

### 1.1 产品名称

**Tiqlo**

### 1.2 产品定位

Tiqlo 是一款 Flutter 时钟应用，将设备变为沉浸、清晰、可长时间摆放的桌面时钟。当前 MVP 的中心是大字号数字时钟与可切换的 Flip / Digital 视觉风格，而非复杂的效率工具集合。

核心体验：

> 打开应用即可看清时间；在需要时切换外观、显示信息和夜间显示方式。

### 1.3 当前产品目标

- 让用户在竖屏与横屏下都能清晰查看当前时间。
- 以少量交互维持沉浸式桌面时钟体验。
- 提供可持久化的外观与显示偏好。
- 在夜间及长时间展示时控制亮度和设备休眠。

## 2. 目标用户与场景

| 用户 | 场景 |
| --- | --- |
| 办公与创作用户 | 将手机或电脑置于桌面，快速查看时间 |
| 学生 | 学习或阅读时，以低干扰的大字时钟查看时间 |
| 居家用户 | 床头、客厅等夜间查看时间 |
| 偏好数字时钟的用户 | 在翻页、电子管与不同配色之间切换 |

## 3. 信息架构与启动流程

应用不使用底部导航。时钟页是唯一主页面，设置与关于为二级页面。

```text
移动端首次启动
Splash（约 1.1 秒） → Welcome（三页，可跳过） → Clock

后续启动 / 非移动端
Clock
  ├─ Theme
  ├─ More → Night Mode
  ├─ More → Settings
  ├─ More → About
  └─ Fullscreen（Web 与桌面端）
```

- Splash 与 Welcome 仅在 iOS、Android 默认启用。
- Welcome 完成或跳过后会本地记录，之后直接进入 Clock。
- Clock 页面隐藏系统 UI；进入设置或关于时恢复系统 UI，返回后再次隐藏。

## 4. 已交付功能范围

### 4.1 时钟展示（P0）

- 实时显示小时、分钟；启用秒数后按秒刷新，否则按分钟刷新。
- 支持 12 / 24 小时制；12 小时制显示 AM / PM。
- 可选显示星期与日期，日期按设备 locale 格式化。
- 可选显示小时前导零。
- 支持竖屏与横屏；横屏使用更大的基础字号，并通过自适应布局保证内容居中、不溢出。
- 主界面默认不显示工具栏。点击空白处显示操作栏，3 秒无操作自动隐藏；再次点击可隐藏或重新显示。

### 4.2 时钟样式与主题（P0）

时钟页工具栏中的 **Theme** 打开底部选择器。选择即时生效并保存，下次启动自动恢复。

| 时钟样式 | 已提供能力 |
| --- | --- |
| Flip | 翻页卡片式时钟，分钟变化时播放翻页动画；支持 10 组配色：Pure Dark、Dark、Light、Green、Blue、Red、Orange、Yellow、Purple、Pink。 |
| Digital | 七段数码管时钟；支持 9 组配色：Digital、Digital-Blue、Digital-Red、Digital-Amber、Digital-Orange、Pure Dark、Dark、Light、Classic。 |

默认样式为 Flip，默认配色为 Pure Dark。主题选择器先选择样式，再呈现该样式的配色选项。

### 4.3 夜间模式与屏幕常亮（P0）

- **Night Mode** 可从 More 或 Settings 开关。
- 开启后隐藏秒数及日期，将时钟视觉透明度降至 35%，并尝试将应用亮度设置为 15%。关闭后恢复系统亮度。
- **Keep Screen Awake** 默认为开启，可在 Settings 关闭；时钟页会根据该设置申请或释放屏幕常亮。
- 具体亮度、常亮效果受平台与系统权限限制。

### 4.4 设置与关于（P0）

Settings 包含以下分组：

| 分组 | 设置项 |
| --- | --- |
| Time & Date | 24 Hour、Show Leading Zero、Show Seconds、Date & Weekday |
| Display | Keep Screen Awake、Night Mode |
| Alerts | Sound、Vibration |

About 页面显示当前版本号（1.0.0）。

### 4.5 全屏（P0，受平台限制）

- Web、macOS、Windows、Linux 支持从主工具栏进入或退出全屏。
- iOS、Android 当前不展示该全屏按钮；移动端通过沉浸式系统 UI 获得无干扰时钟体验。

### 4.6 本地持久化（P0）

应用不依赖账号、后端或云同步。以下数据使用 SharedPreferences 保存在本机：

- 首次欢迎页完成状态。
- 时间格式、秒数、日期、前导零、屏幕常亮与夜间模式。
- 时钟样式、Digital 配色与 Flip 配色。
- 声音、振动与通知授权状态。

## 5. 当前未面向用户交付的能力

代码中已存在 Focus / Timer 的会话状态机、暂停/继续/停止、会话恢复、完成提醒调度以及当日 Focus 完成统计的底层能力，但当前主界面没有 Focus 或 Timer 的入口、时长选择器和统计页面。因此它们不是本 MVP 的可用功能，也不应作为验收项或对外承诺。

当会话由未来入口启动时，现有底层行为为：

- 同一时间只能存在一个 Focus 或 Timer 会话。
- 运行中的会话可暂停、继续、停止；结束后需要确认完成。
- 完成的 Focus 会记入本地「当天完成次数 / 分钟数」；Timer 不计入该统计。
- 应用进入后台时会尝试排程本地通知；前台完成时按 Sound / Vibration 设置播放系统提示音或振动。
- 设备重启导致单调计时基准回退时，运行中的会话会恢复为暂停，避免错误扣减时间。

## 6. 暂不包含

- 可由用户启动的 Focus、Timer、统计或自定义时长界面。
- 闹钟、秒表、世界时钟、天气。
- 账号、云同步、后端服务、社交与任务管理。
- Widget、锁屏组件、Dynamic Island、Apple Watch、Wear OS。
- 付费订阅、主题商店、广告。
- 自动夜间模式、环境光感知、白噪音与睡眠监测。

## 7. 核心交互规范

### 7.1 Clock

```text
打开应用 → Clock
点击时钟区域 → Theme / More / Fullscreen（受支持平台）
3 秒无操作 → 隐藏工具栏
```

### 7.2 Theme

```text
Clock → Theme → 选择 Flip 或 Digital → 选择配色 → 即时预览并自动保存
```

### 7.3 More

```text
Clock → More → Night Mode / Settings / About
```

## 8. 设计原则

1. **Clock First**：进入应用后，时钟应是第一且最重要的信息。
2. **Less Interaction**：操作收纳到短暂出现的工具栏和底部面板中。
3. **Theme as Feature**：翻页动画、数字字体和配色是主要产品价值。
4. **Long-running Friendly**：根据显示精度安排刷新频率，减少无意义更新；让横竖屏、夜间模式和常亮适合长时间展示。

## 9. 技术实现边界

| 领域 | 当前实现 |
| --- | --- |
| 应用框架 | Flutter + Material |
| 状态与路由 | Riverpod + go_router |
| 本地存储 | SharedPreferences |
| 时间引擎 | wall clock 显示 + 单调 elapsed time 会话计时 |
| 本地提醒 | flutter_local_notifications（通知授权后） |
| 设备能力 | wakelock_plus、screen_brightness、flutter_fullscreen |

## 10. 当前 MVP 验收标准

- 移动端首次启动完成 Splash / Welcome 后进入 Clock，后续启动不重复展示 Welcome。
- 时钟时间准确；12 / 24 小时、秒数、日期与前导零设置即时生效且重启后保留。
- Flip 与 Digital 样式和各自配色可即时切换、重启后保留。
- 工具栏点击出现、3 秒后隐藏；More 可进入夜间模式、设置与关于。
- 竖屏、横屏均保持时钟居中且无布局溢出。
- Night Mode 会降低时钟干扰、隐藏秒数和日期，并尝试降低亮度。
- Keep Screen Awake 可开关，并在时钟页按设置生效。
- 支持的平台可以进入与退出全屏。
- 设置页和关于页正常进入、返回后恢复时钟的沉浸式 UI。
- 不发生严重崩溃；本地设置在应用重启后不丢失。

## 11. 后续演进方向（非当前承诺）

1. 为已存在的会话引擎补齐 Focus / Timer 的入口、时长选择、进行中控制与每日统计展示。
2. 扩展主题种类与主题预览能力。
3. 在确认核心时钟留存后，再评估 Widget、锁屏展示、付费主题或云同步等投入。
