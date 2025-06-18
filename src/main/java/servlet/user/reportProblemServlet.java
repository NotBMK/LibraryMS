package servlet.user;

import com.database.BookDao;
import com.database.UserDao;
import com.entities.Book;
import com.entities.BookRecord;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ReportProblemServlet", value = "/user/reportProblem")

public class reportProblemServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");

        // 获取用户当前罚金
        double currentFine = UserDao.getUserFine(userId);
        request.setAttribute("currentFine", currentFine);

        // 转发到申报页面
        request.getRequestDispatcher("/user/reportProblem.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");
        String bookIdStr = request.getParameter("bookId");

        if (bookIdStr == null || bookIdStr.isEmpty()) {
            response.getWriter().print("{\"success\":false, \"message\":\"请选择图书\"}");
            return;
        }

        int bookId = Integer.parseInt(bookIdStr);
        BookRecord.ReportStatus status;
        double fineAmount = 0.0;

        if ("damage".equals(action)) {
            status = BookRecord.ReportStatus.DAMAGED;
            // 获取图书价格并计算罚金（半价）
            Book book = BookDao.getBookById(bookId);
            if (book != null) {
                fineAmount = book.price * 0.5;
            }
        } else if ("loss".equals(action)) {
            status = BookRecord.ReportStatus.LOST;
            // 获取图书价格（全价）
            Book book = BookDao.getBookById(bookId);
            if (book != null) {
                fineAmount = book.price;
            }
        } else {
            response.getWriter().print("{\"success\":false, \"message\":\"无效操作\"}");
            return;
        }

        // 处理申报
        boolean success = BookDao.reportProblem(userId, bookId, status);

        if (success) {
            // 增加用户罚金
            UserDao.addUserFine(userId, fineAmount);
            double newFine = UserDao.getUserFine(userId);
            response.getWriter().print("{\"success\":true, \"fineAdded\":" + fineAmount +
                    ", \"totalFine\":" + newFine + "}");
        } else {
            response.getWriter().print("{\"success\":false, \"message\":\"申报失败\"}");
        }
    }
}