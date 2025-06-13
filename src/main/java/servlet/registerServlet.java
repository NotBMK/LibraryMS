package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.database.UserDao;
import com.entities.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/registerServlet")
public class registerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;


    // 性别映射常量
    private static final int GENDER_MALE = 0;    // 男
    private static final int GENDER_FEMALE = 1;  // 女

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 设置请求和响应的字符编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 获取表单数据
        String name = request.getParameter("name");
        String genderStr = request.getParameter("gender");
        String password = request.getParameter("pass");
        String confirmPassword = request.getParameter("confirmPass");

        // 验证表单数据
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "用户名不能为空");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "密码不能为空");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "两次密码输入不一致");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 检查用户名是否已存在
        if (UserDao.isExist(name)) {
            request.setAttribute("error", "用户名已存在，请选择其他用户名");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 将性别字符串映射为整数
        int gender = "F".equals(genderStr) ? GENDER_FEMALE : GENDER_MALE;

        // 执行注册操作
        boolean registered = registerUser(name, password, gender);

        if (registered) {
            // 注册成功，重定向到登录页面
            response.sendRedirect("login.jsp?registerSuccess=true");
        } else {
            // 注册失败
            request.setAttribute("error", "注册失败，请稍后重试");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }


    // 执行用户注册
    private boolean registerUser(String username, String password, int gender) {
        Connection conn = null;
        PreparedStatement stmt = null;
        User user = new User();
        user.name = username;
        user.gender = User.Gender.fromInt(gender);
        user.type = User.Type.READER;
       return UserDao.register(user, password);
    }
}
