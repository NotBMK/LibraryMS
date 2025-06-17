package servlet.admin;

import com.database.BookDao;
import com.entities.Book;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/searchBooks")
public class searchBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置字符编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();

        // 检查用户是否已登录且为管理员
        if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 获取搜索条件
        String bookIdStr = request.getParameter("bookId");
        String bookname = request.getParameter("bookname");
        String categoryStr = request.getParameter("category");
        String comment = request.getParameter("comment");

        int bookId = 0;
        boolean useBookId = false;
        if (bookIdStr != null && !bookIdStr.trim().isEmpty()) {
            try {
                bookId = Integer.parseInt(bookIdStr);
                useBookId = true;
            } catch (NumberFormatException ignored) {
                // 忽略非法输入
            }
        }
        int category = 0;
        if (categoryStr != null && !categoryStr.isEmpty()) {
            try {
                category = Integer.parseInt(categoryStr);
            } catch (NumberFormatException ignored) {
                // 忽略非法输入
            }
        }

        // 查询书籍列表（keywords 参数暂不处理）
        List<Book> books = BookDao.searchNA(bookId, bookname, category, comment);

        // 存入 request 域对象
        request.setAttribute("books", books);

        // 请求转发到管理页面
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/manageBook.jsp");
        dispatcher.forward(request, response);
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
