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
    <section class="pricing-banner">
        <img src="${pageContext.request.contextPath}/images/360_F_572910874_gjyCeTnHtxFMIuPFcfE0djznBMgsU4Bf.jpg" alt="Chính sách giá"
             class="pricing-banner-image">
        <h1 class="pricing-banner-title">CHÍNH SÁCH GIÁ</h1>
    </section>

    <div id="packageData" style="display:none;">
        <c:forEach var="pkg" items="${packages}">
            <div class="pkg-data"
                 data-id="${pkg.packageId}"
                 data-name="<c:out value='${pkg.packageName}'/>"
                 data-duration="${pkg.durationMonths}"
                 data-price="${pkg.price}"
                 data-image="<c:out value='${pkg.image}'/>"
                 data-desc="<c:out value='${pkg.description}'/>">
            </div>
        </c:forEach>
    </div>

    <section class="pricing-section">
        <div class="pricing-content">
            <div class="pricing-tabs" id="pricingTabs"></div>

            <div class="pricing-main" id="pricingMain" style="display: none;">
                <div class="pricing-duration">
                    <ul class="duration-list" id="durationList"></ul>
                </div>

                <div class="pricing-divider"></div>

                <div class="pricing-info">
                    <ul id="pricingInfo"></ul>
                </div>

                <div class="pricing-figure" id="pricingFigure"></div>
            </div>

            <div id="noDataMessage"
                 style="text-align:center; display:none; font-size: 20px; color: #666; padding: 40px;">
                Hiện tại chưa có gói tập nào.
            </div>
        </div>
    </section>

    <h2 class="consult-form-title">ĐĂNG KÝ THAM GIA CÙNG CHÚNG TÔI</h2>
    <jsp:include page="/components/formtapthu.jsp" />
</main>

<jsp:include page="/components/footer.jsp" />

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

        const packages = Array.from(packageElements).map(function (el) {
            return {
                id: el.getAttribute('data-id'),
                name: el.getAttribute('data-name'),
                durationMonths: parseInt(el.getAttribute('data-duration')) || 0,
                price: parseFloat(el.getAttribute('data-price')) || 0,
                image: el.getAttribute('data-image'),
                desc: el.getAttribute('data-desc')
            };
        });

        const packagesByName = {};
        packages.forEach(function (pkg) {
            const name = pkg.name.toUpperCase();
            if (!packagesByName[name]) {
                packagesByName[name] = [];
            }
            packagesByName[name].push(pkg);
        });

        for (let name in packagesByName) {
            packagesByName[name].sort(function (a, b) {
                return b.durationMonths - a.durationMonths;
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
                    currentPackage = packagesByName[name][0];
                    renderTabs();
                    renderDurations();
                };
                tabsContainer.appendChild(btn);
            });
        }

        function renderDurations() {
            durationListContainer.innerHTML = '';
            const items = packagesByName[currentName];

            if (!currentPackage || !items.find(i => i.id === currentPackage.id)) {
                currentPackage = items[0];
            }

            items.forEach(function (item) {
                const li = document.createElement('li');
                li.className = (currentPackage && currentPackage.id === item.id) ? 'active' : '';
                li.textContent = item.durationMonths + " THÁNG";
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

            let durationLabel = currentPackage.durationMonths + " tháng";
            let pricePerMonth = currentPackage.durationMonths > 0 ? (currentPackage.price / currentPackage.durationMonths) : 0;

            var html = [];
            html.push("<li><span>Thời gian tập luyện:</span><strong>" + durationLabel + "</strong></li>");
            html.push("<li><span>Tổng chi phí:</span><strong>" + formatCurrency(currentPackage.price) + "</strong></li>");
            html.push("<li><span>Chi phí / tháng:</span><strong>" + formatCurrency(pricePerMonth) + "</strong></li>");
            if (currentPackage.desc && currentPackage.desc.trim() !== '') {
                const cleanDesc = currentPackage.desc.trim().replace(/\s+/g, ' ');
                const words = cleanDesc.split(' ');

                const truncatedDesc = words.length > 10
                    ? words.slice(0, 10).join(' ') + '...'
                    : cleanDesc;

                html.push("<li><span>Mô tả:</span><strong>" + truncatedDesc + "</strong></li>");
            }

            pricingInfoContainer.innerHTML = html.join('');

            let imgUrl = contextPath + '/images/pricing-man.png';

            if (currentPackage.image && currentPackage.image.trim() !== '') {
                let trimImg = currentPackage.image.trim();

                imgUrl = contextPath + '/uploads/' + trimImg;
            }
            pricingFigureContainer.innerHTML = '<img src="' + imgUrl + '" alt="Huấn luyện">';
        }

        renderTabs();
        renderDurations();
    });
</script>
</body>
</html>