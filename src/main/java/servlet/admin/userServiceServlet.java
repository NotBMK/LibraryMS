package servlet.admin;

import com.database.BookRecordDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/userService")
public class userServiceServlet extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");


        int bookId = Integer.parseInt(request.getParameter("CLBookId"));
        if (!BookRecordDao.continueLoan(bookId)) {
            request.getSession().setAttribute("error", "续借失败，请联系管理员处理");
        }

        request.getRequestDispatcher("/admin/userService.jsp").forward(request, response);
    }
}
