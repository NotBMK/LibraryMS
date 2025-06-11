package com.database;

import java.sql.*;

public class AppDatabase {
    private static final String DB_NAME = "LMS";
    private static final String DB_CHARSET = "UTF-8";
    private static final String DB_TIMEZONE = "UTC";
    private static final String DB_URL = String.format("jdbc:mysql://localhost:3306/%s?useUnicode=true&characterEncoding=%s&serverTimezone=%s",
            DB_NAME, DB_CHARSET, DB_TIMEZONE);
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "mysql2w0t0f5";

    private static volatile  AppDatabase instance = null;

    private Connection connection;

    public static AppDatabase getInstance() {
        if (instance == null) {
            synchronized (AppDatabase.class) {
                if (instance == null) {
                    instance = new AppDatabase();
                }
            }
        }
        return instance;
    }

    private AppDatabase() {
        try {
            Class.forName(DB_DRIVER);
            connection = DriverManager.getConnection(DB_URL, USERNAME, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Executable getExecutable(final String sql) {
        try {
            return new Executable(getPreparedStatement(sql));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private PreparedStatement getPreparedStatement(final String sql, Object... params) throws SQLException {
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        for (int i = 0; i < params.length; i++) {
            preparedStatement.setObject(i + 1, params[i]);
        }
        return  preparedStatement;
    }

    public static class Executable {
        private PreparedStatement preparedStatement;

        private Executable(PreparedStatement preparedStatement) {
            this.preparedStatement = preparedStatement;
        }

        public Executable setParams(Object... params) throws SQLException {
            for (int i = 0; i < params.length; i++) {
                preparedStatement.setObject(i + 1, params[i]);
            }
            return this;
        }

        public ResultSet query() throws SQLException {
            return preparedStatement.executeQuery();
        }

        public int update() throws SQLException {
            return preparedStatement.executeUpdate();
        }
    }
}
