package servlet.admin;

import com.entities.Book;
import com.database.BookDao;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.util.Arrays;

@WebServlet("/admin/addBook")
public class addBookServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 设置编码格式
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();

        try {
            // 获取表单参数
            String bookName = request.getParameter("bookName");
            String categoryIdStr = request.getParameter("categoryId");
            String priceStr = request.getParameter("price");
            String keyword  = request.getParameter("keyword");
            String comment = request.getParameter("comment");

            // 简单验证
            if (bookName == null || bookName.trim().isEmpty()) {
                session.setAttribute("errorMsg", "书名不能为空！");
                response.sendRedirect(request.getContextPath() + "/admin/addBook.jsp");
                return;
            }

            int categoryId;
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
                session.setAttribute("errorMsg", "请选择有效的分类！");
                response.sendRedirect(request.getContextPath() + "/admin/addBook.jsp");
                return;
            }

            double price;
            try {
                price = Double.parseDouble(priceStr);
                if (price < 0) throw new NumberFormatException();
            } catch (NumberFormatException e) {
                session.setAttribute("errorMsg", "请输入有效的价格（大于等于0）！");
                response.sendRedirect(request.getContextPath() + "/admin/addBook.jsp");
                return;
            }

            // 创建书籍对象并填充数据
            Book book = new Book();
            book.name = bookName;
            book.category = Book.Category.values()[categoryId]; // 注意：确保枚举顺序对应
            book.price = price;
            book.comment = comment;
            book.flag = Book.GOOD; // 默认状态为“可借阅”


            // 插入数据库
            boolean success = BookDao.addBook(book);

            if (!success) {
                session.setAttribute("errorMsg", "书籍录入失败，请重试！");
                response.sendRedirect(request.getContextPath() + "/admin/addBook.jsp");
                return;
            }

            // 插入成功，获取新书籍ID
            int newBookId = book.id;

            if (keyword != null && !keyword.isEmpty()) {
                keyword = keyword.trim();
                if (!keyword.isEmpty()) {
                    String[] kws = keyword.split("\\s+");
                    BookDao.addBookKeywords(book.id, Arrays.asList(kws));
                }
            }

            // 跳转到管理页面并提示成功
            session.setAttribute("errorMsg", "书籍添加成功！书籍ID：" + newBookId);
            response.sendRedirect(request.getContextPath() + "/admin/manageBook.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "发生未知错误，请重试！");
            response.sendRedirect(request.getContextPath() + "/admin/addBook.jsp");
        }
    }
}
