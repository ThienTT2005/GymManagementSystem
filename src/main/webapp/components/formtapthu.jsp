<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <section class="consult-form-section">


        <form class="consult-form" id="trialForm">
            <div class="consult-form-grid">
                <div class="consult-field">
                    <input type="text" name="fullName" placeholder="Họ và tên" required
                        pattern="^[a-zA-ZàáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ\s]+$"
                        title="Tên chỉ bao gồm chữ">
                </div>

                <div class="consult-field consult-field-message">
                    <textarea name="note" placeholder="Ghi chú thêm (mong muốn tập bộ môn nào, thời gian rảnh...)" required></textarea>
                </div>

                <div class="consult-field">
                    <input type="email" name="email" placeholder="Email" required>
                </div>

                <div class="consult-field">
                    <input type="tel" name="phone" placeholder="Số điện thoại" required pattern="^0\d{9}$"
                        title="Số điện thoại bao gồm 10 số">
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
            const trialForm = document.getElementById("trialForm");
            const successMessage = document.getElementById("trialSuccessMessage");

            if (trialForm) {
                const nameInput = trialForm.querySelector('input[name="fullName"]');
                const phoneInput = trialForm.querySelector('input[name="phone"]');

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

                trialForm.addEventListener("submit", async function (e) {
                    e.preventDefault();

                    if (trialForm.checkValidity()) {
                        const name = nameInput.value;
                        const phone = phoneInput.value;
                        const email = trialForm.querySelector('input[name="email"]').value;
                        const note = trialForm.querySelector('textarea[name="note"]').value;
                        const preferredDate = trialForm.querySelector('input[name="preferredDate"]').value;
                        const container = trialForm.parentElement;
                        
                        try {
                            const response = await fetch('/api/trial-requests', {
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

                            if (!response.ok) {
                                throw new Error('Failed to save data');
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
                    } else {
                        trialForm.reportValidity();
                    }
                });
            }
        })();
    </script>
