package com.database;

import com.entities.Book;
import com.entities.User;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

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

    public static List<Book> searchNA(int bookId, String bookname, int category, String comment) {
        List<Book> bookList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Book WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (bookId > 0) {
            sql.append(" AND id = ?");
            params.add(bookId);
        }

        if (bookname != null && !bookname.isEmpty()) {
            sql.append(" AND name LIKE ?");
            params.add("%" + bookname + "%");
        }

        if (category > 0) {
            sql.append(" AND categoryId = ?");
            params.add(category);
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
                Book book = new Book();
                book.id = rs.getInt("id");
                book.name = rs.getString("name");
                book.category = Book.Category.getCategory(rs.getInt("categoryId"));
                book.flag = rs.getInt("flag");
                book.price = rs.getDouble("price");
                book.comment = rs.getString("comment");

                if (book.flag > 0) {
                    // 使用接口调用 BookNA 查询
                    synchronized (Dao.findBookNAByBook) {
                        Dao.findBookNAByBook.setParams(book.id);
                        ResultSet naRs = Dao.findBookNAByBook.query();
                        if (naRs.next()) {
                            java.sql.Date endDate = naRs.getDate("endDate");
                            LocalDate today = LocalDate.now();
                            LocalDate endLocalDate = endDate.toLocalDate();

                            long daysUntilEnd = ChronoUnit.DAYS.between(today, endLocalDate);
                            book.loanPeriod = (int) daysUntilEnd;
                        } else {
                            book.loanPeriod = 0;
                        }
                    }
                } else {
                    book.loanPeriod = 0;
                }

                bookList.add(book);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return bookList;
    }



    private interface Dao {
        AppDatabase.Executable borrowBook = AppDatabase.getInstance().getExecutable("SELECT * FROM Book WHERE id = ?");
        AppDatabase.Executable getAllKeywords = AppDatabase.getInstance().getExecutable("SELECT * FROM keyword");
        AppDatabase.Executable finaByName = AppDatabase.getInstance().getExecutable("SELECT * FROM Book WHERE Book.name like CONCAT('%',?,'%')");
        AppDatabase.Executable findById = AppDatabase.getInstance().getExecutable("SELECT * FROM Book WHERE Book.id = ?");
        AppDatabase.Executable findBookNAByBook = AppDatabase.getInstance().getExecutable("SELECT * FROM BookNA WHERE bookId = ?");
    }
}
