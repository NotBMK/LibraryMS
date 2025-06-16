package servlet.user;

import com.entities.Book;
import com.database.BookDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
        //System.out.println("Received - bookId: " + id + ", bookName: " + name);

//        String condition = "1=1";
//        if (name != null && !name.trim().isEmpty()) {
//            condition += " and name like '%" + name + "%'";
//        }
//        if (id != null && !id.trim().isEmpty()) {
//            condition += " and id = " + id ;
//        }
//
//        //
//        List<Book> books = BookDao.search(condition);
////        System.out.println("Search condition: " + condition);
////        System.out.println("Found " + books.size() + " books.");
//
//        if (books.isEmpty()) {
//            request.setAttribute("error", "未找到相关图书");
//            request.getRequestDispatcher("/user/borrowBook.jsp").forward(request, response);
//        } else {
//            request.setAttribute("books", books);
//            request.getRequestDispatcher("/user/borrowBook.jsp").forward(request, response);
//        }
    }

}
