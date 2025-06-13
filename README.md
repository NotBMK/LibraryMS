# 东华大学数据库课程设计

## 复杂说一下我的想法
1. User一个表：User
2. Book三个表：Book，Keyword，BookKeyword，后两个表用于简化查询
3. 还需要一个Action表，用来表示所有与用户和书籍相关的动作

### User
| Key        | Type         | Details                             |
|:-----------|:-------------|:------------------------------------|
| id         | int          | PRIMARY KEY NOT NULL AUTO_INCREMENT |
| name       | varchar(64)  | PRIMARY KEY NOT NULL                |
| pass       | varchar(32)  | NOT NULL                            |
| type       | int          | DEFAULT 0                           |
| gender     | int          | DEFAULT 0                           |
| borrow_cnt | int          | DEFAULT 0                           |
| loanPeriod | int          | DEFAULT 30                          |
| comment    | varchar(256) |                                     |
### Book
| Key        | Type         | Details                               |
|:-----------|:-------------|:--------------------------------------|
| id         | int          | PRIMARY KEY NOT NULL AUTO_INCREMENT   |
| categoryId | int          | FOREIGN KEY REFERENCES (BookCategory) |
| flag       | int          | \>0->UserId <0->status                |
| comment    | varchar(256) |                                       |
### BookCategory
| Key   | Type         | Details                   |
|:------|:-------------|:--------------------------|
| id    | int          | PRIMARY KEY NOT NULL AUTO |
| name  | varchar(64)  | PRIMARY KEY NOT NULL      |

### Keyword
| Key   | Type         | Details                             |
|:------|:-------------|:------------------------------------|
| id    | int          | PRIMARY KEY NOT NULL AUTO_INCREMENT |
| value | varchar(320) | PRIMARY KEY NOT NULL                |
### BookKeyword
| Key    | Type | Details                          |
|:-------|:-----|:---------------------------------|
| bookId | int  | FOREIGN KEY REFERENCES (Book)    |
| keyId  | int  | FOREIGN KEY REFERENCES (Keyword) |
### BookNA
| Key         | Type | Details |
|:------------|:-----|:--------|
| userId      | int  |         |
| bookId      | int  |         |
| startDate   | Date |         |
| endDate     | Date |         |
### Action
| Key     | Type         | Details                               |
|:--------|:-------------|:--------------------------------------|
| actType | int          | NOT NULL                              |
| userId  | int          | FOREIGN KEY REFERENCES (User)         |
| bookId  | int          | FOREIGN KEY REFERENCES (BookCategory) |
| actDate | Date         | NOT NULL                              |
| endDate | Date         | NOT NULL                              |
| comment | varchar(256) |                                       |