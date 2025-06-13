package com.database;

import com.entities.User;

import java.sql.ResultSet;

public class UserDao {

    private UserDao() {}

    public static boolean register(User user, String password) {
        try {
            synchronized (Dao.getName) {
                if (Dao.getName.setParams(user.name).query().next()) {
                    return false;
                }
            }
            synchronized (Dao.register) {
                return Dao.register.setParams(user.name, password, User.Type.READER.getInt(), user.gender.getInt()).update() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean login(User user, String pass) {
        try {
            synchronized (Dao.login) {
                ResultSet resultSet = Dao.login.setParams(user.name).query();
                String true_password = resultSet.getString("pass");
                if (resultSet.next()) {
                    user.id = resultSet.getInt("id");
                    user.name = resultSet.getString("name");
                    user.type = User.Type.fromInt(resultSet.getInt("type"));
                    user.gender = User.Gender.fromInt(resultSet.getInt("gender"));
                    user.bookAmount = resultSet.getInt("book_amount");
                    user.loanPeriod = resultSet.getInt("loan_period");
                    user.comment = resultSet.getString("comment");
                }
                return pass.equals(true_password);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private interface Dao {
        AppDatabase.Executable getName = AppDatabase.getInstance().getExecutable("SELECT name FROM User WHERE name=?");
        AppDatabase.Executable login = AppDatabase.getInstance().getExecutable("SELECT DISTINCT(*) FROM User WHERE name=?");
        AppDatabase.Executable register = AppDatabase.getInstance().getExecutable("INSERT INTO User(name, pass, type, gender) VALUES (?, ?, ?, ?)");
    }
}
