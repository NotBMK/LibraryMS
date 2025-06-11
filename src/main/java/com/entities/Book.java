package com.entities;

import java.util.HashSet;
import java.util.Set;

public class Book {
    public int id;
    public int category;
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
