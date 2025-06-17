package com.database;

import com.entities.User;

import java.sql.ResultSet;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
                return Dao.updateUserInfo.setParams( user.name,  user.gender.getInt(), user.comment,user.type.getInt(), user.id).update() == 1;
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

    public static boolean adminRegisterUser(User user, String password){
        try {
            if (isExist(user.name)) {
                return false;
            }
            synchronized (Dao.adminRegister) {
                if( Dao.adminRegister.setParams(user.name, password, User.Type.READER.getInt(), user.gender.getInt(),user.comment).update() == 1){
                    ResultSet rs = Dao.getLastInsertId.query();
                    if (rs.next()) {
                        user.id = rs.getInt(1);
                    } else {
                        throw new RuntimeException("无法获取刚插入用户的ID");
                    }

                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static List<User> searchUsers(int userId, String username, User.Gender gender, String comment) {
        List<User> userList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM User WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (userId > 0) {
            sql.append(" AND id = ?");
            params.add(userId);
        }

        if (username != null && !username.isEmpty()) {
            sql.append(" AND name LIKE ?");
            params.add("%" + username + "%");
        }

        if (gender != null) {
            sql.append(" AND gender = ?");
            params.add(gender.getInt());
        }

        if (comment != null && !comment.isEmpty()) {
            sql.append(" AND comment LIKE ?");
            params.add("%" + comment + "%");
        }

        try {
                AppDatabase.Executable executable = AppDatabase.getInstance().getExecutable(sql.toString());
                if (!params.isEmpty()) {
                    executable.setParams(params.toArray());
                }
                ResultSet rs = executable.query();
                while (rs.next()) {
                    User user = new User();
                    user.id = rs.getInt("id");
                    user.name = rs.getString("name");
                    user.type = User.Type.fromInt(rs.getInt("type"));
                    user.gender = User.Gender.fromInt(rs.getInt("gender"));
                    user.bookAmount = rs.getInt("borrowCount");
                    user.loanPeriod = rs.getInt("loanPeriod");
                    user.comment = rs.getString("comment");
                    userList.add(user);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return userList;
    }

    public static boolean updateUserBorrowCount (int userId) {
        synchronized (Dao.increaseUserBorrowCount) {
            try {
                return Dao.increaseUserBorrowCount.setParams(userId).update() == 1;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public static List<User> loadAllReader() {
        List<User> userList = new ArrayList<>();
        try {
            synchronized (Dao.loadAllReader) {
                ResultSet rs = Dao.loadAllReader.query();
                while (rs.next()) {
                    userList.add(fromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }

    public static User fromResultSet(ResultSet resultSet) throws SQLException {
        User user = new User();
        user.id = resultSet.getInt("id");
        user.name = resultSet.getString("name");
        user.type = User.Type.fromInt(resultSet.getInt("type"));
        user.gender = User.Gender.fromInt(resultSet.getInt("gender"));
        user.bookAmount = resultSet.getInt("borrowCount");
        user.loanPeriod = resultSet.getInt("loanPeriod");
        user.comment = resultSet.getString("comment");
        return user;
    }

    private interface Dao {
        AppDatabase.Executable loadAllReader = AppDatabase.getInstance().getExecutable("SELECT * FROM User WHERE type = 0");
        AppDatabase.Executable increaseUserBorrowCount = AppDatabase.getInstance().getExecutable("UPDATE User SET borrowCount=borrowCount+1 WHERE id=?");
        AppDatabase.Executable getName = AppDatabase.getInstance().getExecutable("SELECT name FROM User WHERE name=?");
        AppDatabase.Executable login = AppDatabase.getInstance().getExecutable("SELECT * FROM User WHERE name=?");
        AppDatabase.Executable register = AppDatabase.getInstance().getExecutable("INSERT INTO User(name, pass, type, gender) VALUES (?, ?, ?, ?)");
        AppDatabase.Executable getUserById = AppDatabase.getInstance().getExecutable("SELECT * FROM User WHERE id=?");
        AppDatabase.Executable updateUserInfo = AppDatabase.getInstance().getExecutable("UPDATE User SET name=?, gender=?, comment=?,type=? WHERE id=?");
        AppDatabase.Executable updatePassword = AppDatabase.getInstance().getExecutable("UPDATE User SET pass=? WHERE id=?");
        AppDatabase.Executable adminRegister = AppDatabase.getInstance().getExecutable("INSERT INTO User(name, pass, type, gender, comment) VALUES (?, ?, ?, ?,?)");
        AppDatabase.Executable getLastInsertId = AppDatabase.getInstance().getExecutable("SELECT LAST_INSERT_ID()");
    }
}