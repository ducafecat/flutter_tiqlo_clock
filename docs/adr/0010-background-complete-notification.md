# 后台 Complete 发本地通知

进程还在、Session 在后台走完时，发本地通知（声音+震动）；回到前台进入 Complete。进程已被杀则冷启动再进 Complete，不补发当时的通知。

V1 不做前台服务。没有通知等于后台 Focus 白跑。
