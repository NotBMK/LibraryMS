<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.entities.Book" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>图书管理信息系统 - 图书借阅</title>
    <link rel="stylesheet" href="../style/search_bar.css">
    <link rel="stylesheet" href="../style/popup_window.css">
    <link rel="stylesheet" href="../style/custom_table.css">
    <link rel="stylesheet" href="../style/book_info_table.css">
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
            user-select: none;
            background-color: #4CAF50;
            color: white;
        }

        .borrow-btn:hover {
            background-color: #388E3C;
        }

        .borrow-btn:disabled {
            user-select: none;
            background-color: #777777;
            pointer-events: none;
            cursor: not-allowed;
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

            document.getElementById('searchForm').addEventListener('submit', function(e) {
                document.getElementById('initMessage').style.display = 'none';
            });

            document.querySelectorAll('.popup-link').forEach(link => {
                // 借书窗口设置
                const popup = document.getElementById("popup");
                const popupOverlay = document.getElementById("popup-overlay");
                const interestingBookId = document.getElementById("interestingBookId");
                const interestingBookName = document.getElementById("interestingBookName");
                const interestingBookCategory = document.getElementById("interestingBookCategory");
                const interestingBookFlag = document.getElementById("interestingBookFlag");
                const interestingBookPrice = document.getElementById("interestingBookPrice");
                const interestingBookComment = document.getElementById("interestingBookComment");
                const borrowBtn = document.getElementById("borrowBtn");
                const borrowForm = document.getElementById("borrowForm");

                const popupCloseBtn = document.querySelector(".popup-close-button");
                popupCloseBtn.addEventListener('click', function () {
                    popup.style.display = "none";
                    popupOverlay.style.display = "none";
                });

                link.addEventListener('click', function() {
                    popup.style.display = "block";
                    popupOverlay.style.display = "block";
                    const bookInfo = link.dataset.book.split(",");
                    interestingBookId.innerHTML = bookInfo[0];
                    interestingBookName.innerHTML = bookInfo[1];
                    interestingBookCategory.innerHTML = bookInfo[2];
                    const bookFlag = parseInt(bookInfo[3]);
                    const userId = parseInt(<%=session.getAttribute("userId")%>);
                    if (bookFlag === userId) {
                        borrowBtn.textContent = interestingBookFlag.innerHTML = "借阅中";
                        borrowBtn.disabled = true;
                    } else if (bookFlag === -1) {
                        interestingBookFlag.innerHTML = "可借阅";
                        borrowBtn.disabled = false;
                        borrowBtn.textContent = "确认借阅";
                    } else {
                        borrowBtn.textContent = interestingBookFlag.innerHTML = "不可借阅"
                        borrowBtn.disabled = true;
                    }
                    interestingBookPrice.innerHTML = bookInfo[4];
                    interestingBookComment.innerHTML = bookInfo[5];
                    document.getElementById("borrowBookId").value = bookInfo[0];
                });
            });
        })
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

    <div class="search-container">
        <form id="searchForm" class="search-form" action="<%= request.getContextPath() %>/user/borrowBook" method="POST" accept-charset="UTF-8">
                <input type="text" name="bookId" id="bookId" placeholder="图书ID">
                <input type="text" name="bookName" id="bookName" placeholder="图书名称">
                <button class="search-button" name="submitButton" type="submit">搜索</button>
        </form>
    </div>

    <div id="initMessage" class="empty-message">
        请输入图书ID或名称进行搜索
    </div>

    <%
        request.setAttribute("borrowBookId",-1);
        List<Book> books = (List<Book>) request.getAttribute("books");
        if (books != null && !books.isEmpty()) {
    %>
    <div id="bookList" class="custom-table-container">
        <table id="bookTable" class="custom-table">
            <thead>
            <tr>
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
                <tr class="popup-link" data-book="<%=book.toString()%>">
                    <td><%= String.format("%05d", book.id) %></td>
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

    <!-- 返回按钮 -->
    <div class="action-buttons" style="margin-top: 20px;">
        <button class="back-btn" onclick="window.location.href='home.jsp'">返回系统主页</button>
    </div>
    <div class="popup-overlay" id="popup-overlay"></div>
    <div class="popup" id="popup">
        <button class="popup-close-button">X</button>
        <h2>确定要借这本书吗？</h2>
        <table class="book-info-table">
            <tr>
                <th>书籍ID</th>
                <td id="interestingBookId"></td>
            </tr>
            <tr>
                <th>书籍标题</th>
                <td  id="interestingBookName"></td>
            </tr>
            <tr>
                <th>书籍类别</th>
                <td id="interestingBookCategory"></td>
            </tr>
            <tr>
                <th>书籍状态</th>
                <td id="interestingBookFlag"></td>
            </tr>
            <tr>
                <th>书籍价格</th>
                <td id="interestingBookPrice"></td>
            </tr>
            <tr>
                <th>书籍备注</th>
                <td id="interestingBookComment"></td>
            </tr>
        </table>
        <form id="borrowForm" action="<%=request.getContextPath()%>/user/borrowBook" method="get">
            <div class="action-buttons" style="justify-content: space-between">
                <input type="hidden" name="borrowBookId" id="borrowBookId">
                <input type="hidden" name="userId" id="userId" value="<%=session.getAttribute("userId")%>">
                <input type="hidden" name="userLoanPeriod" id="userLoanPeriod" value="<%=session.getAttribute("userLoanPeriod")%>">
                <button type="submit" style="width: 100%;" id="borrowBtn" class="borrow-btn">确认借阅</button>
            </div>
        </form>

    </div>
</div>
</body>
</html>