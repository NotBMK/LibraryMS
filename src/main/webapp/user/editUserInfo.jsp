<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<html>
<head>
    <title>图书管理信息系统 - 编辑用户信息</title>
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
    </style>
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
        <h2>编辑用户信息</h2>
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

    <form action="${pageContext.request.contextPath}/user/editUserInfo" method="post">
        <input type="hidden" name="userId" value="${sessionScope.userId}">

        <div class="form-group">
            <label for="username">用户名</label>
            <input type="text" class="form-control" id="username" name="username" value="${sessionScope.username}">
        </div>

        <div class="form-group">
            <label>性别</label>
            <div>
                <%
                    int gender = (Integer)session.getAttribute("userGender");
                    String maleChecked = gender == 0 ? "checked" : "";
                    String femaleChecked = gender == 1 ? "checked" : "";
                    String otherChecked = gender == 2 ? "checked" : "";
                %>
                <label><input type="radio" name="gender" value="MALE" <%= maleChecked %>> 男</label>
                <label><input type="radio" name="gender" value="FEMALE" <%= femaleChecked %>> 女</label>
                <label><input type="radio" name="gender" value="OTHER" <%= otherChecked %>> 其他</label>
            </div>
        </div>

        <div class="form-group">
            <label for="comment">备注信息</label>
            <textarea class="form-control" id="comment" name="comment" rows="4">${sessionScope.userComment}</textarea>
        </div>

        <div class="form-actions">
            <button type="button" class="btn back-btn" onclick="window.history.back()">返回</button>
            <button type="submit" class="btn save-btn">保存更改</button>
        </div>
    </form>
</div>
</body>
</html>