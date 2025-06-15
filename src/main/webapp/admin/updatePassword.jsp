<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<html>
<head>
  <title>图书管理信息系统 - 更新密码</title>
  <style>
    body {
      background-color: #E3E3E3;
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
    }

    .container {
      max-width: 400px;
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
      margin-right: 10px;
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

<% if (request.getSession().getAttribute("successMsg") != null) { %>
<div class="error-message">
  <%= request.getSession().getAttribute("successMsg") %>
</div>
<% request.getSession().removeAttribute("errorMsg"); } %>

<% if (request.getSession().getAttribute("errorMsg") != null) { %>
<div class="error-message">
  <%= request.getSession().getAttribute("errorMsg") %>
</div>
<% request.getSession().removeAttribute("errorMsg"); } %>

<div class="container">
  <div class="header">
    <h2>更新密码（更新后需重新登录）</h2>
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

  <form action="${pageContext.request.contextPath}/user/updatePassword" method="post">
    <div class="form-group">
      <label for="newPassword">新密码</label>
      <input type="password" class="form-control" id="newPassword" name="newPassword" required>
    </div>

    <div class="form-group">
      <label for="confirmPassword">确认新密码</label>
      <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
    </div>

    <div class="form-actions" style="margin-top: 30px;">
      <button type="button" class="btn back-btn" onclick="window.history.back()">返回</button>
      <button type="submit" class="btn save-btn">确认修改</button>
    </div>
  </form>
</div>
</body>
</html>
