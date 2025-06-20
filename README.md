# 东华大学数据库课程设计
## 图书馆信息管理系统

1. 仅使用了MySQL和Servlet外部依赖
2. 几乎没使用任何框架

## 表定义
1. User一个表：User
2. Book四个表：Book，Keyword，BookKeyword，BookNA（BookNotAvailable）
3. 还需要一个Action表，用来表示所有与用户和书籍相关的动作

## Tomcat版本
10.0以上

有时间可能会用Spring Data JPA 重写数据库逻辑（见分支overwrite）