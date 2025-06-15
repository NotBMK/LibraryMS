package servlet.admin;

import com.database.UserDao;
import com.entities.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/adminInfo")
public class adminInfoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 设置请求和响应的字符编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 获取会话对象
        HttpSession session = request.getSession();

        // 检查用户是否登录
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            // 用户未登录，重定向到登录页面
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 创建用户对象并获取用户信息
        User user = new User();
        boolean isUserFound = UserDao.getUserInfoById(user, userId);

        if (!isUserFound) {
            // 用户信息获取失败，重定向到登录页面
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 将用户对象存入 request 范围，供 JSP 页面使用
        request.setAttribute("user", user);

        // 转发到用户信息页面
        request.getRequestDispatcher("/admin/adminInfo.jsp").forward(request, response);
    }

}
