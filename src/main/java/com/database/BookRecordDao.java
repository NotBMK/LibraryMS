package com.database;

import com.entities.BookRecord;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookRecordDao {

    private BookRecordDao() { }

    public static List<BookRecord> loadAllRecord() {
        List<BookRecord> bookRecords = new ArrayList<>();
        try {
            synchronized (Dao.loadAllRecord) {
                ResultSet resultSet = Dao.loadAllRecord.query();
                while (resultSet.next()) {
                    bookRecords.add(fromResultSet(resultSet));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookRecords;
    }

    public static boolean continueLoan(int bookId) {
        try {
            synchronized (Dao.continueLoan) {
                System.out.println(1);
                return Dao.continueLoan.setParams(bookId).update() == 1;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static List<BookRecord> getBorrowedBooksByUserId(int userId) {
        List<BookRecord> books = new ArrayList<>();
        try {
            synchronized (Dao.findByUserId) {
                ResultSet resultSet = Dao.findByUserId.setParams(userId).query();
                while (resultSet.next()) {
                    books.add(fromResultSet(resultSet));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    public static BookRecord fromResultSet(ResultSet resultSet) throws SQLException {
        BookRecord bookRecord = new BookRecord();
        bookRecord.book = BookDao.fromResultSet(resultSet);
        bookRecord.startDate = resultSet.getDate("startDate");
        bookRecord.endDate = resultSet.getDate("endDate");
        return bookRecord;
    }

    private interface Dao {
        AppDatabase.Executable loadAllRecord = AppDatabase.getInstance().getExecutable("SELECT * FROM Book JOIN BookNA ON BookNA.bookId=Book.id");
        AppDatabase.Executable continueLoan = AppDatabase.getInstance().getExecutable("UPDATE BookNA SET endDate = DATE_ADD(endDate, INTERVAL 30 DAY) WHERE BookNA.bookId = ?");
        AppDatabase.Executable findByUserId = AppDatabase.getInstance().getExecutable("SELECT * FROM Book JOIN BookNA ON BookNA.bookId=Book.id WHERE book.flag = ?");
    }
}
