package com.entities;

public class User {
    public int id;
    public String name;
    public String pass;
    public Type type = Type.READER;
    public Gender gender =  Gender.OTHER;
    public int bookAmount = 0;
    public int loanPeriod = 30;
    public String comment;

    public enum Type {
        READER(0),
        S_READER(1),
        ADMIN(2),
        ROOT(3);
        // TODO

        private final int value;

        Type(int value) {
            this.value = value;
        }

        public static Type fromInt(int value) {
            return values()[value];
        }

        public int getInt() {
            return value;
        }

        public String toString() {
            return Integer.toString(value);
        }
    }

    public enum Gender {
        MALE(0),
        FEMALE(1),
        OTHER(2);

        private final int value;

        Gender(int value) {
            this.value = value;
        }

        public static Gender fromInt(int value) {
            return Gender.values()[value];
        }

        public int getInt() {
            return value;
        }

        public String toString() {
            return Integer.toString(value);
        }
    }
}
