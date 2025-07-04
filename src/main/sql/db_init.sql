use dbProj;

drop table User,BookCategory,BookKeyword,Book,BookNA,Action;

CREATE TABLE IF NOT EXISTS User(
    id int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name varchar(64) NOT NULL,
    pass varchar(32) NOT NULL,
    type int DEFAULT 0,
    gender int DEFAULT 0,
    borrowCount int DEFAULT 0,
    loanPeriod int DEFAULT 30,
    comment varchar(256),
    fine float DEFAULT 0
);

CREATE TABLE IF NOT EXISTS BookCategory(
    id int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name varchar(64) NOT NULL
);

CREATE TABLE IF NOT EXISTS Keyword(
    id int PRIMARY KEY AUTO_INCREMENT,
    keyword varchar(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS Book(
    id int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name varchar(64) NOT NULL,
    price double NOT NULL DEFAULT 0,
    categoryId int NOT NULL,
    flag int DEFAULT -1,
    comment varchar(256)
);

CREATE TABLE IF NOT EXISTS BookKeyword(
    bookId int NOT NULL,
    keyId int NOT NULL,
    FOREIGN KEY (bookId) REFERENCES Book(id)
        ON UPDATE CASCADE,
    FOREIGN KEY (keyId) REFERENCES Keyword(id)
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS BookNA(
    bookId int PRIMARY KEY NOT NULL,
    startDate DATE NOT NULL ,
    endDate DATE,
    FOREIGN KEY (bookId) REFERENCES Book(id) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Action(
    actType int NOT NULL,
    userId int,
    bookId int NOT NULL,
    actDate Date NOT NULL ,
    endDate Date,
    comment varchar(256)
)