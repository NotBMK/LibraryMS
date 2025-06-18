<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.entities.Book" %>
<%@ page import="java.util.List" %>
<%@ page import="com.entities.BookRecord" %>
<%@ page import="com.database.BookRecordDao" %>
<%@ page import="com.database.UserDao" %>
<html>
<head>
    <title>图书管理信息系统 - 意外申报</title>
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
            margin-bottom: 20px;
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

        /* 新增样式 */
        .problem-types {
            display: flex;
            gap: 15px;
            margin-top: 20px;
            margin-bottom: 20px;
        }

        .problem-types button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }

        .btn-damage {
            background-color: #FF9800;
            color: white;
        }

        .btn-damage:hover {
            background-color: #F57C00;
        }

        .btn-loss {
            background-color: #F44336;
            color: white;
        }

        .btn-loss:hover {
            background-color: #D32F2F;
        }

        .btn-pay {
            background-color: #4CAF50;
            color: white;
            padding: 8px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn-pay:hover {
            background-color: #388E3C;
        }

        .fine-section {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .fine-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .fine-amount {
            font-size: 1.2em;
            font-weight: bold;
            color: #E91E63;
        }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const userArea = document.querySelector('.user-area');
            const userCircle = document.querySelector('.user-circle');
            const userMenu = document.querySelector('.user-menu');

            let menuTimeout;

            // 用户菜单交互
            if (userArea) {
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
            }

            // 申报按钮事件
            const damageBtn = document.getElementById('damageBtn');
            if (damageBtn) {
                damageBtn.addEventListener('click', function() {
                    handleProblemReport('damage');
                });
            }

            const lossBtn = document.getElementById('lossBtn');
            if (lossBtn) {
                lossBtn.addEventListener('click', function() {
                    handleProblemReport('loss');
                });
            }

            // 支付按钮事件
            const payBtn = document.getElementById('payBtn');
            if (payBtn) {
                payBtn.addEventListener('click', function() {
                    if (confirm('确定要支付全部罚金吗？')) {
                        fetch('<%= request.getContextPath() %>/user/payFine', {
                            method: 'POST'
                        })
                            .then(response => response.json())
                            .then(data => {
                                if (data.success) {
                                    alert('支付成功！');
                                    document.getElementById('currentFine').textContent = '0.00';
                                } else {
                                    alert('支付失败，请重试！');
                                }
                            });
                    }
                });
            }

            function handleProblemReport(action) {
                const selectedBook = document.querySelector('input[name="book"]:checked');
                if (!selectedBook) {
                    alert('请先选择要申报的图书！');
                    return;
                }

                const bookId = selectedBook.value;
                const actionName = action === 'damage' ? '破损' : '丢失';

                if (confirm(`确定要申报【ID: ${bookId}】图书${actionName}吗？`)) {
                    fetch('<%= request.getContextPath() %>/user/reportProblem', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: `action=${action}&bookId=${bookId}`
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                alert(`申报成功！已添加罚金：¥${data.fineAdded.toFixed(2)}\n当前总罚金：¥${data.totalFine.toFixed(2)}`);
                                // 更新罚金显示
                                document.getElementById('currentFine').textContent = data.totalFine.toFixed(2);
                                // 移除已申报的图书行
                                selectedBook.closest('tr').remove();
                            } else {
                                alert('申报失败，请重试！');
                            }
                        });
                }
            }
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

<%
    // 获取当前用户罚金
    Double currentFineObj = (Double) request.getAttribute("currentFine");
    double currentFine = (currentFineObj != null) ? currentFineObj : 0.0;

    // 获取用户ID和借阅的图书
    Integer userIdObj = (Integer) session.getAttribute("userId");
    int userId = (userIdObj != null) ? userIdObj : -1;
    List<BookRecord> books = BookRecordDao.getBorrowedBooksByUserId(userId);
%>

<div class="container">
    <div class="header">
        <h2>意外申报</h2>
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

    <div class="fine-section">
        <div class="fine-info">
            <span>当前需缴费：</span>
            <span class="fine-amount">¥<span id="currentFine"><%= String.format("%.2f", currentFine) %></span></span>
        </div>
        <button id="payBtn" class="btn-pay">支付费用</button>
    </div>

    <%
        if (books != null && !books.isEmpty()) {
    %>
    <div class="book-list">
        <table class="book-table">
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
            </tr>
            </thead>
            <tbody>
            <% for (BookRecord bookRecord : books) { %>
            <tr>
                <td><input type="radio" name="book" value="<%= bookRecord.book.id %>"></td>
                <td><%= bookRecord.book.id %></td>
                <td><%= bookRecord.book.name %></td>
                <td><%= bookRecord.book.category %></td>
                <td><%= bookRecord.book.comment %></td>
                <td><%= bookRecord.book.price %></td>
                <td><%= bookRecord.startDate %></td>
                <td><%= bookRecord.endDate %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>

    <div class="problem-types">
        <button id="damageBtn" class="btn-damage">破损申报（半价罚金）</button>
        <button id="lossBtn" class="btn-loss">丢失申报（原价罚金）</button>
    </div>
    <%
        } else {
    %>
    <div class="empty-message">
        您当前没有借阅任何图书
    </div>
    <%
        }
    %>

    <div class="action-buttons">
        <button class="back-btn" onclick="window.location.href='home.jsp'">返回系统主页</button>
    </div>
</div>
</body>
</html>