package com.entities;

import java.util.HashSet;
import java.util.Set;

public class Book {
    public static final int GOOD = -1;
    public static final int BROKEN = -2;
    public static final int LOST = -3;

    public int id;
    public String name;
    public int category;
    public int flag = GOOD;
    public Set<Integer> keywords = new HashSet<>();
    public String comment;

    public static class Category {
        public int id;
        public String name;

        public String toString() {
            return name;
        }
    }

    public static class Keyword {
        public int BookId;
        public String keyword;
    }
}
