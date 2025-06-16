<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
  String action = request.getParameter("action");
  int kwId = Integer.parseInt(request.getParameter("kwId"));

  List<Integer> skws = (List<Integer>) session.getAttribute("skws");
  if (skws == null) {
    skws = new ArrayList<>();
    session.setAttribute("skws", skws);
  }

  if ("add".equals(action)) {
    skws.add(kwId);
  } else {
    skws.removeIf(integer -> integer.equals(kwId));
  }

  response.setContentType("text/plain");
%>

