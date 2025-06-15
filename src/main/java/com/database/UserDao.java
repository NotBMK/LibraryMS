package com.database;

import com.entities.User;

import java.sql.ResultSet;

public class UserDao {

    private UserDao() {}

    public static boolean isExist(String name) {
        try {
            synchronized (Dao.getName) {
                return Dao.getName.setParams(name).query().next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean register(User user, String password) {
        try {
            if (isExist(user.name)) {
                return false;
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
                String true_password = "";
                if (resultSet.next()) {
                    user.id = resultSet.getInt("id");
                    user.name = resultSet.getString("name");
                    true_password = resultSet.getString("pass");
                    user.type = User.Type.fromInt(resultSet.getInt("type"));
                    user.gender = User.Gender.fromInt(resultSet.getInt("gender"));
                    user.bookAmount = resultSet.getInt("borrowCount");
                    user.loanPeriod = resultSet.getInt("loanPeriod");
                    user.comment = resultSet.getString("comment");
                }
                return pass.equals(true_password);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean getUserInfoById(User user, int userId) {
        try {
            synchronized (Dao.getUserById) {
                ResultSet resultSet = Dao.getUserById.setParams(userId).query();
                if (resultSet.next()) {
                    user.id = resultSet.getInt("id");
                    user.name = resultSet.getString("name");
                    //System.out.println("666"+user.name);
                    user.type = User.Type.fromInt(resultSet.getInt("type"));
                    user.gender = User.Gender.fromInt(resultSet.getInt("gender"));
                    user.bookAmount = resultSet.getInt("borrowCount");
                    user.loanPeriod = resultSet.getInt("loanPeriod");
                    user.comment = resultSet.getString("comment");
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean updateUserInfo(User user) {
        try {
            synchronized (Dao.updateUserInfo) {
                return Dao.updateUserInfo.setParams( user.name,  user.gender.getInt(), user.comment, user.id).update() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean checkPassword(User user, String pass) {
        try {
            synchronized (Dao.login) {
                ResultSet resultSet = Dao.login.setParams(user.name).query();
                String true_password = "";
                if (resultSet.next()) {
                    true_password = resultSet.getString("pass");
                }
                return pass.equals(true_password);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean updatePassword(User user, String new_password) {
        try {
            synchronized (Dao.updatePassword) {
                return Dao.updatePassword.setParams(new_password, user.id).update() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }



    private interface Dao {
        AppDatabase.Executable getName = AppDatabase.getInstance().getExecutable("SELECT name FROM User WHERE name=?");
        AppDatabase.Executable login = AppDatabase.getInstance().getExecutable("SELECT * FROM User WHERE name=?");
        AppDatabase.Executable register = AppDatabase.getInstance().getExecutable("INSERT INTO User(name, pass, type, gender) VALUES (?, ?, ?, ?)");
        AppDatabase.Executable getUserById = AppDatabase.getInstance().getExecutable("SELECT * FROM User WHERE id=?");
        AppDatabase.Executable updateUserInfo = AppDatabase.getInstance().getExecutable("UPDATE User SET name=?, gender=?, comment=? WHERE id=?");
        AppDatabase.Executable updatePassword = AppDatabase.getInstance().getExecutable("UPDATE User SET pass=? WHERE id=?");
    }
}