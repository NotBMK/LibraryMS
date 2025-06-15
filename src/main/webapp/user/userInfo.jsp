<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>

<html>
<head>
    <title>图书管理信息系统 - 用户信息</title>
    <style>
        body {
            background-color: #E3E3E3;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 600px;
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

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }

        .info-label {
            font-weight: bold;
            color: #555;
            width: 120px;
        }

        .info-value {
            flex-grow: 1;
            color: #333;
        }

        .action-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            color: white;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        .back-btn {
            background-color: #f44336;
        }

        .back-btn:hover {
            background-color: #d32f2f;
        }

        .edit-btn {
            background-color: #2196F3;
        }

        .edit-btn:hover {
            background-color: #0b7dda;
        }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const userArea = document.querySelector('.user-area');
            const userCircle = document.querySelector('.user-circle');
            const userMenu = document.querySelector('.user-menu');
            let menuTimeout;

            // 用户菜单交互
            userArea.addEventListener('mouseenter', function() {
                clearTimeout(menuTimeout);
                userMenu.style.display = 'block';
            });

            userArea.addEventListener('mouseleave', function() {
                menuTimeout = setTimeout(() => {
                    userMenu.style.display = 'none';
                }, 300);
            });

            userMenu.addEventListener('mouseenter', function() {
                clearTimeout(menuTimeout);
            });

            userMenu.addEventListener('mouseleave', function() {
                menuTimeout = setTimeout(() => {
                    userMenu.style.display = 'none';
                }, 100);
            });

            userCircle.addEventListener('click', function(e) {
                e.stopPropagation();
                if (userMenu.style.display === 'block') {
                    userMenu.style.display = 'none';
                } else {
                    userMenu.style.display = 'block';
                }
            });

            document.addEventListener('click', function() {
                userMenu.style.display = 'none';
            });

            userMenu.addEventListener('click', function(e) {
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

<%-- 添加 alert 消息提示 --%>
<% if (request.getSession().getAttribute("successMsg") != null) { %>
<script>
    alert('<%= request.getSession().getAttribute("successMsg") %>');
    <% request.getSession().removeAttribute("successMsg"); %>
</script>
<% } %>

<% if (request.getSession().getAttribute("errorMsg") != null) { %>
<script>
    alert('<%= request.getSession().getAttribute("errorMsg") %>');
    <% request.getSession().removeAttribute("errorMsg"); %>
</script>
<% } %>

<div class="container">
    <div class="header">
        <h2>用户信息</h2>
        <div class="user-area">
            <div class="user-circle">
                <%= session.getAttribute("username").toString().substring(0, 1) %>
            </div>
            <div class="user-menu">
                <a href="<%= request.getContextPath() %>/user/userInfo">个人信息</a>
                <a href="changePassword.jsp">修改密码</a>
                <a href="<%= request.getContextPath() %>/logout">退出登录</a>
            </div>
        </div>
    </div>

    <div class="info-row">
        <div class="info-label">用户名：</div>
        <div class="info-value">${user.name}</div>
    </div>

    <div class="info-row">
        <div class="info-label">用户ID：</div>
        <div class="info-value">${user.id}</div>
    </div>

    <div class="info-row">
        <div class="info-label">性别：</div>
        <div class="info-value">${user.genderDisplay}</div>
    </div>

    <div class="info-row">
        <div class="info-label">用户类型：</div>
        <div class="info-value">${user.typeDisplay}</div>
    </div>

    <div class="info-row">
        <div class="info-label">借阅数量：</div>
        <div class="info-value">${user.bookAmount}</div>
    </div>

    <div class="info-row">
        <div class="info-label">借阅期限：</div>
        <div class="info-value">${user.loanPeriod} 天</div>
    </div>

    <div class="info-row">
        <div class="info-label">备注信息：</div>
        <div class="info-value">${user.comment}</div>
    </div>

    <div class="action-buttons">
        <button class="btn back-btn" onclick="window.location.href='home.jsp'">返回主页</button>
        <button class="btn edit-btn" onclick="window.location.href='editUserInfo.jsp'">编辑信息</button>
    </div>
</div>
</body>
</html>
