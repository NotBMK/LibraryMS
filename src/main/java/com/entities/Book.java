package com.entities;

public class Book {
    public static final int GOOD = -1;
    public static final int BROKEN = -2;
    public static final int LOST = -3;

    public int id;
    public String name;
    public Category category;
    public int flag = GOOD;
    public double price;
    public String comment;

    public enum Category {
        NOVEL("小说"),
        POETRY("诗歌"),
        BIOGRAPHY("传记"),
        TEXT("教科书"),
        REFERENCE("参考书");


        public final String value;

        Category(String value) {
            this.value = value;
        }

        public static Category getCategory(int value) {
            return values()[value];
        }

        public String toString() {
            return value;
        }
    }

    public static class Keyword {
        public int id;
        public String keyword;

        public String toString() {
            return keyword;
        };
    }

    public String toString() {
        return String.format("%d,%s,%s,%d,%.2f,%s", id, name, category, flag, price, comment);
    }

    public String getFlagDisplay(){
        if(flag == -1){
            return "可借阅";
        }
        else if(flag > 0){
            return "用户ID为："+flag+"的用户正在借阅此书";
        }
        else
            return "该书已损坏或丢失，不在库";
    }


}
