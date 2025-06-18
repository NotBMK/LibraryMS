package servlet.user;

import com.database.BookRecordDao;
import com.database.UserDao;
import com.entities.Book;
import com.database.BookDao;
import com.entities.BookRecord;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "returnBookServlet", value = "/user/returnBook")

public class returnBookServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 设置请求和响应的字符编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 从session中获取当前用户ID
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");

        // 获取当前用户的借阅书籍
        List<BookRecord> borrowedBooks = BookRecordDao.getBorrowedBooksByUserId(userId);

        // 计算每本书的逾期天数和罚金
        for (BookRecord record : borrowedBooks) {
            // 确保图书价格已加载（如果BookRecordDao未加载价格）
            if (record.book != null && record.book.price == 0) {
                Book fullBook = BookDao.getBookById(record.book.id);
                if (fullBook != null) {
                    record.book.price = fullBook.price;
                }
            }
        }

        // 将结果存入request属性
        request.setAttribute("borrowedBooks", borrowedBooks);

        // 转发到归还图书页面
        request.getRequestDispatcher("/user/returnBook.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        // 获取用户ID和图书ID数组
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");
        String[] bookIds = request.getParameterValues("bookId");

        boolean allSuccess = true;
        double totalFine = 0.0;

        List<BookRecord> records = BookRecordDao.getBorrowedBooksByUserId(userId);

        for (String bookIdStr : bookIds) {
            int bookId = Integer.parseInt(bookIdStr);
            // 查找对应的借阅记录
            BookRecord record = null;
            for (BookRecord r : records) {
                if (r.book.id == bookId) {
                    record = r;
                    break;
                }
            }
            // 使用BookRecord的方法计算罚金
            double fine = (record != null) ? record.calculateFine() : 0.0;

            if (BookDao.returnBook(userId, bookId)) {
                totalFine += fine;
            } else {
                allSuccess = false;
            }
        }
        // 更新用户罚金
        if (totalFine > 0) {
            UserDao.addUserFine(userId, totalFine);
        }
        // 返回JSON响应
        response.getWriter().print("{\"success\":" + allSuccess + ", \"totalFine\":" + totalFine + "}");
    }
}