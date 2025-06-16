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
        String name = request.getParameter("bookName");
        String id = request.getParameter("bookId");
        List<Integer> kws = (List<Integer>) request.getSession().getAttribute("skws");

        System.out.println("Received - bookId: " + (id == null || id.isEmpty() ? "null" : id) + ", bookName: " + name + "kws: " + kws);

        List<Book> books = BookDao.search(id, name, kws);
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
