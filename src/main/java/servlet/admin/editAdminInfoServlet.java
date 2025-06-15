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

@WebServlet("/admin/editAdminInfo")
public class editAdminInfoServlet extends HttpServlet {
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
            String username = request.getParameter("username");
            String gender = request.getParameter("gender");
            String comment = request.getParameter("comment");
            int userId = Integer.parseInt(request.getParameter("userId"));

            // 验证用户ID是否匹配当前会话中的用户ID
            int sessionUserId = (Integer) session.getAttribute("userId");
            if (userId != sessionUserId) {
                session.setAttribute("errorMsg", "非法操作：用户ID不匹配");
                response.sendRedirect(request.getContextPath() + "/user/userInfo");
                return;
            }

            // 创建User对象并设置更新信息
            User user = new User();
            user.setId(userId);
            user.setName(username);

            // 设置性别 (根据JSP中的值MALE/FEMALE/OTHER)
            if ("MALE".equals(gender)) {
                user.setGender(User.Gender.MALE);
            } else if ("FEMALE".equals(gender)) {
                user.setGender(User.Gender.FEMALE);
            } else {
                user.setGender(User.Gender.OTHER);
            }

            user.setComment(comment);

            // 从数据库获取完整用户信息(保留原有type等信息)
            User currentUser = new User();
            if (!UserDao.getUserInfoById(currentUser, userId)) {
                session.setAttribute("errorMsg", "用户不存在");
                response.sendRedirect(request.getContextPath() + "/user/userInfo");
                return;
            }

            // 保留原有不可修改的字段
            user.setType(currentUser.getType());
            user.setBookAmount(currentUser.getBookAmount());
            user.setLoanPeriod(currentUser.getLoanPeriod());

            // 更新数据库
            boolean success = UserDao.updateUserInfo(user);

            if (success) {
                // 更新session中的用户信息
                session.setAttribute("username", user.getName());
                session.setAttribute("userGender", user.getGender().getInt());
                session.setAttribute("userComment", user.getComment());

                session.setAttribute("successMsg", "管理员信息更新成功");
            } else {
                session.setAttribute("errorMsg", "管理员信息更新失败");
            }

            // 重定向回用户信息页面
            response.sendRedirect(request.getContextPath() + "/admin/adminInfo");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "处理请求时发生错误: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/adminInfo");
        }
    }

}