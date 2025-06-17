package com.entities;

public class Book {
    public static final int GOOD = -1;
    public static final int BROKEN = -2;
    public static final int LOST = -3;

    public int id;
    public String name;
    public int category;
    public int flag = GOOD;
    public double price;
    public String comment;

    public static class Category {
        public int id;
        public String name;

        public String toString() {
            return name;
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
        return String.format("%d,%s,%s,%s,%.2f,%s", id, name, category, flag == -1 ? "GOOD" : "BAD", price, comment);
    }
}
