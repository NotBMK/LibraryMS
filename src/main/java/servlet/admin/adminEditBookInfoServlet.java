package servlet.admin;

import com.database.BookDao;
import com.entities.Book;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.Arrays;

@WebServlet("/admin/adminEditBookInfo")
public class adminEditBookInfoServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 设置编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();

        // 检查登录状态
        if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // 获取表单参数
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            String bookName = request.getParameter("bookName");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            double price = Double.parseDouble(request.getParameter("price"));
            String comment = request.getParameter("comment");
            String keyword = request.getParameter("keyword");


            // 构建 Book 对象
            Book book = new Book();
            book.id = bookId;
            book.name = bookName;
            book.category = Book.Category.getCategory(categoryId); // 转换为枚举类型
            book.price = price;
            book.comment = comment;
            if (keyword != null && !keyword.isEmpty()) {
                keyword = keyword.trim();
                if (!keyword.isEmpty()) {
                    book.keywords = Arrays.asList(keyword.split("\\s+"));
                }
            }

            // 更新数据库
            boolean success = BookDao.updateBookInfo(book);

            if (success) {
                session.setAttribute("successMsg", "书籍信息更新成功");
            } else {
                session.setAttribute("errorMsg", "书籍信息更新失败");
            }

            // 跳转回管理页面
            response.sendRedirect(request.getContextPath() + "/admin/manageBook.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "处理请求时发生错误：" + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/manageBook.jsp");
        }
    }
}
