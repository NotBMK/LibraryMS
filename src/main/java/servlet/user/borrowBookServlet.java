package servlet.user;

import com.entities.Book;
import com.database.BookDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.Arrays;
import java.util.List;

import java.io.IOException;

@WebServlet("/user/borrowBook")
public class borrowBookServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 设置请求和响应的字符编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 获取表单数据
        int borrowBookId = Integer.parseInt(request.getParameter("borrowBookId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        int userLoadPeriod = Integer.parseInt(request.getParameter("userLoanPeriod"));

        BookDao.borrowBook(userId, borrowBookId, userLoadPeriod);

        request.getRequestDispatcher("/user/borrowBook.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("bookName");
        String id = request.getParameter("bookId");

        List<Book> books = BookDao.search(id, name, null);

        if (books.isEmpty()) {
            request.setAttribute("error", "未找到相关图书");
            request.getRequestDispatcher("/user/borrowBook.jsp").forward(request, response);
        } else {
            request.setAttribute("books", books);
            request.getRequestDispatcher("/user/borrowBook.jsp").forward(request, response);
        }
    }
}
