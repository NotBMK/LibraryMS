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

    public static BookRecord fromResultSet(ResultSet resultSet) throws SQLException {
        BookRecord bookRecord = new BookRecord();
        bookRecord.book = BookDao.fromResultSet(resultSet);
        bookRecord.startDate = resultSet.getDate("startDate");
        bookRecord.endDate = resultSet.getDate("endDate");
        return bookRecord;
    }

    private interface Dao {
        AppDatabase.Executable loadAllRecord = AppDatabase.getInstance().getExecutable("SELECT * FROM Book JOIN BookNA ON BookNA.bookId=Book.id");
    }
}
