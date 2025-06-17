package servlet.user;

import com.entities.Book;
import com.database.BookDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/user/returnBook")

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
        List<Book> borrowedBooks = BookDao.getBorrowedBooksByUserId(userId);

        // 将结果存入request属性
        request.setAttribute("borrowedBooks", borrowedBooks);

        // 转发到归还图书页面
        request.getRequestDispatcher("/user/returnBook.jsp").forward(request, response);
    }
}