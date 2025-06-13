<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>图书管理信息系统</title>
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
    </style>
</head>
<body>
<div class="form-container">
    <form action="loginServlet" method="post">
        <table>
            <caption>用户登录</caption>
            <tr><td>登录名：</td>
                <td><input type="text" name="username" size="20"/></td>
            </tr>
            <tr><td>密码:</td>
                <td><input type="password" name="password" size="21"/></td>
            </tr>
            <tr>
                <td>登录身份:</td>
                <td class="role-selector">
                    <input type="radio" name="role" value="user" id="user" checked>
                    <label for="user">用户</label>
                    <input type="radio" name="role" value="admin" id="admin">
                    <label for="admin">管理员</label>
                </td>
            </tr>
            <tr>
                <td colspan="2" class="button-container">
                    <input type="submit" value="登录"/>
                    <input type="reset" value="重置"/>
                </td>
            </tr>
        </table>
    </form>
    <div class="register-link">
        如果没注册单击<a href="register.jsp">这里</a>注册！
    </div>
</div>
</body>
</html>
