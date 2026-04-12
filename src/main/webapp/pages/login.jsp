<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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

                        <c:if test="${param.error != null}">
                            <div style="background-color: #fce8e8; color: #b7170e; padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; text-align: center; border: 1px solid #f5c6cb; font-weight: 500;">
                                Sai thông tin vui lòng nhập lại
                            </div>
                        </c:if>

                        <!-- Login Type Tabs -->
                        <div class="role-tabs">
                            <button class="role-btn active" onclick="setRole('member', this)">Hội viên</button>
                            <button class="role-btn" onclick="setRole('staff', this)">Nhân viên</button>
                        </div>

                        <form action="${pageContext.request.contextPath}/login" method="POST">
                            <input type="hidden" id="role" name="role" value="member">

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

                            <div class="form-options" style="flex-direction: column; align-items: flex-start;">
                                <a class="forgot-password" href="javascript:void(0)" onclick="showHotline()">Quên mật khẩu?</a>
                                <div id="hotlineMessage" style="display: none; margin-top: 8px; color: #414753; font-size: 13px;">
                                    Hãy liên hệ hotline <strong style="color: #b7170e;">0355 151 178</strong> để được hỗ trợ.
                                </div>
                            </div>

                            <button class="btn-primary" type="submit">
                                Sign In
                                <span class="material-symbols-outlined">arrow_forward</span>
                            </button>
                        </form>



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

            function showHotline() {
                const message = document.getElementById('hotlineMessage');
                if (message.style.display === 'none') {
                    message.style.display = 'block';
                } else {
                    message.style.display = 'none';
                }
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