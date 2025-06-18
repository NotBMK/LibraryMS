<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.entities.BookRecord" %>
<%@ page import="com.database.BookRecordDao" %>
<%@ page import="com.entities.Book" %>

<html>
<link rel="stylesheet" href="../style/user_avatar.css">
<link rel="stylesheet" href="../style/custom_table.css">
<link rel="stylesheet" href="../style/custom_button.css">
<link rel="stylesheet" href="../style/popup_window.css">
<link rel="stylesheet" href="../style/book_info_table.css">

<head>
<title>用户业务</title>
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
        <h2>用户业务</h2>
        <div class="user-area">
            <div class="user-circle" style="padding-right: 0">
                <%= session.getAttribute("username").toString().substring(0, 1) %>
            </div>
            <div class="user-menu">
                <a href="<%= request.getContextPath() %>/admin/adminInfo">个人信息</a>
                <a href="changePassword.jsp">修改密码</a>
                <a href="<%= request.getContextPath() %>/logout">退出登录</a>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // 借书窗口设置
            const popup = document.getElementById("popup");
            const popupOverlay = document.getElementById("popup-overlay");
            const interestingBookId = document.getElementById("interestingBookId");
            const interestingBookName = document.getElementById("interestingBookName");
            const interestingBookCategory = document.getElementById("interestingBookCategory");
            const interestingBookPrice = document.getElementById("interestingBookPrice");
            const interestingBookComment = document.getElementById("interestingBookComment");

            const popupCloseBtn = document.querySelector(".popup-close-button");
            popupCloseBtn.addEventListener('click', function () {
                popup.style.display = "none";
                popupOverlay.style.display = "none";
            });
            document.querySelectorAll(".popup-link").forEach(link=>{
                link.addEventListener('click', function() {
                    popup.style.display = "block";
                    popupOverlay.style.display = "block";
                    const bookInfo = link.dataset.book.split(",");
                    interestingBookId.innerHTML = bookInfo[0];
                    interestingBookName.innerHTML = bookInfo[1];
                    interestingBookCategory.innerHTML = bookInfo[2];
                    interestingBookPrice.innerHTML = bookInfo[4];
                    interestingBookComment.innerHTML = bookInfo[5];
                    document.getElementById("CLBookId").value = bookInfo[0];
                });
            });
        });
    </script>

    <div class="custom-table-container">
        <table class="custom-table">
            <thead>
                <tr>
                    <th>图书ID</th>
                    <th>图书标题</th>
                    <th>状态</th>
                    <th>借书日期</th>
                    <th>还书日期</th>
                    <th>操作</th>
                </tr>
            </thead>
            <%
                List<BookRecord> bookRecords = BookRecordDao.loadAllRecord();
            %>
            <tbody>
                <%
                    for (BookRecord bookRecord : bookRecords) {
                        Book book = bookRecord.book;
                %>
                    <tr>
                        <td><%= bookRecord.book.id %></td>
                        <td><%= bookRecord.book.name %></td>
                        <td><%= bookRecord.book.getFlagDisplay()%></td>
                        <td><%= bookRecord.startDate%></td>
                        <td><%= bookRecord.endDate%></td>
                        <td>
                            <%
                                if (book.flag > 0) {
                            %>
                                <button class="popup-link" data-book="<%=book.toString()%>">续借</button>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

    <div style="margin-top: 20px;">
        <button onclick="window.location.href='home.jsp'" class="btn back-btn">返回主页</button>
    </div>

    <div class="popup-window" id="popup-overlay"></div>
    <div class="popup" id="popup">
        <button class="popup-close-button">X</button>
        <h2>确认续借30天吗？</h2>
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
                <th>书籍价格</th>
                <td id="interestingBookPrice"></td>
            </tr>
            <tr>
                <th>书籍备注</th>
                <td id="interestingBookComment"></td>
            </tr>
        </table>
        <form id="CL-form" action="<%= request.getContextPath() %>/admin/userService" method="get">
            <input type="hidden" name="CLBookId" id="CLBookId" value="-1">
            <button type="submit" style="width: 100%;" id="CLBtn" class="custom-button">确认续借</button>
        </form>
    </div>
</div>

</body>
</html>
