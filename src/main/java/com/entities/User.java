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
}
