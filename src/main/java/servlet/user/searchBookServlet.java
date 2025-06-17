package servlet.user;

import com.database.BookDao;
import com.entities.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import java.util.List;

@WebServlet("/user/searchBook")
public class searchBookServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // 设置请求和响应的字符编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 获取表单数据
        String name = request.getParameter("bookName").trim();
        String id = request.getParameter("bookId").trim();
        String kws = request.getParameter("bookKeyword").trim();

        List<Book> books = BookDao.search(id, name, kws.isEmpty() ? null : Arrays.asList(kws.split("\\s+")));
        System.out.println("Found " + books.size() + " books.");

        if (books.isEmpty()) {
            request.setAttribute("error", "未找到相关图书");
            request.getRequestDispatcher("/user/borrowBook.jsp").forward(request, response);
        } else {
            request.setAttribute("books", books);
            request.getRequestDispatcher("/user/borrowBook.jsp").forward(request, response);
        }
    }
}
