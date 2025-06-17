package servlet.admin;

import com.database.UserDao;
import com.entities.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;

@WebServlet("/admin/adminEditUserInfo")
public class adminEditInfoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 设置编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();

        // 检查登录状态
        if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // 获取表单参数
            int userId = Integer.parseInt(request.getParameter("userId"));
            String username = request.getParameter("username");
            String genderStr = request.getParameter("gender");
            String comment = request.getParameter("comment");
            String userType = request.getParameter("type");

            // 构建 User 对象
            User user = new User();
            user.setId(userId);
            user.setName(username);

            // 设置性别枚举
            if ("MALE".equals(genderStr)) {
                user.setGender(User.Gender.MALE);
            } else if ("FEMALE".equals(genderStr)) {
                user.setGender(User.Gender.FEMALE);
            } else {
                user.setGender(User.Gender.OTHER);
            }

            // 设置用户类型枚举
            if ("ADMIN".equals(userType)) {
                user.setType(User.Type.ADMIN);
            } else if ("READER".equals(userType)) {
                user.setType(User.Type.READER);
            }

            user.setComment(comment);

            // 获取原用户信息用于保留不可修改字段
            User currentUser = new User();
            if (!UserDao.getUserInfoById(currentUser, userId)) {
                session.setAttribute("errorMsg", "用户不存在");
                response.sendRedirect(request.getContextPath() + "/admin/manageUser.jsp");
                return;
            }

            // 保留不可更改字段
            user.setBookAmount(currentUser.getBookAmount());
            user.setLoanPeriod(currentUser.getLoanPeriod());

            // 更新数据库
            boolean success = UserDao.updateUserInfo(user);

            if (success) {
                session.setAttribute("successMsg", "用户信息更新成功");
            } else {
                session.setAttribute("errorMsg", "用户信息更新失败");
            }

            // 跳转回管理页面
            response.sendRedirect(request.getContextPath() + "/admin/manageUser.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "处理请求时发生错误：" + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/manageUser.jsp");
        }
    }
}
