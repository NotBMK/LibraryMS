<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ page import="com.entities.User" %>
<html>
<head>
    <title>图书管理信息系统 - 用户注册</title>
    <style>
        body {
            background-color: #E3E3E3;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 500px;
            margin: 50px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .user-area {
            position: relative;
        }

        .user-circle {
            width: 60px;
            height: 60px;
            background-color: #2196F3;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            font-size: 1.5em;
            cursor: pointer;
            z-index: 10;
        }

        .user-menu {
            display: none;
            position: absolute;
            right: 0;
            top: 70px;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
            padding: 10px 0;
            width: 150px;
            z-index: 20;
        }

        .user-menu a {
            display: block;
            padding: 8px 15px;
            text-decoration: none;
            color: #333;
        }

        .user-menu a:hover {
            background-color: #f0f0f0;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 8px;
        }

        .form-control {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 80px;
        }

        .radio-group label {
            margin-right: 15px;
        }

        .form-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        .back-btn {
            background-color: #f44336;
            color: white;
        }

        .back-btn:hover {
            background-color: #d32f2f;
        }

        .save-btn {
            background-color: #4CAF50;
            color: white;
        }

        .save-btn:hover {
            background-color: #388E3C;
        }

        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 10px;
        }
    </style>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const userArea = document.querySelector('.user-area');
            const userCircle = document.querySelector('.user-circle');
            const userMenu = document.querySelector('.user-menu');

            let menuTimeout;

            // 用户菜单交互
            userArea.addEventListener('mouseenter', function () {
                clearTimeout(menuTimeout);
                userMenu.style.display = 'block';
            });

            userArea.addEventListener('mouseleave', function () {
                menuTimeout = setTimeout(() => {
                    userMenu.style.display = 'none';
                }, 300);
            });

            userMenu.addEventListener('mouseenter', function () {
                clearTimeout(menuTimeout);
            });

            userMenu.addEventListener('mouseleave', function () {
                menuTimeout = setTimeout(() => {
                    userMenu.style.display = 'none';
                }, 100);
            });

            userCircle.addEventListener('click', function (e) {
                e.stopPropagation();
                if (userMenu.style.display === 'block') {
                    userMenu.style.display = 'none';
                } else {
                    userMenu.style.display = 'block';
                }
            });

            document.addEventListener('click', function () {
                userMenu.style.display = 'none';
            });

            userMenu.addEventListener('click', function (e) {
                e.stopPropagation();
            });
        });
    </script>
</head>
<body>

<% if (session.getAttribute("username") == null) { %>
<script>
    alert('您尚未登录，请先登录！');
    window.location.href='<%= request.getContextPath() %>/login.jsp';
</script>
<% return; } %>

<div class="container">
    <div class="header">
        <h2>用户注册</h2>
        <div class="user-area">
            <div class="user-circle">
                <%= session.getAttribute("username").toString().substring(0, 1) %>
            </div>
            <div class="user-menu">
                <a href="<%= request.getContextPath() %>/admin/adminInfo">个人信息</a>
                <a href="changePassword.jsp">修改密码</a>
                <a href="<%= request.getContextPath() %>/logout">退出登录</a>
            </div>
        </div>
    </div>

    <%
        String errorMsg = (String) request.getSession().getAttribute("errorMsg");
        Integer newUserId = (Integer) request.getAttribute("newUserId");

        if (errorMsg != null && !errorMsg.isEmpty()) {
    %>
    <div class="error-message"><%= errorMsg %></div>
    <% request.getSession().setAttribute("errorMsg", ""); %>
    <% } %>

    <% if (newUserId != null) { %>
    <script>
        alert("注册成功！用户ID为：" + <%= newUserId %>);
    </script>
    <% } %>


    <form action="${pageContext.request.contextPath}/admin/addUser" method="post">
        <div class="form-group">
            <label for="username">用户名</label>
            <input type="text" class="form-control" id="username" name="username" required>
        </div>

        <div class="form-group">
            <label for="password">密码</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>

        <div class="form-group">
            <label for="confirmPassword">确认密码</label>
            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
        </div>

        <div class="form-group">
            <label>性别</label>
            <div class="radio-group">
                <label><input type="radio" name="gender" value="MALE" checked> 男</label>
                <label><input type="radio" name="gender" value="FEMALE"> 女</label>
                <label><input type="radio" name="gender" value="OTHER"> 其他</label>
            </div>
        </div>

        <div class="form-group">
            <label for="type">用户类型</label>
            <select class="form-control" id="type" name="type">
                <%
                    for (User.Type type : User.Type.values()) {
                        if (type == User.Type.ROOT) continue; // 禁止注册 ROOT 用户
                %>
                <option value="<%= type.name() %>"><%= type == User.Type.ADMIN ? "管理员" : "普通用户" %></option>
                <%
                    }
                %>
            </select>
        </div>

        <div class="form-group">
            <label for="comment">备注信息</label>
            <textarea class="form-control" id="comment" name="comment"></textarea>
        </div>

        <div class="form-actions">
            <button type="button" class="btn back-btn" onclick="window.history.back()">返回</button>
            <button type="submit" class="btn save-btn">注册用户</button>
        </div>
    </form>
</div>
</body>
</html>