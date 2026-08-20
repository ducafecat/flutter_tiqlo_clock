# Session 进后台不暂停；杀进程按单调时间恢复；重启视为 Pause

切到后台仍继续；remaining 到 0 则 Complete（通知见 ADR 0010/0013）。同一次开机杀进程后，用单调 elapsed 恢复。重启 elapsed 归零：当成 Pause，remaining 冻结。

用户要停就 Pause。V1 不做前台服务。
