package com.database;

import com.entities.Book;

import java.sql.ResultSet;
import java.util.*;
import java.util.stream.Collectors;

public class BookDao {

    private BookDao() {}

    public static List<Integer> getKeywordIds(List<String> keywords) {
        List<Integer> result = new ArrayList<>();
        try {
            synchronized (Dao.findIdByKeyword) {
                for (String kw : keywords) {
                    ResultSet resultSet = Dao.findIdByKeyword.setParams(kw).query();
                    if (resultSet.next()) {
                        result.add(resultSet.getInt("id"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public static List<Book> search(String id, String name, List<String> keywords) {
        System.out.println("Start searching for books with condition{" +
                "id = " + (id == null || id.isEmpty() ? "null" : id )  + "," +
                "name = " + (name == null || name.isEmpty() ? "null" : name ) + "," +
                "keywords = " + (keywords == null || keywords.isEmpty() ? "null" : keywords) +
                "}.");

        List<Book> books = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        if (id != null && !id.isEmpty()) {
            sql.append("id = ?");
            params.add(id);
        }
        if (name != null && !name.isEmpty()) {
            if (!sql.isEmpty()) {
                sql.append(" and ");
            }
            params.add(name);
            sql.append("name like CONCAT('%', ?, '%')");
        }
        if (keywords != null && !keywords.isEmpty()) {
            List<Integer> kwIds = getKeywordIds(keywords);
            if (!kwIds.isEmpty()) {
                if (!sql.isEmpty()) {
                    sql.append(" and ");
                }
                String kwSet = kwIds.stream()
                        .map(String::valueOf)
                        .collect(Collectors.joining(","));
                sql.append("id in (SELECT BookId FROM BookKeyword WHERE keyId IN (");
                sql.append(kwSet);
                sql.append("))");
            } else {
                return books;
            }
        }
        String exe_sql = "SELECT * FROM Book";
        if (!sql.isEmpty()) {
            exe_sql = "SELECT * FROM Book WHERE " + sql.toString();
        }

        try {
            AppDatabase.Executable executable = AppDatabase.getInstance().getExecutable(exe_sql);
            if (!params.isEmpty())
                executable.setParams(params.toArray());
            ResultSet resultSet = executable.query();
            while (resultSet.next()) {
                Book book = new Book();
                book.id = resultSet.getInt("id");
                book.name = resultSet.getString("name");
                book.category = resultSet.getInt("categoryId");
                book.flag = resultSet.getInt("flag");
                book.price = resultSet.getDouble("price");
                book.comment = resultSet.getString("comment");
                books.add(book);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return books;
    }

    private interface Dao {
        AppDatabase.Executable findIdByKeyword = AppDatabase.getInstance().getExecutable("SELECT id FROM keyword WHERE keyword.keyword like CONCAT('%', ?, '%')");
        AppDatabase.Executable finaByName = AppDatabase.getInstance().getExecutable("SELECT * FROM Book WHERE Book.name like '%?%'");
        AppDatabase.Executable findById = AppDatabase.getInstance().getExecutable("SELECT * FROM Book WHERE Book.id = ?");
    }
}
