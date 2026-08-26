# 03: 完成启动体验与全平台验收收口

**What to build:** 让移动端启动与 Welcome chrome 进入同一 Pixel UI，并以固定的跨平台、跨尺寸、跨输入回归矩阵校准整套系统。完成后，Tiqlo 的全部运行时界面都属于同一种视觉语言，不再暴露旧 Material 外观，同时保持现有产品功能与平台行为不变。

**Blocked by:** 02 / 完成 Clock 全链路 Pixel UI

**Status:** ready-for-agent

- [ ] Flutter Splash 保留现有插画和导航逻辑，移除缩放并使用 300ms 淡入；系统关闭动画时直接显示
- [ ] Welcome 保留三张现有插画、三页中文文案、左右滑动、跳过、下一步和开始使用行为
- [ ] Welcome 使用 PixelButton、PixelPageIndicator、Pixel 排版与系统中文 fallback；按钮翻页 300ms，文案与分页器 150ms，关闭动画时立即更新
- [ ] Splash、Welcome、Clock、Theme、More、Settings、About 与 Session 在视觉上明确属于同一套 Minimal Pixel UI
- [ ] Android 360×640 / 1.0× 覆盖三卡 Flip、日期、Theme 和 Settings 滚动，无溢出
- [ ] iOS 844×390 / 1.3× 覆盖 SafeArea、横排 Clock 与 Theme 滚动，无内容不可达
- [ ] Tablet 1024×768 / 2.0× 覆盖 Theme 网格降列、设置行增高和长标签，不截断主要文字
- [ ] macOS 1280×800 / 1.0× 覆盖 hover、focus、Tab / Shift-Tab、Enter / Space 与全屏操作
- [ ] Web 1440×900 / 2.0× 覆盖最大内容宽度、滚动、焦点顺序与焦点轮廓不裁剪
- [ ] Windows 与 Linux 能编译并通过基本布局验证，不要求逐像素 golden
- [ ] 正常模式文字和 Clock 数字至少达到 4.5:1；必要图形、焦点框和开关边界至少达到 3:1；Night Mode 大号时间至少达到 3:1 且操作 chrome 保持 4.5:1
- [ ] Golden 至少覆盖 Flip、Digital、Theme、More、Settings、Welcome 和 About，并固定字体版本、viewport、DPR 与文字缩放
- [ ] 语义、键盘、滚动、hover、focus 与 reduced motion 使用独立交互测试，不依赖 golden 代替行为验证
- [ ] 删除已经没有调用方的旧视觉模块、硬编码圆角和只锁定旧 Material 实现的测试；最终运行时不存在可见的旧 Material 控件
- [ ] 完整静态分析与测试套件通过，路由、偏好键、ClockTheme palette、Night Mode、全屏、系统 UI、亮度、常亮、通知和 Session 行为无回归
- [ ] 不新增 Focus / Timer 入口、selector、统计页、咖啡流程、主导航、ClockTheme、palette、About 内容或 feature flag
