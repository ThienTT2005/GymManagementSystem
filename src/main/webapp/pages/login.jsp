<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <title>Login | CodeGym</title>
        <!-- Fonts and Icons -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Roboto:wght@300;400;500;700&display=swap"
            rel="stylesheet">
        <link
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
            rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/page-transitions.css?v=1">

        <style>
            .material-symbols-outlined {
                font-variation-settings: "FILL" 0, "wght" 400, "GRAD" 0, "opsz" 24;
            }
        </style>
    </head>

    <body class="login-page">
        <!-- Main Content -->
        <div class="container">
            <!-- Header -->
            <jsp:include page="../components/header.jsp" />

            <main class="login-main">
                <!-- Hero Section -->
                <section class="login-hero"
                    data-alt="dramatic wide angle shot of a modern dark gym interior with premium equipment and moody red atmospheric lighting">
                    <div class="hero-content">
                        <h1> <span> KIÊN TRÌ </span></h1>
                        <p>Tham gia cộng đồng nơi hiệu suất đỉnh cao gặp gỡ công nghệ tiên tiến. Tiềm năng đỉnh cao của
                            bạn chỉ cách một buổi tập.</p>
                        <div class="stats-container">
                            <div class="stat-item">
                                <span class="stat-value">24/7</span>
                                <span class="stat-label">Access</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-value">50+</span>
                                <span class="stat-label">Classes</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-value">Elite</span>
                                <span class="stat-label">Coaches</span>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Login Form Section -->
                <section class="login-form-section">
                    <div class="form-wrapper">
                        <div class="form-header">
                            <h2>Welcome Back</h2>
                            <p>Đăng nhập vào tài khoản CodeGym của bạn để theo dõi tiến trình.</p>
                        </div>

                        <!-- Login Type Tabs -->
                        <div class="role-tabs">
                            <button class="role-btn active" onclick="setRole('customer', this)">Customer</button>
                            <button class="role-btn" onclick="setRole('staff', this)">Staff</button>
                        </div>

                        <form action="${pageContext.request.contextPath}/login" method="POST">
                            <input type="hidden" id="role" name="role" value="customer">

                            <div class="input-group">
                                <label for="user">Tên đăng nhập (Username)</label>
                                <div class="input-container">
                                    <span class="material-symbols-outlined icon">person</span>
                                    <input id="user" name="user" placeholder="Nhập tên đăng nhập" required
                                        type="text" />
                                </div>
                            </div>

                            <div class="input-group">
                                <label for="password">Mật khẩu</label>
                                <div class="input-container">
                                    <span class="material-symbols-outlined icon">lock</span>
                                    <input id="password" name="password" placeholder="••••••••" required
                                        type="password" />
                                    <button class="toggle-password" type="button" onclick="togglePassword()">
                                        <span class="material-symbols-outlined toggle-icon">visibility</span>
                                    </button>
                                </div>
                            </div>

                            <div class="form-options">
                                <label class="remember-me">
                                    <input type="checkbox" />
                                    <span>Remember me</span>
                                </label>
                                <a class="forgot-password" href="#">Quên mật khẩu?</a>
                            </div>

                            <button class="btn-primary" type="submit">
                                Sign In
                                <span class="material-symbols-outlined">arrow_forward</span>
                            </button>
                        </form>

                        <div class="divider">
                            <span>or continue with</span>
                        </div>

                        <div class="social-login">
                            <button>
                                <svg class="w-5 h-5" viewBox="0 0 24 24" style="width: 20px; height: 20px;">
                                    <path
                                        d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
                                        fill="#4285F4"></path>
                                    <path
                                        d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
                                        fill="#34A853"></path>
                                    <path
                                        d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
                                        fill="#FBBC05"></path>
                                    <path
                                        d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
                                        fill="#EA4335"></path>
                                </svg>
                                Google
                            </button>
                            <button>
                                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"
                                    style="width: 20px; height: 20px;">
                                    <path
                                        d="M22 12c0-5.52-4.48-10-10-10S2 6.48 2 12c0 4.84 3.44 8.87 8.13 9.77v-6.9H7.63v-2.87h2.5V9.75c0-2.47 1.47-3.83 3.72-3.83 1.08 0 2.2.19 2.2.19v2.42h-1.24c-1.23 0-1.61.76-1.61 1.54v1.85h2.72l-.44 2.87h-2.28v6.9C18.56 20.87 22 16.84 22 12z">
                                    </path>
                                </svg>
                                Facebook
                            </button>
                        </div>

                        <p class="signup-prompt">
                            New to CodeGym?
                            <a href="register.jsp">Create an account</a>
                        </p>
                    </div>
                </section>
            </main>

            <!-- Footer -->
            <jsp:include page="../components/footer.jsp" />
        </div>

        <script>
            function setRole(role, element) {
                document.getElementById('role').value = role;

                // Remove active class from all buttons
                const btns = document.querySelectorAll('.role-btn');
                btns.forEach(btn => btn.classList.remove('active'));

                // Add active class to clicked button
                element.classList.add('active');
            }

            function togglePassword() {
                const pwdInput = document.getElementById('password');
                const icon = document.querySelector('.toggle-icon');
                if (pwdInput.type === 'password') {
                    pwdInput.type = 'text';
                    icon.textContent = 'visibility_off';
                } else {
                    pwdInput.type = 'password';
                    icon.textContent = 'visibility';
                }
            }
        </script>
    </body>

    </html>