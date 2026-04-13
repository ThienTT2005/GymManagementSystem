<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<section class="consult-form-section">
    <form class="consult-form" id="consultForm">
        <div class="consult-form-grid">
            <div class="consult-field">
                <input type="text" name="fullName" placeholder="Họ và tên" required>
            </div>

            <div class="consult-field consult-field-message">
                <textarea name="message" placeholder="Bạn có thắc mắc gì với chúng tôi không" required></textarea>
            </div>

            <div class="consult-field">
                <select name="gender" required>
                    <option value="">Giới tính</option>
                    <option value="male">Nam</option>
                    <option value="female">Nữ</option>
                    <option value="other">Khác</option>
                </select>
            </div>

            <div class="consult-field">
                <input type="tel" name="phone" placeholder="Số điện thoại" required inputmode="numeric">
            </div>
        </div>

        <div class="consult-form-action">
            <button type="submit" class="consult-btn">ĐĂNG KÝ NGAY</button>
        </div>

        <p id="consultSuccessMessage" class="consult-success-message">
            Chúng tôi sẽ liên hệ với bạn sớm nhất.
        </p>
    </form>
</section>

<script>
    (function () {
        const ctxPath = "${pageContext.request.contextPath}";
        const consultForm = document.getElementById("consultForm");

        if (!consultForm) return;

        const nameInput = consultForm.querySelector('input[name="fullName"]');
        const phoneInput = consultForm.querySelector('input[name="phone"]');

        function normalizeSpaces(value) {
            return value.trim().replace(/\s+/g, " ");
        }

        function isValidFullName(value) {
            const normalized = normalizeSpaces(value);
            return /^[\p{L}\s.]+$/u.test(normalized) && normalized.length >= 2;
        }

        function isValidPhone(value) {
            const normalized = value.trim().replace(/\s+/g, "");
            return /^0\d{9}$/.test(normalized);
        }

        const validateName = () => {
            const value = nameInput.value;
            nameInput.setCustomValidity("");

            if (!value.trim()) {
                nameInput.setCustomValidity("Vui lòng điền họ và tên");
                return;
            }

            if (!isValidFullName(value)) {
                nameInput.setCustomValidity("Họ tên chỉ bao gồm chữ cái, khoảng trắng hoặc dấu chấm");
            }
        };

        const validatePhone = () => {
            const value = phoneInput.value;
            phoneInput.setCustomValidity("");

            if (!value.trim()) {
                phoneInput.setCustomValidity("Vui lòng điền số điện thoại");
                return;
            }

            if (!isValidPhone(value)) {
                phoneInput.setCustomValidity("Số điện thoại phải gồm đúng 10 số và bắt đầu bằng số 0");
            }
        };

        nameInput.addEventListener("input", validateName);
        nameInput.addEventListener("blur", validateName);
        nameInput.addEventListener("invalid", validateName);

        phoneInput.addEventListener("input", validatePhone);
        phoneInput.addEventListener("blur", validatePhone);
        phoneInput.addEventListener("invalid", validatePhone);

        consultForm.addEventListener("submit", async function (e) {
            e.preventDefault();

            validateName();
            validatePhone();

            if (!consultForm.checkValidity()) {
                consultForm.reportValidity();
                return;
            }

            const name = normalizeSpaces(nameInput.value);
            const phone = phoneInput.value.trim().replace(/\s+/g, "");
            const gender = consultForm.querySelector('select[name="gender"]').value;
            const message = consultForm.querySelector('textarea[name="message"]').value.trim();
            const container = consultForm.parentElement;

            try {
                const response = await fetch(ctxPath + '/api/consultations', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        fullName: name,
                        phone: phone,
                        gender: gender,
                        message: message
                    })
                });

                const responseText = await response.text();
                if (!response.ok) {
                    alert(responseText || "Đã có lỗi xảy ra trong quá trình gửi yêu cầu tư vấn.");
                    return;
                }

                container.innerHTML = `

                    <div style="text-align: center; padding: 60px 20px; background-color: #fff; border-radius: 12px; border: 1px solid #e0e0e0; box-shadow: 0 4px 15px rgba(0,0,0,0.05); animation: fadeIn 0.5s;">
                        <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="#28a745" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-bottom: 15px;">
                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                        </svg>
                        <h3 style="color: #333; font-size: 24px; margin-bottom: 12px; font-weight: 700;">Đăng ký thành công!</h3>
                        <p style="color: #555; font-size: 18px; line-height: 1.5;">Chúng tôi sẽ liên hệ với bạn sớm nhất.</p>
                    </div>
                `;
            } catch (error) {
                console.error('Error saving form data:', error);
                alert("Đã có lỗi xảy ra trong quá trình gửi yêu cầu tư vấn. Vui lòng thử lại sau.");
            }
        });
    })();
</script>