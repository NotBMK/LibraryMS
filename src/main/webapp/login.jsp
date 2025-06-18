<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>图书管理信息系统</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        /* 基础样式重置 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', system-ui, sans-serif;
        }

        /* 自定义变量 */
        :root {
            --primary: #818CF8;
            --secondary: #A5B4FC;
            --accent: #C7D2FE;
            --neutral: rgba(255, 255, 255, 0.7);
            --neutral-dark: rgba(229, 229, 229, 0.7);
            --text-dark: #333;
            --text-medium: #666;
            --text-light: #999;
            --border-light: #e0e0e0;
        }

        /* 全局样式 */
        body {
            min-height: 100vh;
            background: linear-gradient(to bottom right, #e0e7ff, #f3e8ff, #dbeafe);
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 1rem;
            color: var(--text-dark);
        }

        /* 背景装饰元素 */
        .bg-decoration {
            position: fixed;
            inset: 0;
            overflow: hidden;
            z-index: -1;
        }

        .bg-circle {
            position: absolute;
            border-radius: 50%;
            filter: blur(3rem);
        }

        .bg-circle-1 {
            top: -4rem;
            right: -4rem;
            width: 20rem;
            height: 20rem;
            background: rgba(129, 140, 248, 0.1);
        }

        .bg-circle-2 {
            top: 50%;
            left: -2rem;
            width: 15rem;
            height: 15rem;
            background: rgba(165, 180, 252, 0.1);
        }

        .bg-circle-3 {
            bottom: -2rem;
            right: 25%;
            width: 18rem;
            height: 18rem;
            background: rgba(199, 210, 254, 0.1);
        }

        /* 主容器 */
        .main-container {
            width: 100%;
            max-width: 28rem;
        }

        /* 表单卡片 */
        .form-card {
            background: white;
            border-radius: 1rem;
            box-shadow: 0 10px 25px -5px rgba(129, 140, 248, 0.1),
            0 8px 10px -6px rgba(129, 140, 248, 0.1);
            overflow: hidden;
            transition: transform 0.3s ease;
        }

        .form-card:hover {
            transform: scale(1.01);
        }

        /* 头部区域 */
        .form-header {
            background: linear-gradient(to right, rgba(129, 140, 248, 0.3), rgba(165, 180, 252, 0.3));
            padding: 1.5rem;
            text-align: center;
            border-bottom: 1px solid var(--border-light);
        }

        .form-header h1 {
            font-size: clamp(1.5rem, 3vw, 2rem);
            font-weight: bold;
            margin-bottom: 0.5rem;
        }

        .form-header p {
            color: var(--text-medium);
        }

        .header-icon {
            font-size: 2.5rem;
            margin-right: 0.75rem;
            color: var(--primary);
        }

        /* 表单区域 */
        .form-content {
            padding: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-input {
            position: relative;
        }

        .form-input input {
            width: 100%;
            padding: 0.75rem 0.75rem 0.75rem 2.5rem;
            border: 1px solid var(--border-light);
            border-radius: 0.5rem;
            background: rgba(255, 255, 255, 0.8);
            outline: none;
            transition: all 0.2s ease;
        }

        .form-input input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 0.125rem rgba(129, 140, 248, 0.3);
        }

        .form-input input::placeholder {
            color: var(--text-light);
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-light);
        }

        /* 角色选择 */
        .role-select {
            display: flex;
            gap: 1.5rem;
            margin: 1.25rem 0;
        }

        .role-option {
            display: flex;
            align-items: center;
        }

        .role-option input {
            margin-right: 0.5rem;
            accent-color: var(--primary);
        }

        /* 按钮区域 */
        .button-group {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            margin-top: 1rem;
        }

        @media (min-width: 640px) {
            .button-group {
                flex-direction: row;
            }
        }

        .btn {
            padding: 0.75rem;
            border: none;
            border-radius: 0.5rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn:hover {
            transform: translateY(-0.125rem);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }

        .btn-primary {
            background: linear-gradient(to right, var(--primary), var(--secondary));
            color: white;
        }

        .btn-secondary {
            background: #f3f4f6;
            color: var(--text-dark);
        }

        .btn-secondary:hover {
            background: #e5e7eb;
        }

        /* 注册链接 */
        .register-link {
            margin-top: 1.5rem;
            text-align: center;
            color: var(--text-medium);
        }

        .register-link a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
        }

        .register-link a:hover {
            color: var(--secondary);
        }

        /* 页脚 */
        .footer {
            margin-top: 1.5rem;
            text-align: center;
            color: var(--text-medium);
            font-size: 0.875rem;
        }

        /* 输入框动画 */
        .form-input:focus-within {
            transform: scale(1.01);
            transition: transform 0.2s ease;
        }
    </style>
</head>
<body>
<!-- 背景装饰元素 -->
<div class="bg-decoration">
    <div class="bg-circle bg-circle-1"></div>
    <div class="bg-circle bg-circle-2"></div>
    <div class="bg-circle bg-circle-3"></div>
</div>

<!-- 主容器 -->
<div class="main-container">
    <!-- 表单卡片 -->
    <div class="form-card">
        <!-- 头部区域 -->
        <div class="form-header">
            <div class="flex items-center justify-center mb-0.5">

                <h1>图书管理系统</h1>
            </div>
            <p>请登录您的账户</p>
        </div>

        <!-- 表单区域 -->
        <div class="form-content">
            <form action="loginServlet" method="post">
                <!-- 用户名输入 -->
                <div class="form-group form-input">
                    <span class="input-icon">👤</span>
                    <input type="text" name="username" placeholder="请输入登录名" required>
                </div>

                <!-- 密码输入 -->
                <div class="form-group form-input">
                    <span class="input-icon">🔒</span>
                    <input type="password" name="password" placeholder="请输入密码" required>
                </div>

                <!-- 角色选择 -->
                <div class="role-select">
                    <div class="role-option">
                        <input type="radio" name="role" value="user" id="user" checked>
                        <label for="user">用户</label>
                    </div>
                    <div class="role-option">
                        <input type="radio" name="role" value="admin" id="admin">
                        <label for="admin">管理员</label>
                    </div>
                </div>

                <!-- 按钮区域 -->
                <div class="button-group">
                    <button type="submit" class="btn btn-primary">
                        登录
                    </button>
                    <button type="reset" class="btn btn-secondary">
                        重置
                    </button>
                </div>
            </form>

            <!-- 注册链接 -->
            <div class="register-link">
                <p>
                    还没有账号？ <a href="register.jsp">
                    立即注册</a>
                </p>
            </div>
        </div>
    </div>


</div>

<script>
    // 表单输入框获取焦点时的效果
    document.querySelectorAll('input').forEach(input => {
        input.addEventListener('focus', () => {
            input.parentElement.classList.add('scale-101');
        });

        input.addEventListener('blur', () => {
            input.parentElement.classList.remove('scale-101');
        });
    });
</script>
</body>
</html>