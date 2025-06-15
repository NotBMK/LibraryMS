package servlet.user;

import com.database.UserDao;
import com.entities.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/user/verifyPassword")
public class verifyPasswordServlet extends HttpServlet {
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
            String currentPassword = request.getParameter("currentPassword");
            
            // 从session中获取当前用户ID
            int userId = (Integer) session.getAttribute("userId");
            
            // 创建User对象并获取用户信息
            User user = new User();
            if (!UserDao.getUserInfoById(user, userId)) {
                session.setAttribute("errorMsg", "用户不存在");
                response.sendRedirect(request.getContextPath() + "/user/userInfo");
                return;
            }
            
            // 验证密码
            if (UserDao.checkPassword(user, currentPassword)) {
                // 密码正确，跳转到修改密码页面
                response.sendRedirect("updatePassword.jsp");
            } else {
                // 密码错误，返回错误信息
                session.setAttribute("errorMsg", "当前密码不正确");
                response.sendRedirect("changePassword.jsp");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "处理请求时发生错误: " + e.getMessage());
            response.sendRedirect("verifyPassword.jsp");
        }
    }
}
