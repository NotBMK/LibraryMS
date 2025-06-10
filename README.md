# 东华大学数据库课程设计

## 简单说一下我的想法
1. User一个表：User
2. Book三个表：Book，BookCategory，BookKeyword，后两个表用于查询优化
3. 还需要一个Action表，用来表示所有与用户和书籍相关的动作

### User
| Key        | Type         | Details              |
|:-----------|:-------------|:---------------------|
| id         | int          | PRIMARY KEY NOT NULL |
| type       | int          | DEFAULT 0            |
| gender     | int          | DEFAULT 0            |
| borrow     | int          | DEFAULT 0            |
| loadPeriod | int          | DEFAULT 30           |
| comment    | varchar(256) |                      |
### Book
| Key        | Type         | Details                               |
|:-----------|:-------------|:--------------------------------------|
| id         | int          | PRIMARY KEY NOT NULL                  |
| categoryId | int          | FOREIGN KEY REFERENCES (BookCategory) |
| keywords   | varchar(256) | Keyword seperated with '#'            |
| comment    | varchar(256) |                                       |
### Action
| Key     | Type         | Details                               |
|:--------|:-------------|:--------------------------------------|
| UserId  | int          | FOREIGN KEY REFERENCES (User)         |
| BookId  | int          | FOREIGN KEY REFERENCES (BookCategory) |
| ActDate | Date         | NOT NULL                              |
| EndDate | Date         | NOT NULL                              |
| comment | varchar(256) |                                       |