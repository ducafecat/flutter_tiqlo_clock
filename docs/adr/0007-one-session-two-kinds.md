# Focus 和 Timer 是同一种 Session

一套状态机，`kind: focus | timer`。两套入口、文案、预设时长。只有 Focus 的 Complete 写今日统计。

PRD 把它们画成两个模块；复制状态机会让 Pause/Stop/deadline/持久化分叉。
