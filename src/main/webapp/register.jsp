<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>图书管理信息系统 - 用户注册</title>
    <!-- 添加CSS样式 -->
    <style>
        body {
            background-color: #E3E3E3;
            font-family: Arial, sans-serif;
        }
        .form-container {
            width: 300px;
            margin: 50px auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        td {
            padding: 8px;
        }
        .role-selector {
            margin: 10px 0;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 5px;
            box-sizing: border-box;
        }
        input[type="submit"], input[type="reset"] {
            margin: 5px;
            padding: 5px 15px;
        }
        .button-container {
            text-align: center;
            margin-top: 10px;
        }
        .register-link {
            text-align: center;
            margin-top: 15px;
        }
        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<div class="form-container">
    <%-- 显示错误消息 --%>
    <% if (request.getAttribute("error") != null) { %>
    <div class="error-message"><%= request.getAttribute("error") %></div>
    <% } %>

    <form action="registerServlet" method="post">
        <table>
            <caption>用户注册</caption>
            <tr>
                <td>用户名：</td>
                <td><input type="text" name="name" size="20" required/></td>
            </tr>
            <tr>
                <td>性别：</td>
                <td>
                    <input type="radio" name="gender" value="M" id="male" checked>
                    <label for="male">男</label>
                    <input type="radio" name="gender" value="F" id="female">
                    <label for="female">女</label>
                </td>
            </tr>
            <tr>
                <td>密码：</td>
                <td><input type="password" name="pass" size="20" required/></td>
            </tr>
            <tr>
                <td>确认密码：</td>
                <td><input type="password" name="confirmPass" size="20" required/></td>
            </tr>
            <tr>
                <td colspan="2" class="button-container">
                    <input type="submit" value="注册"/>
                    <input type="reset" value="重置"/>
                </td>
            </tr>
        </table>
    </form>
    <div class="register-link">
        已有账号？<a href="login.jsp">点击登录</a>
    </div>
</div>
</body>
</html>
