use dbProj;

CREATE TABLE IF NOT EXISTS User(
    id int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name varchar(64) NOT NULL,
    pass varchar(32) NOT NULL,
    type int DEFAULT 0,
    gender int DEFAULT 0,
    borrowCount int DEFAULT 0,
    loanPeriod int DEFAULT 30,
    comment varchar(256)
);

CREATE TABLE IF NOT EXISTS BookCategory(
    id int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name varchar(64) NOT NULL
);

CREATE TABLE IF NOT EXISTS Keyword(
    id int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    literal varchar(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS Book(
    id int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name varchar(64) NOT NULL,
    categoryId int NOT NULL,
    flag int DEFAULT -1,
    comment varchar(256),
    FOREIGN KEY (categoryId) REFERENCES BookCategory(id) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS BookKeyword(
    bookId int NOT NULL,
    keyId int NOT NULL,
    FOREIGN KEY (bookId) REFERENCES Book(id) ON UPDATE CASCADE,
    FOREIGN KEY (keyId) REFERENCES Keyword(id) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS BookNA(
    bookId int PRIMARY KEY NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    FOREIGN KEY (bookId) REFERENCES Book(id) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Action(
    actType int NOT NULL,
    userId int NOT NULL,
    bookId int NOT NULL,
    actDate Date NOT NULL,
    endDate Date NOT NULL,
    comment varchar(256)
)
