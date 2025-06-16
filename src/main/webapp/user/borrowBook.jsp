<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.entities.Book" %>
<%@ page import="java.util.List" %>
<%@ page import="com.database.BookDao" %>
<%@ page import="java.util.ArrayList" %>
<html>
<head>
    <title>图书管理信息系统 - 图书借阅</title>
    <link rel="stylesheet" href="../style/option_button.css">
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

        .search-area {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .search-form {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
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

        .borrow-btn {
            background-color: #4CAF50;
            color: white;
        }

        .borrow-btn:hover {
            background-color: #388E3C;
        }

        .delete-btn {
            background-color: #FFC107;
            color: #333;
        }

        .delete-btn:hover {
            background-color: #FFA000;
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
            const borrowBtn = document.getElementById('borrowBtn');
            const deleteBtn = document.getElementById('deleteBtn');

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

            <% if (request.getAttribute("books") != null) { %>
                document.getElementById('initMessage').style.display = 'none';
                <% if (!((List<Book>)request.getAttribute("books")).isEmpty()) { %>
                document.getElementById('bookList').style.display = 'block';
            <%
                } else {
            %>
                document.getElementById('noResult').style.display = 'block';
            <%
                }
            }
            %>

            // 搜索表单提交
            // searchForm.addEventListener('submit', function(e) {
            //     e.preventDefault();
            //     // 这里应该是AJAX请求后端获取图书数据
            //     // 为了演示，我们假设搜索成功并显示一些示例数据
            //     simulateSearch();
            // });

            // 借阅按钮点击事件
            borrowBtn.addEventListener('click', function() {
                const checkedBooks = document.querySelectorAll('input[name="book"]:checked');
                if (checkedBooks.length === 0) {
                    alert('请先选择要借阅的图书！');
                    return;
                }

                if (confirm(`确定要借阅选中的 ${checkedBooks.length} 本图书吗？`)) {
                    // 这里应该是AJAX请求后端处理借阅逻辑
                    alert('借阅成功！');
                    // 清空已选图书
                    checkedBooks.forEach(book => book.checked = false);
                }
            });

            // 删除按钮点击事件
            deleteBtn.addEventListener('click', function() {
                const checkedBooks = document.querySelectorAll('input[name="book"]:checked');
                if (checkedBooks.length === 0) {
                    alert('请先选择要删除的图书记录！');
                    return;
                }

                if (confirm(`确定要删除选中的 ${checkedBooks.length} 条图书记录吗？`)) {
                    // 移除选中的行
                    checkedBooks.forEach(book => {
                        const row = book.closest('tr');
                        row.remove();
                    });

                    // 检查是否还有图书记录
                    const remainingRows = document.querySelectorAll('#bookTable tbody tr');
                    if (remainingRows.length === 0) {
                        bookList.style.display = 'none';
                        emptyMessage.style.display = 'block';
                    }
                }
            });

            document.getElementById('searchForm').addEventListener('submit', function(e) {
                //e.preventDefault();
                document.getElementById('initMessage').style.display = 'none';
            });

            // 模拟搜索结果
            <%--function simulateSearch() {--%>
            <%--    // 隐藏空消息，显示图书列表--%>
            <%--    emptyMessage.style.display = 'none';--%>
            <%--    bookList.style.display = 'block';--%>

            <%--    // 获取搜索输入--%>
            <%--    const idInput = document.getElementById('bookId').value;--%>
            <%--    const nameInput = document.getElementById('bookName').value;--%>

            <%--    // 这里模拟根据搜索条件返回的图书数据--%>
            <%--    // 实际应用中应该从后端获取数据--%>
            <%--    const mockBooks = [--%>
            <%--        { id: '1001', name: 'Java编程思想', author: 'Bruce Eckel', publisher: '机械工业出版社', status: '可借阅' },--%>
            <%--        { id: '1002', name: 'Python数据分析', author: 'Wes McKinney', publisher: '机械工业出版社', status: '可借阅' },--%>
            <%--        { id: '1003', name: 'JavaScript高级程序设计', author: 'Matt Frisbie', publisher: '人民邮电出版社', status: '可借阅' }--%>
            <%--    ];--%>

            <%--    // 清空现有表格内容--%>
            <%--    const tableBody = document.querySelector('#bookTable tbody');--%>
            <%--    tableBody.innerHTML = '';--%>

            <%--    // 添加模拟数据到表格--%>
            <%--    mockBooks.forEach(book => {--%>
            <%--        const row = document.createElement('tr');--%>
            <%--        row.innerHTML = `--%>
            <%--            <td><input type="checkbox" name="book" value="${book.id}"></td>--%>
            <%--            <td>${book.id}</td>--%>
            <%--            <td>${book.name}</td>--%>
            <%--            <td>${book.author}</td>--%>
            <%--            <td>${book.publisher}</td>--%>
            <%--            <td>${book.status}</td>--%>
            <%--        `;--%>
            <%--        tableBody.appendChild(row);--%>
            <%--    });--%>
            <%--}--%>
        });
    </script>
</head>
<body>

<% if (session.getAttribute("username") == null) { %>
<script>
    alert('您尚未登录，请先登录！');
    window.location.href='<%= request.getContextPath() %>/login.jsp';
</script>
<%
    return; }
%>

<div class="container">
    <div class="header">
        <h2>图书借阅</h2>
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

    <div class="search-area">
        <form id="searchForm" class="search-form" action="<%= request.getContextPath() %>/user/borrowBook" method="get">
            <input type="text" name="bookId" id="bookId" placeholder="请输入图书ID">
            <input type="text" name="bookName" id="bookName" placeholder="请输入图书名称">
            <button name="submitButton" type="submit">搜索</button>
        </form>
        <%
            List<Integer> skws = (List<Integer>) session.getAttribute("skws");
            if (skws == null) {
                skws = new ArrayList<>();
                session.setAttribute("skws", skws);
            }
            List<Book.Keyword> kws = BookDao.getAllKeywords();
        %>
        <div class="button-container">
            <%
                for (Book.Keyword kw : kws) {
                    boolean isSelected = skws.contains(kw.id);
            %>
            <div role="button" class="option-btn <%= isSelected ? "selected" : "" %>"
                    data-kw-id="<%=kw.id %>">
                <%= kw.keyword %>
            </div>
            <%
                }
            %>
        </div>
        <script>
            function sendToJSP(kwId, action) {
                const data = {
                    kwId: kwId,
                    action: action
                }
                fetch('updateKeywordSelected.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: JSON.stringify(data)
                })
                    .then(response => response.text())
                    .then(data => {
                       console.log(data)
                    });
            }

            document.querySelectorAll(".option-btn").forEach(button => {
                button.addEventListener('click', function () {
                    /** @type {boolean} */
                    const isSelected = this.classList.toggle('selected');
                    const kwId = this.getAttribute('data-kw-id');
                    sendToJSP(kwId, isSelected);
                })
            });
        </script>
    </div>

    <div id="initMessage" class="empty-message">
        请输入图书ID或名称进行搜索
    </div>

    <%
        List<Book> books = (List<Book>) request.getAttribute("books");
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
                <th>状态</th>
                <th>备注</th>
            </tr>
            </thead>
            <tbody>
            <%
                for (Book book : books) {
            %>
            <tr>
                <td><input type="checkbox" name="book" value="<%= book.id %>"></td>
                <td><%= book.id %></td>
                <td><%= book.name %></td>
                <td><%= book.category %></td>
                <td><%= book.flag == Book.GOOD ? "可借阅" : "不可借阅" %></td>
                <td><%= book.comment %></td>
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
            未找到匹配的图书
        </div>
    <%
        }
    %>


    <div class="action-buttons">
            <button id="borrowBtn" class="borrow-btn">确认借阅</button>
            <button id="deleteBtn" class="delete-btn">删除记录</button>
    </div>

    <!-- 返回按钮 -->
    <div class="action-buttons" style="margin-top: 20px;">
        <button class="back-btn" onclick="window.location.href='home.jsp'">返回系统主页</button>
    </div>
</div>
</body>
</html>