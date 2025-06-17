package com.entities;

public class User {
    public int id;
    public String name;
//    public String pass;
    public Type type = Type.READER;
    public Gender gender =  Gender.OTHER;
    public int bookAmount = 0;
    public int loanPeriod = 30;
    public String comment;

    public enum Type {
        READER,
        ADMIN,
        ROOT;

        public static Type fromInt(int value) {
            return values()[value];
        }

        public int getInt() {
            return this.ordinal();
        }

        public String toString() {
            return Integer.toString(ordinal());
        }
    }

    public enum Gender {
        MALE,
        FEMALE,
        OTHER;

        public static Gender fromInt(int value) {
            return Gender.values()[value];
        }

        public int getInt() {
            return ordinal();
        }

        public String toString() {
            return Integer.toString(ordinal());
        }
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Type getType() {
        return type;
    }

    public void setType(Type type) {
        this.type = type;
    }

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public int getBookAmount() {
        return bookAmount;
    }

    public void setBookAmount(int bookAmount) {
        this.bookAmount = bookAmount;
    }

    public int getLoanPeriod() {
        return loanPeriod;
    }

    public void setLoanPeriod(int loanPeriod) {
        this.loanPeriod = loanPeriod;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getGenderDisplay() {
        return switch (this.gender) {
            case MALE -> "男";
            case FEMALE -> "女";
            default -> "其他";
        };
    }

    public String getTypeDisplay() {
        return switch (this.type) {
            case ADMIN -> "管理员";
            case ROOT -> "超级管理员";
            default -> "普通用户";
        };
    }

}
