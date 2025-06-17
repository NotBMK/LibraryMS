package com.database;

import com.entities.Action;
import com.entities.Book;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;
import java.time.temporal.ChronoUnit;

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
        if (res && UserDao.updateUserBorrowCount(userId)) {
            ActionDao.insert(Action.ActType.BORROW_BOOK, userId, bookId, Date.valueOf(LocalDate.now()), Date.valueOf(LocalDate.now().plusDays(period)), "");
            return true;
        }
        return false;
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
            List<Integer> kwIds = getKeywordIds(keywords);
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
            System.out.println(exe_sql);
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

    private static List<Integer> getKeywordIds(List<String> keywords) {
        List<Integer> ids = new ArrayList<>();
        try {
            synchronized (Dao.findIdsByKeyword) {
                for (String kw : keywords) {
                    ResultSet resultSet = Dao.findIdsByKeyword.setParams(kw).query();
                    if (resultSet.next()) {
                        ids.add(resultSet.getInt("id"));
                    }
                }
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

    public static boolean updateBookInfo(Book book) {
        try {
            synchronized (Dao.updateBookInfo) {
                Dao.updateBookInfo.setParams(
                        book.name,
                        book.category.ordinal(), // 枚举转 int
                        book.price,
                        book.comment,
                        book.id
                );
                return Dao.updateBookInfo.update()==1;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static Book getBookById(int bookId) {
        try {
            synchronized (Dao.findById) {
                Dao.findById.setParams(bookId);
                ResultSet rs = Dao.findById.query();
                if (rs.next()) {
                    return fromResultSet(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static boolean addBook(Book book) {
        try {
            synchronized (Dao.addBook) {
                Dao.addBook.setParams(
                        book.name,
                        book.category.ordinal(),
                        book.price,
                        book.comment != null ? book.comment : "",
                        book.flag
                );
                Dao.addBook.update();
                ResultSet rs = Dao.getLastInsertId.query();

                if (rs.next()) {
                    book.id = rs.getInt(1);
                    //System.out.println("Book added with ID: " + book.id);
                }
            }
            ActionDao.insert(Action.ActType.ADD_BOOK, -1, book.id, Date.valueOf(LocalDate.now()), null, "图书入库");
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private interface Dao {
        AppDatabase.Executable findIdsByKeyword = AppDatabase.getInstance().getExecutable("SELECT id FROM keyword WHERE keyword.keyword like CONCAT('%',?,'%')");
        AppDatabase.Executable insertBorrowBook = AppDatabase.getInstance().getExecutable("INSERT INTO BookNA VALUES(?,NOW(),DATE_ADD(NOW(),INTERVAL ? DAY))");
        AppDatabase.Executable borrowBook = AppDatabase.getInstance().getExecutable("UPDATE Book SET flag = ? WHERE id = ?");
        AppDatabase.Executable finaByName = AppDatabase.getInstance().getExecutable("SELECT * FROM Book WHERE Book.name like CONCAT('%',?,'%')");
        AppDatabase.Executable findById = AppDatabase.getInstance().getExecutable("SELECT * FROM Book WHERE Book.id = ?");
        AppDatabase.Executable findBookNAByBook = AppDatabase.getInstance().getExecutable("SELECT * FROM BookNA WHERE bookId = ?");
        AppDatabase.Executable updateBookInfo = AppDatabase.getInstance().getExecutable(
                "UPDATE Book SET name=?, categoryId=?,  price=?, comment=? WHERE id=?"
        );
        AppDatabase.Executable addBook = AppDatabase.getInstance().getExecutable(
                "INSERT INTO Book(name, categoryId, price, comment, flag) VALUES (?, ?, ?, ?, ?)"
        );
        AppDatabase.Executable getLastInsertId = AppDatabase.getInstance().getExecutable("SELECT LAST_INSERT_ID()");
    }
}
