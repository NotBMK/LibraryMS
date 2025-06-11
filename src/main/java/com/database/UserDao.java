package com.database;

import com.entities.User;

import java.sql.ResultSet;

public class UserDao {

    private UserDao() {}

    public static boolean register(User user) {
        try {
            synchronized (Dao.getName) {
                if (Dao.getName.setParams(user.name).query().next()) {
                    return false;
                }
            }
            synchronized (Dao.register) {
                return Dao.register.setParams(user.name, user.pass, User.Type.READER.getInt(), user.gender.getInt()).update() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean login(User user) {
        try {
            synchronized (Dao.login) {
                ResultSet resultSet = Dao.login.setParams(user.name, user.pass).query();
                if (resultSet.next()) {
                    user.id = resultSet.getInt("id");
                    user.name = resultSet.getString("name");
                    user.pass = resultSet.getString("pass");
                    user.type = User.Type.fromInt(resultSet.getInt("type"));
                    user.gender = User.Gender.fromInt(resultSet.getInt("gender"));
                    user.bookAmount = resultSet.getInt("book_amount");
                    user.loanPeriod = resultSet.getInt("loan_period");
                    user.comment = resultSet.getString("comment");
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private interface Dao {
        AppDatabase.Executable getName = AppDatabase.getInstance().getExecutable("SELECT name FROM User WHERE name=?");
        AppDatabase.Executable login = AppDatabase.getInstance().getExecutable("SELECT DISTINCT(*) FROM User WHERE name=? AND pass=?");
        AppDatabase.Executable register = AppDatabase.getInstance().getExecutable("INSERT INTO User(name, pass, type, gender) VALUES (?, ?, ?, ?)");
    }
}
