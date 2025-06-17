package com.entities;

import java.sql.Date;

public class Action {

    public ActType actType;
    public int userId;
    public int bookId;
    public Date actDate;
    public Date endDate;
    public String comment;

    public enum ActType {
        BORROW_BOOK("图书借出"),
        RETURN_BOOK("图书归还"),
        ADD_BOOK("图书入库"),
        DEL_BOOK("图书出库"),

        DAMAGE_BOOK("图书损坏"),
        BOOK_LOST("图书丢失");

        private final String value;

        ActType(String value) {
            this.value = value;
        }

        public String toString() {
            return value;
        }

        public int getInt() {
            return ordinal();
        }

        public static ActType getAction(int action_type) {
            return values()[action_type];
        }
    }
}
