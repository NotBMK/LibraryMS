package com.entities;

import java.util.Set;

public class Book {
    public int id;
    public int categoryId;
    public Set<Integer> keywordIds;
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
        public String literal;

        public String toString() {
            return literal;
        }
    }
}
