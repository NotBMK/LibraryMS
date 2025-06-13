<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>图书管理信息系统 - 用户中心</title>
    <style>
        body {
            background-color: #E3E3E3;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
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

        .function-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .function-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            padding: 20px;
            text-align: center;
            transition: transform 0.3s;
        }

        .function-card:hover {
            transform: scale(1.03);
        }

        .function-icon {
            font-size: 3em;
            margin-bottom: 15px;
            color: #2196F3;
        }

        .function-title {
            font-size: 1.2em;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .function-desc {
            color: #666;
            margin-bottom: 15px;
        }

        .function-btn {
            display: inline-block;
            background-color: #2196F3;
            color: white;
            padding: 8px 20px;
            border-radius: 5px;
            text-decoration: none;
            transition: background-color 0.3s;
        }

        .function-btn:hover {
            background-color: #0b7dda;
        }

        .logout {
            text-align: center;
            margin-top: 30px;
        }

        .logout a {
            color: #f44336;
            text-decoration: none;
        }

        .logout a:hover {
            text-decoration: underline;
        }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const userArea = document.querySelector('.user-area');
            const userCircle = document.querySelector('.user-circle');
            const userMenu = document.querySelector('.user-menu');

            let menuTimeout;

            // 鼠标进入用户区域显示菜单
            userArea.addEventListener('mouseenter', function() {
                clearTimeout(menuTimeout);
                userMenu.style.display = 'block';
            });

            // 鼠标离开用户区域隐藏菜单
            userArea.addEventListener('mouseleave', function() {
                menuTimeout = setTimeout(() => {
                    userMenu.style.display = 'none';
                }, 300); // 添加一点延迟防止鼠标短暂离开时菜单消失
            });

            // 鼠标进入菜单时取消隐藏
            userMenu.addEventListener('mouseenter', function() {
                clearTimeout(menuTimeout);
            });

            // 鼠标离开菜单时隐藏
            userMenu.addEventListener('mouseleave', function() {
                menuTimeout = setTimeout(() => {
                    userMenu.style.display = 'none';
                }, 100);
            });

            // 点击头像切换菜单显示状态
            userCircle.addEventListener('click', function(e) {
                e.stopPropagation();
                if (userMenu.style.display === 'block') {
                    userMenu.style.display = 'none';
                } else {
                    userMenu.style.display = 'block';
                }
            });

            // 点击页面其他地方隐藏菜单
            document.addEventListener('click', function() {
                userMenu.style.display = 'none';
            });

            // 防止菜单内部点击传播到document
            userMenu.addEventListener('click', function(e) {
                e.stopPropagation();
            });
        });
    </script>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>欢迎使用图书管理系统</h2>
        <div class="user-area">
            <div class="user-circle">
                <%= session.getAttribute("username").toString().substring(0, 1) %>
            </div>
            <div class="user-menu">
                <a href="userInfo.jsp">个人信息</a>
                <a href="changePassword.jsp">修改密码</a>
                <a href="<%= request.getContextPath() %>/login.jsp">退出登录</a>
            </div>
        </div>
    </div>

    <div class="function-grid">
        <div class="function-card">
            <div class="function-icon">📚</div>
            <div class="function-title">图书借阅</div>
            <div class="function-desc">浏览和借阅图书馆中的可用书籍</div>
            <a href="borrowBook.jsp" class="function-btn">开始借阅</a>
        </div>

        <div class="function-card">
            <div class="function-icon">📦</div>
            <div class="function-title">图书归还</div>
            <div class="function-desc">归还已借阅的图书并查看借阅记录</div>
            <a href="returnBook.jsp" class="function-btn">归还图书</a>
        </div>

        <div class="function-card">
            <div class="function-icon">🔍</div>
            <div class="function-title">图书查找</div>
            <div class="function-desc">搜索图书馆中的所有书籍</div>
            <a href="searchBook.jsp" class="function-btn">查找图书</a>
        </div>

        <div class="function-card">
            <div class="function-icon">⚠️</div>
            <div class="function-title">意外申报</div>
            <div class="function-desc">报告图书丢失、损坏等意外情况</div>
            <a href="reportProblem.jsp" class="function-btn">申报意外</a>
        </div>
    </div>

<%--    <div class="logout">--%>
<%--        <a href="logoutServlet.jsp">退出系统</a>--%>
<%--    </div>--%>
</div>
</body>
</html>