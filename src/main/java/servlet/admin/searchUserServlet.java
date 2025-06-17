package servlet.admin;

import com.database.UserDao;
import com.entities.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/searchUsers")
public class searchUserServlet extends HttpServlet {
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

        try {
            // 获取搜索参数
            String userIdStr = request.getParameter("userId");
            String username = request.getParameter("username");
            String genderStr = request.getParameter("gender");
            String comment = request.getParameter("comment");

            int userId = 0;
            boolean useUserId = false;
            if (userIdStr != null && !userIdStr.trim().isEmpty()) {
                try {
                    userId = Integer.parseInt(userIdStr);
                    useUserId = true;
                } catch (NumberFormatException ignored) {
                    // 忽略非法输入
                }
            }

            // 枚举转换：Gender
            User.Gender gender = null;
            if ("MALE".equalsIgnoreCase(genderStr)) {
                gender = User.Gender.MALE;
            } else if ("FEMALE".equalsIgnoreCase(genderStr)) {
                gender = User.Gender.FEMALE;
            } else if ("OTHER".equalsIgnoreCase(genderStr)) {
                gender = User.Gender.OTHER;
            }

            // 调用 UserDao 进行多条件搜索
            List<User> users = UserDao.searchUsers(userId, username, gender, comment);

            // 将搜索结果存入 request 域中
            request.setAttribute("users", users);

            // 转发到管理用户页面显示结果
            request.getRequestDispatcher("/admin/manageUser.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "搜索用户时发生错误：" + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/manageUser.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
