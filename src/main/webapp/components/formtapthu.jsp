<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<section class="consult-form-section">
    <form class="consult-form" id="trialForm">
        <div class="consult-form-grid">
            <div class="consult-field">
                <input type="text" name="fullName" placeholder="Họ và tên" required>
            </div>

            <div class="consult-field consult-field-message">
                <textarea name="note" placeholder="Ghi chú thêm (mong muốn tập bộ môn nào, thời gian rảnh...)" required></textarea>
            </div>

            <div class="consult-field">
                <input type="email" name="email" placeholder="Email" required>
            </div>

            <div class="consult-field">
                <input type="tel" name="phone" placeholder="Số điện thoại" required inputmode="numeric">
            </div>

            <div class="consult-field" style="grid-column: 1 / -1; width: 100%;">
                <label style="display:block; margin-bottom: 5px; font-family: 'Roboto', sans-serif; font-size:14px;">Ngày tập thử mong muốn:</label>
                <input type="date" name="preferredDate" required style="width: 100%;">
            </div>
        </div>

        <div class="consult-form-action">
            <button type="submit" class="consult-btn">ĐĂNG KÝ NGAY</button>
        </div>

        <p id="trialSuccessMessage" class="consult-success-message">
            Chúng tôi sẽ liên hệ với bạn sớm nhất.
        </p>
    </form>
</section>

<script>
    (function () {
        const ctxPath = "${pageContext.request.contextPath}";
        const trialForm = document.getElementById("trialForm");

        if (!trialForm) return;

        const nameInput = trialForm.querySelector('input[name="fullName"]');
        const phoneInput = trialForm.querySelector('input[name="phone"]');
        const preferredDateInput = trialForm.querySelector('input[name="preferredDate"]');

        if (preferredDateInput) {
            const today = new Date().toISOString().split("T")[0];
            preferredDateInput.min = today;
        }

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

        trialForm.addEventListener("submit", async function (e) {
            e.preventDefault();

            validateName();
            validatePhone();

            if (!trialForm.checkValidity()) {
                trialForm.reportValidity();
                return;
            }

            const name = normalizeSpaces(nameInput.value);
            const phone = phoneInput.value.trim().replace(/\s+/g, "");
            const email = trialForm.querySelector('input[name="email"]').value.trim();
            const note = trialForm.querySelector('textarea[name="note"]').value.trim();
            const preferredDate = preferredDateInput.value;
            const container = trialForm.parentElement;

            try {
                const response = await fetch(ctxPath + '/api/trial-requests', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        fullName: name,
                        phone: phone,
                        email: email,
                        preferredDate: preferredDate,
                        note: note
                    })
                });

                const responseText = await response.text();
                if (!response.ok) {
                    alert(responseText || "Đã có lỗi xảy ra. Vui lòng thử lại sau.");
                    return;
                }

                container.innerHTML = `
                    <h2 class="consult-form-title" style="margin-bottom: 30px;">ĐĂNG KÝ TẬP THỬ</h2>
                    <div style="text-align: center; padding: 60px 20px; background-color: #fff; border-radius: 12px; border: 1px solid #e0e0e0; box-shadow: 0 4px 15px rgba(0,0,0,0.05); animation: fadeIn 0.5s;">
                        <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="#28a745" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-bottom: 15px;">
                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                        </svg>
                        <h3 style="color: #333; font-size: 24px; margin-bottom: 12px; font-weight: 700;">Đăng ký tập thử thành công!</h3>
                        <p style="color: #555; font-size: 18px; line-height: 1.5;">Chúng tôi sẽ liên hệ để xác nhận lịch tập cho bạn.</p>
                    </div>
                `;
            } catch (error) {
                console.error('Error saving form data:', error);
                alert("Đã có lỗi xảy ra. Vui lòng thử lại sau.");
            }
        });
    })();
</script>