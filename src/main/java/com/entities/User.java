package com.entities;

public class User {
    int id;
    Type type = Type.READER;
    Gender gender =  Gender.OTHER;
    int bookAmount = 0;
    int loanPeriod = 30;
    String comment;


    public enum Type {
        READER,ADMIN,ROOT
    }

    public enum Gender {
        MALE,FEMALE,OTHER
    }
}
