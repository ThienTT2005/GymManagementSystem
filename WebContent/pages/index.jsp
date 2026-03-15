
    <html>

    <head>
        <title>Gym Website</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    </head>

    <body>

        <jsp:include page="/components/header.jsp" />

        <div class="banner">
            <img src="${pageContext.request.contextPath}/images/banner.jpg" alt="Banner">
        </div>

        <div class="clubs-section">
            <h2>CÂU LẠC BỘ Ở GẦN BẠN</h2>
            <p>Khám phá hệ thống phòng tập CODEGYM hiện đại, đa dạng, đáp ứng mọi nhu cầu tập luyện của bạn, dù bạn ở
                bất kỳ đâu tại Hà Nội.</p>

            <div class="grid">
                <div class="grid-item">
                    <img src="${pageContext.request.contextPath}/images/zumba-8.png" alt="Zumba">
                    <div class="overlay">ZUMBA</div>
                </div>
                <div class="grid-item">
                    <img src="${pageContext.request.contextPath}/images/bodycombat.png" alt="Body Combat">
                    <div class="overlay">BODY COMBAT</div>
                </div>
                <div class="grid-item">
                    <img src="${pageContext.request.contextPath}/images/bodypump-8.png" alt="Body Pump">
                    <div class="overlay">BODY PUMP</div>
                </div>
                <div class="grid-item">
                    <img src="${pageContext.request.contextPath}/images/bums-tums-8.png" alt="Step Tok">
                    <div class="overlay">STEP TOK</div>
                </div>
                <div class="grid-item">
                    <img src="${pageContext.request.contextPath}/images/pilates.jpg" alt="Pilates">
                    <div class="overlay">PILATES</div>
                </div>
                <div class="grid-item">
                    <img src="${pageContext.request.contextPath}/images/aerobic-8.png" alt="Aerobics">
                    <div class="overlay">AEROBICS</div>
                </div>
            </div>
        </div>

        <div class="news-section">
            <h2 style="text-align: center;">CÂU CHUYỆN HỘI VIÊN</h2>
            <p style="text-align: center; margin-bottom: 30px;">Trải qua hơn 10 năm với hàng ngàn thế hệ hội viên,
                CODEGYM đã chứng kiến rất nhiều sự thay đổi ngoạn mục.<br>Cùng khám phá các câu chuyện "đằng sau phòng
                tập" của các hội viên nhé!</p>

            <div class="slider-container">
                <button class="slider-btn prev-btn" onclick="moveSlide(-1)">❮</button>
                <div class="slider-track-container">
                    <div class="slider-track" id="newsSlider">
                        <!-- Slide 1 -->
                        <div class="slide">
                            <img src="${pageContext.request.contextPath}/images/1.png" alt="News 1">
                            <div class="slide-content">
                                <p>Trong hành trình đem đến không gian tập luyện đẳng cấp CODEGYM tự hào đem đến không
                                    gian tập luyện đẳng cấp, chúng tôi tự hào được hợp tác với Hoist thương hiệu máy tập
                                    nổi tiến toàn cầu.đêt tạo một không gina luyện tập hiện dại, ...</p>
                            </div>
                        </div>
                        <!-- Slide 2 -->
                        <div class="slide">
                            <img src="${pageContext.request.contextPath}/images/2.png" alt="News 2">
                            <div class="slide-content">
                                <p>Rèn luyện thể chất không chỉ đơn thuần là nâng cao sức khỏe mà còn là cách để tái tạo
                                    năng lượng và tinh thần. Group X tại Bluegym sẽ mang đến cho bạn một luồng gió mới!
                                    Với các lớp tập nhóm sôi động và âm nhạc cuốn hút, Group X không chỉ...</p>
                            </div>
                        </div>
                        <!-- Slide 3 -->
                        <div class="slide">
                            <img src="${pageContext.request.contextPath}/images/3.jpg" alt="News 3">
                            <div class="slide-content">
                                <p>Kỷ niệm 10 năm, CODEGYMVõ Thị Sáu hướng tới chặng đường mới với khát vọng kiến tạo
                                    một thế hệ Việt Nam khỏe mạnh – bền bỉ – tràn đầy năng lượng, sẵn sàng chinh phục kỷ
                                    nguyên mới.</p>
                            </div>
                        </div>
                        <!-- Slide 4 -->
                        <div class="slide">
                            <img src="${pageContext.request.contextPath}/images/4.jpg" alt="News 4">
                            <div class="slide-content">
                                <p>Năm 2025, CODEGYM tiếp tục khẳng định vị thế là một trong những hệ thống phòng tập
                                    hàng đầu với bảng giá thẻ tập mới được thiết kế linh hoạt, đáp ứng nhu cầu đa dạng
                                    của các gymer. Đây chính là thời điểm lý tưởng để bạn bắt đầu hành trình nâng...</p>
                            </div>
                        </div>
                        <!-- Slide 5 -->
                        <div class="slide">
                            <img src="${pageContext.request.contextPath}/images/5.png" alt="News 5">
                            <div class="slide-content">
                                <p>Năm 2025, CODEGYM tiếp tục khẳng định vị thế là một trong những hệ thống phòng tập
                                    hàng đầu với bảng giá thẻ tập mới được thiết kế linh hoạt, đáp ứng nhu cầu đa dạng
                                    của các gymer. Đây chính là thời điểm lý tưởng để bạn bắt đầu hành trình nâng...</p>
                            </div>
                        </div>
                        <!-- Slide 6 -->
                        <div class="slide">
                            <img src="${pageContext.request.contextPath}/images/6.jpg" alt="News 6">
                            <div class="slide-content">
                                <p>Chào mừng sinh nhật 10 năm cơ sở Võ Thị Sáu, CODEGYM gửi tới hội viên chương trình
                                    bốc thăm may mắn với những phần quà giá trị, như một lời tri ân dành cho hành trình
                                    đồng hành và gắn bó suốt thập kỷ vừa qua. Đây là cơ hội để mỗi hội viên không chỉ...
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <button class="slider-btn next-btn" onclick="moveSlide(1)">❯</button>
            </div>
        </div>

        <div class="before-after-section">
            <div class="ba-text">
                <h2>BEFORE & AFTER</h2>
                <p>Tập luyện chăm chỉ là yếu tố then chốt để có một<br>thân hình đẹp, nhưng không phải là yếu tố duy
                    nhất.</p>
            </div>
            <div class="ba-slider-container">
                <div class="ba-images">
                    <img src="${pageContext.request.contextPath}/images/before.png" alt="Before" class="ba-before">
                    <img src="${pageContext.request.contextPath}/images/after.png" alt="After" class="ba-after"
                        id="baAfterImage">
                </div>
                <input type="range" min="0" max="100" value="50" class="ba-slider" id="baSlider"
                    oninput="updateBeforeAfter(this.value)">
                <div class="slider-button" id="sliderButton"></div>
            </div>
        </div>

        <div class="bmi-section">
            <div class="bmi-image">
                <img src="${pageContext.request.contextPath}/images/run.png" alt="Run">
            </div>
            <div class="bmi-content">
                <h2>TÍNH BMI (CHỈ SỐ KHỐI CƠ THỂ)</h2>
                <p>Để lại thông tin và chúng tôi sẽ gửi lại kết quả cho bạn trong thời gian sớm nhất!</p>

                <form id="bmiForm" class="bmi-form">
                    <input type="text" name="height" placeholder="Chiều cao/ cm" required>
                    <input type="text" name="weight" placeholder="Cân nặng/ kg" required>
                    <input type="text" name="age" placeholder="Tuổi" required>
                    <select name="gender" required>
                        <option value="" disabled selected>Giới tính</option>
                        <option value="Nam">Nam</option>
                        <option value="Nữ">Nữ</option>
                    </select>
                    <input type="text" name="fullname" placeholder="Họ và tên" pattern="[A-Za-zÀ-ỹ\s]+"
                        title="Vui lòng chỉ nhập chữ cái" required>
                    <input type="text" name="phone" placeholder="Số điện thoại" pattern="[0-9]{10}"
                        title="Vui lòng nhập đúng 10 số" required>
                    <div class="bmi-submit">
                        <button type="submit">Nhận kết quả</button>
                    </div>
                </form>
                <div id="bmiMessage" class="bmi-success-message" style="display:none;">
                    Cảm ơn bạn, chúng tôi đã nhận thông tin!
                </div>
            </div>
        </div>


        <jsp:include page="/components/footer.jsp" />

        <script>
            // News Slider Logic
            let currentSlide = 0;
            const visibleSlides = 3;

            function moveSlide(direction) {
                const track = document.getElementById('newsSlider');
                const slides = document.querySelectorAll('.slide');
                const totalSlides = slides.length;

                if (totalSlides === 0) return;

                currentSlide += direction;

                // Boundaries
                if (currentSlide < 0) {
                    currentSlide = 0;
                } else if (currentSlide > totalSlides - visibleSlides) {
                    currentSlide = totalSlides - visibleSlides;
                }

                // Using percentage translation since flex basis is set with percentages
                // A single slide takes up a slot + gap. Moving one slide means shifting left by (100% / visibleSlides)
                // However, since CSS defines flex: 0 0 calc(33.333% - 14px) and a 20px gap:
                // We shift by the exact width of one slide + gap. 
                // For better compatibility across different zoom levels, let's calculate based on the first slide's actual rendered width.
                const singleSlideWidth = slides[0].getBoundingClientRect().width;
                const gapWidth = 20;
                const moveAmount = (singleSlideWidth + gapWidth) * currentSlide;

                track.style.transition = 'transform 0.4s ease-in-out';
                track.style.transform = `translateX(-${moveAmount}px)`;
            }

            // Before/After Logic
            function updateBeforeAfter(value) {
                const afterImage = document.getElementById('baAfterImage');
                const sliderBtn = document.getElementById('sliderButton');
                // The after image is clipped using a polygon to reveal the before image
                afterImage.style.clipPath = `polygon(${value}% 0, 100% 0, 100% 100%, ${value}% 100%)`;
                sliderBtn.style.left = `${value}%`;
            }

            // BMI Form AJAX Logic
            document.getElementById("bmiForm").addEventListener("submit", function (e) {
                e.preventDefault();
                const formData = new FormData(this);
                fetch("${pageContext.request.contextPath}/pages/saveBmi.jsp", {
                    method: "POST",
                    body: formData
                })
                    .then(res => res.text())
                    .then(data => {
                        if (data.trim() === "success") {
                            document.getElementById("bmiForm").style.display = "none";
                            document.getElementById("bmiMessage").style.display = "block";
                        }
                    });
            });
        </script>
    </body>

    </html>