<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.entities.Book" %>
<%@ page import="java.util.List" %>
<%@ page import="com.entities.BookRecord" %>
<%@ page import="com.database.BookRecordDao" %>
<html>
<head>
    <title>图书管理信息系统 - 图书归还</title>
    <style>
        body {
            background-color: #E3E3E3;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 1000px;
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

        .search-form input {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
            flex: 1;
        }

        .search-form button {
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 8px 20px;
            cursor: pointer;
        }

        .search-form button:hover {
            background-color: #0b7dda;
        }

        .book-list {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            padding: 20px;
        }

        .book-table {
            width: 100%;
            border-collapse: collapse;
        }

        .book-table th, .book-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        .book-table th {
            background-color: #f5f5f5;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .action-buttons button {
            padding: 8px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .back-btn {
            background-color: #f44336;
            color: white;
        }

        .back-btn:hover {
            background-color: #d32f2f;
        }

        .return-btn {
            background-color: #4CAF50;
            color: white;
        }

        .return-btn:hover {
            background-color: #388E3C;
        }

        .empty-message {
            text-align: center;
            padding: 20px;
            color: #666;
        }

        #bookList, #noResult {
            display: none;
        }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const userArea = document.querySelector('.user-area');
            const userCircle = document.querySelector('.user-circle');
            const userMenu = document.querySelector('.user-menu');
            const searchForm = document.getElementById('searchForm');
            const bookList = document.getElementById('bookList');
            const emptyMessage = document.getElementById('emptyMessage');
            const returnBtn = document.getElementById('returnBtn');

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

            <% if (request.getAttribute("borrowedBooks") != null) { %>
                document.getElementById('initMessage').style.display = 'none';
            <% if (!((List<Book>)request.getAttribute("borrowedBooks")).isEmpty()) { %>
                document.getElementById('bookList').style.display = 'block';
            <% } else { %>
                document.getElementById('noResult').style.display = 'block';
            <% } %>
            <% } %>

            // 按钮点击事件
            returnBtn.addEventListener('click', function() {
                const checkedBooks = document.querySelectorAll('input[name="book"]:checked');
                if (checkedBooks.length === 0) {
                    alert('请先选择要归还的图书！');
                    return;
                }

                if (confirm(`确定要归还选中的 ${checkedBooks.length} 本图书吗？`)) {
                    // 获取所有选中的图书ID
                    const bookIds = Array.from(checkedBooks).map(book => book.value);

                    // 发送AJAX请求
                    fetch('<%= request.getContextPath() %>/user/returnBook', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'bookId=' + bookIds.join(',')
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                alert('还书成功！');
                                location.reload(); // 刷新页面更新列表
                            } else {
                                alert('还书失败，请重试！');
                            }
                        });
                }
            });

            document.getElementById('searchForm').addEventListener('submit', function(e) {
                //e.preventDefault();
                document.getElementById('initMessage').style.display = 'none';
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
        <h2>图书归还</h2>
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

    <div id="initMessage" class="empty-message">
        请选择您要归还的图书
    </div>

    <%
        List<BookRecord> books = (List<BookRecord>) request.getAttribute("borrowedBooks");
        if (books != null && !books.isEmpty()) {
    %>
    <div id="bookList" class="book-list">
        <table id="bookTable" class="book-table">
            <thead>
            <tr>
                <th>选择</th>
                <th>图书ID</th>
                <th>图书名称</th>
                <th>分类</th>
                <th>备注</th>
                <th>价格</th>
                <th>借书时间</th>
                <th>还书期限</th>
                <th>逾期天数</th>
                <th>需缴费</th>
            </tr>
            </thead>
            <tbody>
            <%
                for (BookRecord bookRecord : books) {
            %>
            <tr>
                <td><input type="checkbox" name="book" value="<%= bookRecord.book.id %>"></td>
                <td><%= bookRecord.book.id %></td>
                <td><%= bookRecord.book.name %></td>
                <td><%= bookRecord.book.category %></td>
                <td><%= bookRecord.book.comment %></td>
                <td><%= bookRecord.book.price %></td>
                <td><%= bookRecord.startDate %></td>
                <td><%= bookRecord.endDate %></td>
                <td>
                    <% if (bookRecord.getOverdueDays() > 0) { %>
                    <span style="color:red"><%= bookRecord.getOverdueDays() %> 天</span>
                    <% } else { %>
                    0
                    <% } %>
                </td>
                <td>
                    <%= String.format("%.2f", bookRecord.calculateFine()) %>
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
    <%
    } else {
    %>
    <div id="noResult" class="empty-message">
        您当前没有借阅任何图书
    </div>
    <%
        }
    %>

    <div class="action-buttons">
        <button id="returnBtn" class="return-btn">确认还书</button>
    </div>

    <!-- 返回按钮 -->
    <div class="action-buttons" style="margin-top: 20px;">
        <button class="back-btn" onclick="window.location.href='home.jsp'">返回系统主页</button>
    </div>
</div>
</body>
</html>