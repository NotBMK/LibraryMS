<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ page import="com.entities.Book" %>
<%@ page import="com.database.BookDao" %>

<html>
<head>
  <title>图书管理信息系统 - 管理员修改书籍信息</title>
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
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
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

<%
  // 获取传入的 bookId 参数
  String bookIdStr = request.getParameter("bookId");
  int targetBookId = -1;

  try {
    if (bookIdStr != null && !bookIdStr.isEmpty()) {
      targetBookId = Integer.parseInt(bookIdStr);
    }
  } catch (NumberFormatException ignored) {}

  String role = (String) session.getAttribute("role");

  if (!"admin".equals(role)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

  Book targetBook = BookDao.getBookById(targetBookId);
  if (targetBook == null) {
    session.setAttribute("errorMsg", "书籍不存在");
    response.sendRedirect("manageBook.jsp");
    return;
  }

  request.setAttribute("targetBook", targetBook);
%>

<div class="container">
  <div class="header">
    <h2>编辑书籍信息</h2>
    <div class="user-area">
      <div class="user-circle">
        <%= session.getAttribute("username").toString().substring(0, 1) %>
      </div>
      <div class="user-menu">
        <a href="<%= request.getContextPath() %>/admin/adminInfo">个人信息</a>
        <a href="changePassword.jsp">修改密码</a>
        <a href="<%= request.getContextPath() %>/logout">退出登录</a>
      </div>
    </div>
  </div>

  <form action="${pageContext.request.contextPath}/admin/adminEditBookInfo" method="post">
    <input type="hidden" name="bookId" value="<%= targetBook.id %>">

    <div class="form-group">
      <label for="bookName">书名</label>
      <input type="text" class="form-control" id="bookName" name="bookName" value="<%= targetBook.name %>" required>
    </div>

    <div class="form-group">
      <label for="categoryId">分类</label>
      <select class="form-control" id="categoryId" name="categoryId" required>
        <option value="0" <%= targetBook.category == Book.Category.UNKNOWN ? "selected" : "" %>>未知</option>
        <option value="1" <%= targetBook.category == Book.Category.NOVEL ? "selected" : "" %>>小说</option>
        <option value="2" <%= targetBook.category == Book.Category.POETRY ? "selected" : "" %>>诗歌</option>
        <option value="3" <%= targetBook.category == Book.Category.BIOGRAPHY ? "selected" : "" %>>传记</option>
        <option value="4" <%= targetBook.category == Book.Category.TEXT ? "selected" : "" %>>教科书</option>
        <option value="5" <%= targetBook.category == Book.Category.REFERENCE ? "selected" : "" %>>参考书</option>
      </select>
    </div>

<%--    <div class="form-group">--%>
<%--      <label for="flag">书籍状态</label>--%>
<%--      <select class="form-control" id="flag" name="flag" required>--%>
<%--        <option value="-1" <%= targetBook.flag == Book.GOOD ? "selected" : "" %>>可借阅</option>--%>
<%--        <option value="-2" <%= targetBook.flag == Book.BROKEN ? "selected" : "" %>>损坏</option>--%>
<%--        <option value="-3" <%= targetBook.flag == Book.LOST ? "selected" : "" %>>丢失</option>--%>
<%--        <!-- 如果有用户借阅中的状态也可以动态处理 -->--%>
<%--        <% if (targetBook.flag > 0) { %>--%>
<%--        <option value="<%= targetBook.flag %>" selected>借阅中（用户ID：<%= targetBook.flag %>）</option>--%>
<%--        <% } %>--%>
<%--      </select>--%>
<%--    </div>--%>

    <div class="form-group">
      <label for="keyword">关键词</label>
      <textarea class="form-control" id="keyword" name="keyword" ><%= targetBook.keywords.isEmpty() ? "" : String.join(" ", targetBook.keywords)   %></textarea>
    </div>

    <div class="form-group">
      <label for="price">价格</label>
      <input type="number" step="0.01" class="form-control" id="price" name="price" value="<%= targetBook.price %>" required>
    </div>

    <div class="form-group">
      <label for="comment">备注信息</label>
      <textarea class="form-control" id="comment" name="comment" rows="4"><%= targetBook.comment != null ? targetBook.comment : "" %></textarea>
    </div>

    <div class="form-actions">
      <button type="button" class="btn back-btn" onclick="window.history.back()">返回</button>
      <button type="submit" class="btn save-btn">保存更改</button>
    </div>
  </form>
</div>

</body>
</html>
