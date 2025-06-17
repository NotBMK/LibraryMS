package com.database;

import com.entities.Book;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;

public class BookDao {

    private BookDao() {}

    public static boolean borrowBook(int userId, int bookId, int period) {
        boolean res = false;
        try {
           synchronized (Dao.insertBorrowBook) {
               res = Dao.insertBorrowBook.setParams(bookId, period).update() == 1 && Dao.borrowBook.setParams(userId, bookId).update() == 1;
           }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return res && UserDao.updateUserBorrowCount(userId);
    }

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

    public static List<Book> search(String id, String name, List<String> keywords) {
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
            sql.append("name like CONCAT('%',?,'%')");
        }
        if (keywords != null && !keywords.isEmpty()) {
            List<Integer> kwIds = getKeywordsId(keywords);
            if (!kwIds.isEmpty()) {
                if (!sql.isEmpty()) {
                    sql.append(" and ");
                }
                String kwSet = kwIds.stream()
                        .map(String::valueOf)
                        .collect(Collectors.joining(","));
                sql.append("id in (SELECT BookId FROM BookKeyword WHERE keyId IN (");
                sql.append( kwSet);
                sql.append("))");
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
                books.add(fromResultSet(resultSet));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return books;
    }
    public static List<Book> getBorrowedBooksByUserId(int userId) {
        List<Book> books = new ArrayList<>();
        // SQL 查询获取用户借阅的书籍（未归还）
        String sql = "SELECT b.* FROM Book b JOIN BookNa bn ON bn.bookId = b.id WHERE b.flag = ?" ;

        try {
            // 使用 AppDatabase 执行查询
            AppDatabase.Executable executable = AppDatabase.getInstance().getExecutable(sql);
            executable.setParams(userId); // 设置用户ID参数

            ResultSet resultSet = executable.query();
            while (resultSet.next()) {
                books.add(fromResultSet(resultSet));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return books;
    }

    public static Book fromResultSet(ResultSet resultSet) throws SQLException {
        Book book = new Book();
        book.id = resultSet.getInt("id");
        book.name = resultSet.getString("name");
        book.category = Book.Category.getCategory(resultSet.getInt("categoryId"));
        book.flag = resultSet.getInt("flag");
        book.price = resultSet.getDouble("price");
        book.comment = resultSet.getString("comment");
        return book;
    }

    private static List<Integer> getKeywordsId(List<String> keywords) {
        List<Integer> ids = new ArrayList<>();
        String cond = String.join(",", Collections.nCopies(keywords.size(), "?"));
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
        AppDatabase.Executable insertBorrowBook = AppDatabase.getInstance().getExecutable("INSERT INTO BookNA VALUES(?,NOW(),DATE_ADD(NOW(),INTERVAL ? DAY))");
        AppDatabase.Executable borrowBook = AppDatabase.getInstance().getExecutable("UPDATE Book SET flag = ? WHERE id = ?");
        AppDatabase.Executable getAllKeywords = AppDatabase.getInstance().getExecutable("SELECT * FROM keyword");
        AppDatabase.Executable finaByName = AppDatabase.getInstance().getExecutable("SELECT * FROM Book WHERE Book.name like CONCAT('%',?,'%')");
        AppDatabase.Executable findById = AppDatabase.getInstance().getExecutable("SELECT * FROM Book WHERE Book.id = ?");
    }
}
