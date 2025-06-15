package servlet.user;

import com.database.AppDatabase;
import com.entities.User;
import com.database.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/user/updatePassword")
public class updatePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // 检查用户是否已登录
        if (session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // 获取表单数据
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // 验证两次输入的密码是否一致
            if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
                // 密码不一致，设置错误消息并返回修改页面
                session.setAttribute("errorMsg", "请输入一致且非空的密码");
                response.sendRedirect("updatePassword.jsp");
                return;
            }

            // 从session中获取当前用户ID
            int userId = (Integer) session.getAttribute("userId");

            // 创建用户对象并获取用户信息
            User user = new User();
            boolean isUserFound = UserDao.getUserInfoById(user, userId);

            if (!isUserFound) {
                // 用户信息获取失败，重定向到登录页面
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // 调用UserDao的方法来更新密码
            boolean success = UserDao.updatePassword(user, newPassword);

            if (success) {
                session.setAttribute("successMsg", "密码更新成功，请使用新密码重新登录");
                response.sendRedirect(request.getContextPath() + "/logout");
            } else {
                // 更新失败，显示错误消息
                session.setAttribute("errorMsg", "密码更新失败，请稍后重试");
                response.sendRedirect("updatePassword.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "处理请求时发生错误: " + e.getMessage());
            response.sendRedirect("updatePassword.jsp");
        }
    }

}
