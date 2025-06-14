package com.database;

import com.entities.Book;
import java.util.List;
import java.util.ArrayList;

import java.sql.ResultSet;

public class BookDao {

    private BookDao() {}

    public static List<Book> search(String condition) {
        List<Book> books = new ArrayList<>();
        try {
            synchronized (BookDao.Dao.search) {
                ResultSet resultSet = BookDao.Dao.search.setParams(condition).query();
                while (resultSet.next()) {
                    Book book = new Book();
                    book.id = resultSet.getInt("id");
                    book.name = resultSet.getString("name");
                    //user.gender = User.Gender.fromInt(resultSet.getInt("gender"));
                    book.category = resultSet.getInt("categoryId");
                    book.flag = resultSet.getInt("flag");
                    book.comment = resultSet.getString("comment");
                    books.add(book);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return books;
    }

    private interface Dao {
        AppDatabase.Executable search = AppDatabase.getInstance().getExecutable("SELECT * FROM Book WHERE ?");
        AppDatabase.Executable login = AppDatabase.getInstance().getExecutable("SELECT * FROM User WHERE name=?");
        AppDatabase.Executable register = AppDatabase.getInstance().getExecutable("INSERT INTO User(name, pass, type, gender) VALUES (?, ?, ?, ?)");
    }
}
