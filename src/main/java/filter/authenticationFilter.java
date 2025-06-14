//package filter;
//
//import jakarta.servlet.*;
//import jakarta.servlet.annotation.WebFilter;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import java.io.IOException;
//
//@WebFilter(filterName = "AuthenticationFilter", urlPatterns = "/*")
//public class authenticationFilter implements Filter {
//
//    private static final String[] ALLOWED_PATHS = {
//            "/login.jsp", "/login", "/logout", "/resources/"
//    };
//
//    @Override
//    public void init(FilterConfig filterConfig) throws ServletException {
//        // 初始化逻辑（如果需要）
//    }
//
//    @Override
//    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//            throws IOException, ServletException {
//
//        HttpServletRequest httpRequest = (HttpServletRequest) request;
//        HttpServletResponse httpResponse = (HttpServletResponse) response;
//        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
//
//        // 检查是否为允许的路径
//        if (isAllowedPath(path)) {
//            chain.doFilter(request, response);
//            return;
//        }
//
//        HttpSession session = httpRequest.getSession(false);
//        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
//
//        if (!isLoggedIn) {
//            // 存储原始请求URL以便登录后重定向
//            String originalRequest = httpRequest.getRequestURI();
//            if (httpRequest.getQueryString() != null) {
//                originalRequest += "?" + httpRequest.getQueryString();
//            }
//            session = httpRequest.getSession();
//            session.setAttribute("originalRequest", originalRequest);
//
//            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
//            return;
//        }
//
//        chain.doFilter(request, response);
//    }
//
//    @Override
//    public void destroy() {
//        // 清理资源（如果需要）
//    }
//
//    private boolean isAllowedPath(String path) {
//        for (String allowedPath : ALLOWED_PATHS) {
//            if (path.startsWith(allowedPath)) {
//                return true;
//            }
//        }
//        return false;
//    }
//}