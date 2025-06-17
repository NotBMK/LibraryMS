package com.database;

import com.entities.Action;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ActionDao {

    private ActionDao() {}

    public static int insert(Action.ActType act, int userId, int bookId, Date actDate, Date endDate, String comment) {
        try {
            synchronized (Dao.insert) {
                return Dao.insert.setParams(act.getInt(), userId, bookId, actDate, endDate, comment).update();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public static List<Action> loadAllAction() {
        List<Action> actions = new ArrayList<>();
        try {
            synchronized (Dao.findAll) {
                ResultSet resultSet = Dao.findAll.query();
                while (resultSet.next()) {
                    actions.add(fromResultSet(resultSet));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return actions;
    }

    public static Action fromResultSet(ResultSet resultSet) throws SQLException {
        Action act = new Action();
        act.actType = Action.ActType.getAction(resultSet.getInt("actType"));
        act.userId = resultSet.getInt("userId");
        act.bookId = resultSet.getInt("bookId");
        act.actDate = resultSet.getDate("actDate");
        act.endDate = resultSet.getDate("endDate");
        act.comment = resultSet.getString("comment");
        return act;
    }

    private interface Dao {
        AppDatabase.Executable insert = AppDatabase.getInstance().getExecutable("insert into action values(?,?,?,?,?,?)");
        AppDatabase.Executable findAll = AppDatabase.getInstance().getExecutable("SELECT * FROM action");
    }
}
