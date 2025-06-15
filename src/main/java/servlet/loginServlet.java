package servlet;

import com.database.UserDao;
import com.entities.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/loginServlet")
public class loginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 用户角色常量
    private static final String ROLE_ADMIN = "admin";
    private static final String ROLE_USER = "user";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 设置请求和响应的字符编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 获取表单数据
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // 验证输入是否为空
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "用户名和密码不能为空");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // 创建User对象
        User user = new User();
        user.name = username;

        // 调用UserDao的login方法验证用户
        boolean isValidUser = UserDao.login(user, password);

        if (isValidUser) {
            // 验证用户角色
            if (role.equals(ROLE_ADMIN) && user.type != User.Type.ADMIN) {
                request.setAttribute("error", "您没有管理员权限");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // 登录成功，创建会话
            HttpSession session = request.getSession();
            session.setAttribute("username", user.name);
            session.setAttribute("role", user.type == User.Type.ADMIN ? ROLE_ADMIN : ROLE_USER);
            session.setAttribute("userId", user.id);
            session.setAttribute("userType", user.type.getInt());
            session.setAttribute("userGender", user.gender.getInt());
            session.setAttribute("userBookAmount", user.bookAmount);
            session.setAttribute("userLoanPeriod", user.loanPeriod);
            session.setAttribute("userComment", user.comment);

            // 根据角色重定向到不同页面
            if (user.type == User.Type.ADMIN) {
                response.sendRedirect(request.getContextPath() + "/admin/home.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/home.jsp");
                //request.getRequestDispatcher("/user/home").forward(request, response);
            }
        } else {
            // 登录失败，返回错误信息
//            request.setAttribute("error", "用户名或密码不正确");
//            request.getRequestDispatcher("login.jsp").forward(request, response);
            // 登录失败，返回错误信息
            response.getWriter().write("<script>alert('用户名或密码不正确'); window.location.href='login.jsp';</script>");

        }
    }
}
