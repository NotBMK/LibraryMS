package servlet.admin;

import com.entities.User;
import com.database.UserDao;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Enumeration;


@WebServlet("/admin/addUser")
public class addUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 设置编码格式
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 获取表单参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String genderStr = request.getParameter("gender");
        String typeStr = request.getParameter("type");
        String comment = request.getParameter("comment");

        HttpSession session = request.getSession();

        // 简单验证
        if (username == null || username.trim().isEmpty()) {
            session.setAttribute("errorMsg", "用户名不能为空！");
            response.sendRedirect(request.getContextPath() + "/admin/registerUser.jsp");
            return;
        }

        if (!password.equals(confirmPassword)) {
            session.setAttribute("errorMsg", "两次输入的密码不一致！");
            response.sendRedirect(request.getContextPath() + "/admin/registerUser.jsp");
            return;
        }

        // 枚举转换
        User.Gender gender = User.Gender.valueOf(genderStr);
        User.Type type = User.Type.valueOf(typeStr);

        if (UserDao.isExist(username)) {
            session.setAttribute("errorMsg", "用户名已存在！");
            response.sendRedirect(request.getContextPath() + "/admin/registerUser.jsp");
            return;
        }

        User user = new User();
        user.setName(username);
        user.setGender(gender);
        user.setType(type);
        user.setComment(comment);

        // 模拟插入数据库并获取新ID
        boolean success = UserDao.adminRegisterUser(user,password);

        int newUserId = success ? user.getId() : -1;

        // 传递新用户ID到JSP
        request.setAttribute("newUserId", newUserId);

        // 转发回注册页面
        request.getRequestDispatcher("/admin/registerUser.jsp").forward(request, response);
    }

}
