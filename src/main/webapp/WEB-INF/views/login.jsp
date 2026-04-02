<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PTIT Gym - Authentication</title>
        <style>
            /* Cấu hình màu sắc và font chữ đồng bộ */
            body { 
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
                background: linear-gradient(120deg, #2980b9, #8e44ad);
                height: 100vh; margin: 0;
                display: flex; justify-content: center; align-items: center;
            }
            .container {
                background: white; padding: 30px; border-radius: 10px;
                box-shadow: 0 15px 25px rgba(0,0,0,0.2); width: 350px;
            }
            h1 { text-align: center; color: #333; margin-bottom: 20px; }
            input[type="text"], input[type="password"], input[type="email"] {
                width: 100%; padding: 10px; margin: 10px 0;
                border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box;
            }
            input[type="submit"] {
                width: 100%; padding: 10px; border: none; border-radius: 5px;
                background: #3498db; color: white; font-weight: bold; cursor: pointer;
            }
            input[type="submit"]:hover { background: #2980b9; }
            .error { color: red; text-align: center; font-size: 14px; margin-bottom: 10px; }
            .toggle-link { text-align: center; margin-top: 15px; font-size: 13px; color: #666; cursor: pointer; }
            .toggle-link:hover { color: #3498db; text-decoration: underline; }
            #registerForm { display: none; } /* Mặc định ẩn form đăng ký */
        </style>
    </head>
    <body>
        <div class="container">
            <h1 id="formTitle">ĐĂNG NHẬP</h1>
            <div class="error">${requestScope.error}</div>

            <form id="loginForm" action="${pageContext.request.contextPath}/login" method="post">
                <input type="text" name="user" placeholder="Username" required>
                <input type="password" name="pass" placeholder="Password" required>
                <input type="submit" value="LOGIN">
                <div class="toggle-link" onclick="showRegister()">Chưa có tài khoản? Đăng ký ngay</div>
            </form>

            <form id="registerForm" action="register" method="post">
                <input type="text" name="user" placeholder="Tên tài khoản mới" required>
                <input type="password" name="pass" placeholder="Mật khẩu" required>
                <input type="text" name="name" placeholder="Họ và tên" required>
                <input type="email" name="email" placeholder="Email" required>
                <input type="submit" value="ĐĂNG KÝ">
                <div class="toggle-link" onclick="showLogin()">Đã có tài khoản? Đăng nhập</div>
            </form>
        </div>

        <script>
            function showRegister() {
                document.getElementById('loginForm').style.display = 'none';
                document.getElementById('registerForm').style.display = 'block';
                document.getElementById('formTitle').innerText = 'ĐĂNG KÝ';
            }
            function showLogin() {
                document.getElementById('registerForm').style.display = 'none';
                document.getElementById('loginForm').style.display = 'block';
                document.getElementById('formTitle').innerText = 'ĐĂNG NHẬP';
            }

            // Form Validation Logic
            document.addEventListener("DOMContentLoaded", function () {
                // Validate Tên: Chỉ được nhập chữ và khoảng trắng (bao gồm cả tiếng Việt)
                const nameInputs = document.querySelectorAll('input[name="name"], input[name="fullName"], input[name="fullname"]');
                nameInputs.forEach(input => {
                    input.addEventListener('input', function () {
                        if (/[^a-zA-Z\u00C0-\u1EF9\s]/.test(this.value)) {
                            showError(this, 'Tên chỉ được chứa chữ cái!');
                            this.value = this.value.replace(/[^a-zA-Z\u00C0-\u1EF9\s]/g, ''); 
                        } else {
                            removeError(this);
                        }
                    });
                });

                // Validate SĐT: Bắt đầu bằng 0 và tối đa 10 số
                const phoneInputs = document.querySelectorAll('input[name="phone"]');
                phoneInputs.forEach(input => {
                    input.addEventListener('input', function () {
                        let val = this.value.replace(/[^\d]/g, '');
                        if (val.length > 0 && val[0] !== '0') {
                            val = '0' + val.substring(1);
                            showError(this, 'Số điện thoại phải bắt đầu bằng 0!');
                        }
                        if (val.length > 10) {
                            val = val.substring(0, 10);
                        }
                        this.value = val;
                        if (val.length > 0 && val.length < 10) {
                            showError(this, 'Số điện thoại phải đủ 10 chữ số!');
                        } else if (val.length === 10) {
                            removeError(this);
                        } else if (val.length === 0) {
                            removeError(this);
                        }
                    });
                });

                // Validate Tuổi, Chiều cao, Cân nặng: Chỉ được nhập số
                const numInputs = document.querySelectorAll('input[name="age"], input[name="height"], input[name="weight"]');
                numInputs.forEach(input => {
                    input.addEventListener('input', function () {
                        if (/[^\d.]/.test(this.value)) {
                            showError(this, 'Trường này chỉ được nhập số!');
                            this.value = this.value.replace(/[^\d.]/g, ''); 
                        } else {
                            removeError(this);
                        }
                    });
                });

                // Validate Email (không có khoảng trắng, tiếng Việt)
                const emailInputs = document.querySelectorAll('input[name="email"], input[type="email"]');
                emailInputs.forEach(input => {
                    input.addEventListener('input', function () {
                        if (/[\s\u00C0-\u017F]/.test(this.value)) {
                            showError(this, 'Email không được chứa khoảng trắng hoặc tiếng Việt!');
                            this.value = this.value.replace(/[\s\u00C0-\u017F]/g, '');
                        } else {
                            removeError(this);
                        }
                    });
                });

                function showError(input, message) {
                    let errorElement = input.nextElementSibling;
                    if (!errorElement || !errorElement.classList.contains('input-error-msg')) {
                        errorElement = document.createElement('span');
                        errorElement.classList.add('input-error-msg');
                        errorElement.style.color = 'red';
                        errorElement.style.fontSize = '12px';
                        errorElement.style.display = 'block';
                        errorElement.style.marginTop = '5px';
                        input.parentNode.insertBefore(errorElement, input.nextSibling);
                    }
                    errorElement.innerText = message;
                    clearTimeout(input.errorTimeout);
                    input.errorTimeout = setTimeout(() => removeError(input), 3000);
                }

                function removeError(input) {
                    let errorElement = input.nextElementSibling;
                    if (errorElement && errorElement.classList.contains('input-error-msg')) {
                        errorElement.remove();
                    }
                }
            });
        </script>
    </body>
</html>