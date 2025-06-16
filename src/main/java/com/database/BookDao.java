package com.database;

import com.entities.Book;

import java.sql.ResultSet;
import java.util.*;

public class BookDao {

    private BookDao() {}

    public static List<Book.Keyword> getAllKeywords() {
        List<Book.Keyword> keywords = new ArrayList<>();
        try {
            synchronized (Dao.getAllKeywords) {
                ResultSet resultSet = Dao.getAllKeywords.query();
                while (resultSet.next()) {
                    Book.Keyword keyword = new Book.Keyword();
                    keyword.id = resultSet.getInt("id");
                    keyword.keyword = resultSet.getString("keyword");
                    keywords.add(keyword);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return keywords;
    }

    public static List<Book> search(String id, String name, List<Integer> keywords) {
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
            sql.append("name like %?%");
        }
        if (keywords != null && !keywords.isEmpty()) {
            if (!sql.isEmpty()) {
                sql.append(" and ");
            }
            params.addAll(Arrays.asList(keywords));
            String[] kws = new String[keywords.size()];
            for (int i = 0; i < kws.length; i++) {
                kws[i] = keywords.get(i).toString();
            }
            sql.append("id in (SELECT BookId FROM BookKeyword WHERE keyId IN (");
            sql.append(String.join(",", kws));
            sql.append("))");
        }
        String exe_sql = "SELECT * FROM Book";
        if (!sql.isEmpty()) {
            exe_sql = "SELECT * FROM Book WHERE " + sql.toString();
        }

        try {
            System.out.println(exe_sql);
            AppDatabase.Executable executable = AppDatabase.getInstance().getExecutable(exe_sql);
            if (!params.isEmpty())
                executable.setParams(Arrays.asList(params.toArray()));
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

    private static List<Integer> getKeywordsId(String... keywords) {
        List<Integer> ids = new ArrayList<>();
        String cond = String.join(",", Collections.nCopies(keywords.length, "?"));
        String sql = "SELECT id FROM keywords WHERE name in (" + cond + ")";
        try {
            AppDatabase.Executable executable = AppDatabase.getInstance().getExecutable(sql);
            ResultSet resultSet = executable.query();
            if (resultSet.next()) {
                ids.add(resultSet.getInt("id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ids;
    }

    private interface Dao {
        AppDatabase.Executable getAllKeywords = AppDatabase.getInstance().getExecutable("SELECT * FROM keyword");
        AppDatabase.Executable finaByName = AppDatabase.getInstance().getExecutable("SELECT * FROM Book WHERE Book.name like '%?%'");
        AppDatabase.Executable findById = AppDatabase.getInstance().getExecutable("SELECT * FROM Book WHERE Book.id = ?");
    }
}
