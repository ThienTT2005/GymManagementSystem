<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <section class="consult-form-section">
        <h2 class="consult-form-title">ĐĂNG KÝ THAM GIA vÀ NHẬN TƯ VẤN</h2>

        <form class="consult-form" id="consultForm">
            <div class="consult-form-grid">
                <div class="consult-field">
                    <input type="text" name="fullName" placeholder="Họ và tên" required
                        pattern="^[a-zA-ZàáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ\s]+$"
                        title="Tên chỉ bao gồm chữ">
                </div>

                <div class="consult-field consult-field-message">
                    <textarea name="message" placeholder="Bạn có thắc mắc gì chúng tôi không" required></textarea>
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
                    <input type="tel" name="phone" placeholder="Số điện thoại" required pattern="^0\d{9}$"
                        title="Số điện thoại bao gồm 10 số">
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
            const consultForm = document.getElementById("consultForm");
            const successMessage = document.getElementById("consultSuccessMessage");

            if (consultForm) {
                const nameInput = consultForm.querySelector('input[name="fullName"]');
                const phoneInput = consultForm.querySelector('input[name="phone"]');

                const validateName = () => {
                    nameInput.setCustomValidity("");
                    if (!nameInput.validity.valid) {
                        if (nameInput.validity.valueMissing) {
                            nameInput.setCustomValidity("Vui lòng điền họ và tên");
                        } else if (nameInput.validity.patternMismatch) {
                            nameInput.setCustomValidity("Tên chỉ bao gồm chữ");
                        }
                    }
                };

                const validatePhone = () => {
                    phoneInput.setCustomValidity("");
                    if (!phoneInput.validity.valid) {
                        if (phoneInput.validity.valueMissing) {
                            phoneInput.setCustomValidity("Vui lòng điền số điện thoại");
                        } else if (phoneInput.validity.patternMismatch) {
                            phoneInput.setCustomValidity("Số điện thoại bao gồm 10 số");
                        }
                    }
                };

                if (nameInput) {
                    nameInput.addEventListener("input", validateName);
                    nameInput.addEventListener("invalid", validateName);
                }

                if (phoneInput) {
                    phoneInput.addEventListener("input", validatePhone);
                    phoneInput.addEventListener("invalid", validatePhone);
                }

                consultForm.addEventListener("submit", async function (e) {
                    e.preventDefault();

                    if (consultForm.checkValidity()) {
                        const phone = phoneInput.value;
                        const container = consultForm.parentElement;
                        
                        try {
                            const response = await fetch('/api/check-phone?phone=' + phone);
                            const isExist = await response.json();

                            if (isExist) {
                                container.innerHTML = `
                                <h2 class="consult-form-title" style="margin-bottom: 30px;">ĐĂNG KÝ THAM GIA VÀ NHẬN TƯ VẤN</h2>
                                <div style="text-align: center; padding: 60px 20px; background-color: #fff; border-radius: 12px; border: 1px solid #e0e0e0; box-shadow: 0 4px 15px rgba(0,0,0,0.05); animation: fadeIn 0.5s;">
                                    <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="#007bff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-bottom: 15px;">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <line x1="12" y1="16" x2="12" y2="12"></line>
                                        <line x1="12" y1="8" x2="12.01" y2="8"></line>
                                    </svg>
                                    <h3 style="color: #333; font-size: 24px; margin-bottom: 12px; font-weight: 700;">Bạn đã đăng ký!</h3>
                                    <p style="color: #555; font-size: 18px; line-height: 1.5;">Bạn đã đăng ký, chúng tôi sẽ sớm tư vấn.</p>
                                </div>
                                `;
                            } else {
                                // Giả lập lưu thành công - Hoặc thêm API POST lưu vào DB ở đây sau này
                                container.innerHTML = `
                                <h2 class="consult-form-title" style="margin-bottom: 30px;">ĐĂNG KÝ THAM GIA VÀ NHẬN TƯ VẤN</h2>
                                <div style="text-align: center; padding: 60px 20px; background-color: #fff; border-radius: 12px; border: 1px solid #e0e0e0; box-shadow: 0 4px 15px rgba(0,0,0,0.05); animation: fadeIn 0.5s;">
                                    <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="#28a745" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-bottom: 15px;">
                                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                    </svg>
                                    <h3 style="color: #333; font-size: 24px; margin-bottom: 12px; font-weight: 700;">Đăng ký thành công!</h3>
                                    <p style="color: #555; font-size: 18px; line-height: 1.5;">Chúng tôi sẽ liên hệ với bạn sớm nhất.</p>
                                </div>
                                `;
                            }
                        } catch (error) {
                            console.error('Error checking phone:', error);
                            alert("Đã có lỗi xảy ra. Không thể kiểm tra số điện thoại.");
                        }
                    } else {
                        consultForm.reportValidity();
                    }
                });
            }
        })();
    </script>