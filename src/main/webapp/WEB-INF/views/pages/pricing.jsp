<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PTIT Gym - Chính sách giá</title>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pricing.css">
            <style>
                .pricing-tab {
                    cursor: pointer;
                }

                .duration-list li {
                    cursor: pointer;
                }
            </style>
        </head>

        <body>
            <jsp:include page="/components/header.jsp" />

            <main class="pricing-page">
                <!-- Banner -->
                <section class="pricing-banner">
                    <img src="${pageContext.request.contextPath}/images/banner-pricing.png" alt="Chính sách giá"
                        class="pricing-banner-image">
                    <h1 class="pricing-banner-title">CHÍNH SÁCH GIÁ</h1>
                </section>

                <!-- Dữ liệu gói tập ẩn để JS xử lý -->
                <div id="packageData" style="display:none;">
                    <c:forEach var="pkg" items="${packages}">
                        <div class="pkg-data" data-id="${pkg.packageId}" data-name="<c:out value='${pkg.packageName}'/>"
                            data-duration="${pkg.durationDays}" data-price="${pkg.price}"
                            data-image="<c:out value='${pkg.image}'/>" data-desc="<c:out value='${pkg.description}'/>">
                        </div>
                    </c:forEach>
                </div>

                <!-- Bảng giá -->
                <section class="pricing-section">
                    <div class="pricing-content">
                        <div class="pricing-tabs" id="pricingTabs">
                            <!-- JS sẽ điền các tab vào đây -->
                        </div>

                        <div class="pricing-main" id="pricingMain" style="display: none;">
                            <div class="pricing-duration">
                                <ul class="duration-list" id="durationList">
                                    <!-- JS sẽ điền các tùy chọn thời gian -->
                                </ul>
                            </div>

                            <div class="pricing-divider"></div>

                            <div class="pricing-info">
                                <ul id="pricingInfo">
                                    <!-- JS sẽ điền thông tin chi tiết -->
                                </ul>
                            </div>

                            <div class="pricing-figure" id="pricingFigure">
                                <!-- JS sẽ điền hình ảnh -->
                            </div>
                        </div>

                        <div id="noDataMessage"
                            style="text-align:center; display:none; font-size: 20px; color: #666; padding: 40px;">
                            Hiện tại chưa có gói tập nào.
                        </div>

                    </div>
                </section>
                <h2 class="consult-form-title">ĐĂNG KÝ THAM GIA CÙNG CHÚNG TÔI</h2>
                <jsp:include page="/components/formtapthu.jsp" />
                <jsp:include page="/components/footer.jsp" />
            </main>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const contextPath = '${pageContext.request.contextPath}';
                    const packageElements = document.querySelectorAll('.pkg-data');

                    if (packageElements.length === 0) {
                        document.getElementById('noDataMessage').style.display = 'block';
                        return;
                    } else {
                        document.getElementById('pricingMain').style.display = 'grid';
                    }

                    // 1. Phân tích dữ liệu từ HTML ẩn
                    const packages = Array.from(packageElements).map(function (el) {
                        return {
                            id: el.getAttribute('data-id'),
                            name: el.getAttribute('data-name'),
                            durationDays: parseInt(el.getAttribute('data-duration')) || 0,
                            price: parseFloat(el.getAttribute('data-price')) || 0,
                            image: el.getAttribute('data-image'),
                            desc: el.getAttribute('data-desc')
                        };
                    });

                    // 2. Nhóm theo tên gói tập (e.g. CLASSIC, PREMIUM)
                    const packagesByName = {};
                    packages.forEach(function (pkg) {
                        const name = pkg.name.toUpperCase();
                        if (!packagesByName[name]) {
                            packagesByName[name] = [];
                        }
                        packagesByName[name].push(pkg);
                    });

                    // 3. Sắp xếp các thời hạn từ lớn tới bé (24 Tháng -> 12 Tháng...)
                    for (let name in packagesByName) {
                        packagesByName[name].sort(function (a, b) {
                            return b.durationDays - a.durationDays;
                        });
                    }

                    const tabsContainer = document.getElementById('pricingTabs');
                    const durationListContainer = document.getElementById('durationList');
                    const pricingInfoContainer = document.getElementById('pricingInfo');
                    const pricingFigureContainer = document.getElementById('pricingFigure');

                    let currentName = Object.keys(packagesByName)[0];
                    let currentPackage = null;

                    function formatCurrency(amount) {
                        return Math.round(amount).toLocaleString('vi-VN') + ' VNĐ';
                    }

                    function renderTabs() {
                        tabsContainer.innerHTML = '';
                        Object.keys(packagesByName).forEach(function (name) {
                            const btn = document.createElement('button');
                            btn.type = 'button';
                            btn.className = 'pricing-tab' + (name === currentName ? ' active' : '');
                            btn.textContent = name;
                            btn.onclick = function () {
                                currentName = name;
                                currentPackage = packagesByName[name][0]; // Reset về thời hạn lớn nhất
                                renderTabs();
                                renderDurations();
                            };
                            tabsContainer.appendChild(btn);
                        });
                    }

                    function renderDurations() {
                        durationListContainer.innerHTML = '';
                        const items = packagesByName[currentName];

                        // Đảm bảo currentPackage nằm trong tab hiện tại
                        if (!currentPackage || !items.find(i => i.id === currentPackage.id)) {
                            currentPackage = items[0];
                        }

                        items.forEach(function (item) {
                            const li = document.createElement('li');
                            li.className = (currentPackage && currentPackage.id === item.id) ? 'active' : '';

                            // Quy đổi ra tháng nếu phù hợp
                            let months = Math.round(item.durationDays / 30);
                            let label = "";
                            if (months > 0 && Math.abs(months * 30 - item.durationDays) <= 5) {
                                label = months + " THÁNG";
                            } else {
                                label = item.durationDays + " NGÀY";
                            }

                            li.textContent = label;
                            li.onclick = function () {
                                currentPackage = item;
                                renderDurations();
                            };
                            durationListContainer.appendChild(li);
                        });

                        renderInfo();
                    }

                    function renderInfo() {
                        if (!currentPackage) return;

                        let months = Math.round(currentPackage.durationDays / 30);
                        let durationLabel = '';

                        if (months > 0 && Math.abs(months * 30 - currentPackage.durationDays) <= 5) {
                            durationLabel = months + " tháng";
                        } else {
                            durationLabel = currentPackage.durationDays + " ngày";
                        }

                        let pricePerMonth = months > 0 ? (currentPackage.price / months) : 0;
                        let pricePerDay = currentPackage.durationDays > 0 ? (currentPackage.price / currentPackage.durationDays) : 0;

                        // Sử dụng nối chuỗi truyền thống để ko xung đột với JSTL EL
                        var html = [];
                        html.push("<li><span>Thời gian tập luyện:</span><strong>" + durationLabel + "</strong></li>");
                        html.push("<li><span>Tổng chi phí:</span><strong>" + formatCurrency(currentPackage.price) + "</strong></li>");
                        html.push("<li><span>Chi phí / tháng:</span><strong>" + formatCurrency(pricePerMonth) + "</strong></li>");
                        html.push("<li><span>Chi phí / ngày:</span><strong>" + formatCurrency(pricePerDay) + "</strong></li>");
                        if (currentPackage.desc && currentPackage.desc.trim() !== '') {
                            html.push("<li><span>Mô tả:</span><strong>" + currentPackage.desc + "</strong></li>");
                        }

                        pricingInfoContainer.innerHTML = html.join('');

                        let imgUrl = contextPath + '/images/pricing-man.png';
                        if (currentPackage.image && currentPackage.image.trim() !== '') {
                            let trimImg = currentPackage.image.trim();
                            imgUrl = trimImg.startsWith('/')
                                ? contextPath + trimImg
                                : contextPath + '/' + trimImg;
                        }
                        pricingFigureContainer.innerHTML = '<img src="' + imgUrl + '" alt="Huấn luyện">';
                    }

                    // Khởi chạy trình vẽ giao diện
                    renderTabs();
                    renderDurations();
                });
            </script>
        </body>

        </html>