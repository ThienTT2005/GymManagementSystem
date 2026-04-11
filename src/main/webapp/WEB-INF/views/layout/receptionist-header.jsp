<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="app-header">
    <div class="header-glow header-glow-left"></div>
    <div class="header-glow header-glow-right"></div>

    <div class="header-left">
        <div class="header-logo">
            <img src="${pageContext.request.contextPath}/assets/images/logo-gym-transparent.png" alt="Logo">
        </div>
        <div class="header-title">
            <strong>Nhóm 4</strong>
        </div>
    </div>

    <div class="header-right">
        <div class="header-search-wrap" id="receptionistHeaderSearchWrap">
            <button type="button"
                    class="header-icon-btn"
                    title="Tìm kiếm"
                    onclick="toggleReceptionistHeaderSearch(event)">
                <i class="fa-solid fa-magnifying-glass"></i>
            </button>

            <form id="receptionistHeaderSearchBox"
                  class="header-search-box"
                  onsubmit="return submitReceptionistFeatureSearch(event)">
                <input type="text"
                       id="receptionistFeatureKeyword"
                       name="keyword"
                       value=""
                       placeholder="Tìm chức năng: hội viên, thanh toán, lớp...">
                <button type="submit" class="header-search-submit">
                    <i class="fa-solid fa-arrow-right"></i>
                </button>
            </form>
        </div>

        <div class="notification-dropdown" id="receptionistNotificationDropdown">
            <button type="button"
                    class="header-icon-btn"
                    title="Thông báo"
                    onclick="toggleReceptionistNotificationMenu(event)">
                <i class="fa-solid fa-bell"></i>
                <c:if test="${unreadNotificationCount > 0}">
                    <span class="notif-badge">${unreadNotificationCount}</span>
                </c:if>
            </button>

            <div class="notif-menu" id="receptionistNotificationMenu">
                <div class="notif-title">
                    <strong>Thông báo</strong>
                    <span>${unreadNotificationCount} chưa đọc</span>
                </div>

                <c:choose>
                    <c:when test="${not empty headerNotifications}">
                        <c:forEach var="n" items="${headerNotifications}">
                            <a class="notif-item ${n.isRead ? 'notif-item-read' : 'notif-item-unread'}"
                               href="${pageContext.request.contextPath}/notifications/go?id=${n.notificationId}&target=${n.targetUrl}">
                                <div class="notif-item-icon">
                                    <i class="fa-solid ${n.isRead ? 'fa-bell' : 'fa-bell-ring'}"></i>
                                </div>

                                <div class="notif-item-text">
                                    <div class="notif-item-top">
                                        <strong>${n.title}</strong>
                                        <c:if test="${not n.isRead}">
                                            <span class="notif-dot"></span>
                                        </c:if>
                                    </div>

                                    <c:if test="${not empty n.message}">
                                        <span>${n.message}</span>
                                    </c:if>

                                    <c:if test="${not empty n.createdAtDisplay}">
                                        <div class="notif-item-time">${n.createdAtDisplay}</div>
                                    </c:if>
                                </div>
                            </a>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="notif-empty">Chưa có thông báo</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="user-dropdown" id="receptionistUserDropdown">
            <button type="button" class="user-toggle" onclick="toggleReceptionistUserMenu(event)">
                <img class="header-avatar"
                     src="${pageContext.request.contextPath}/${empty loggedInUser.avatar ? 'assets/images/default-avatar.png' : loggedInUser.avatar.startsWith('assets/') ? loggedInUser.avatar : 'uploads/'.concat(loggedInUser.avatar)}"
                     alt="${loggedInUser.displayName}">
                <div class="user-meta">
                    <strong>${loggedInUser.displayName}</strong>
                    <span>${loggedInUser.roleName}</span>
                </div>
                <i class="fa-solid fa-chevron-down"></i>
            </button>

            <div class="user-menu" id="receptionistUserMenu">
                <div class="user-menu-header">
                    <strong>${loggedInUser.displayName}</strong>
                    <span>${loggedInUser.roleName}</span>
                </div>

                <a href="${pageContext.request.contextPath}/receptionist/profile">
                    <i class="fa-solid fa-user"></i>
                    <span>Thông tin cá nhân</span>
                </a>

                <a href="${pageContext.request.contextPath}/receptionist/profile/change-password">
                    <i class="fa-solid fa-key"></i>
                    <span>Đổi mật khẩu</span>
                </a>

                <a href="${pageContext.request.contextPath}/logout">
                    <i class="fa-solid fa-right-from-bracket"></i>
                    <span>Đăng xuất</span>
                </a>
            </div>
        </div>
    </div>
</header>

<script>
    function toggleReceptionistHeaderSearch(event) {
        event.stopPropagation();
        const box = document.getElementById('receptionistHeaderSearchBox');
        const notifMenu = document.getElementById('receptionistNotificationMenu');
        const userMenu = document.getElementById('receptionistUserMenu');

        if (notifMenu) {
            notifMenu.classList.remove('show');
        }
        if (userMenu) {
            userMenu.classList.remove('show');
        }

        if (box) {
            box.classList.toggle('show');
            if (box.classList.contains('show')) {
                const input = document.getElementById('receptionistFeatureKeyword');
                if (input) {
                    setTimeout(function () {
                        input.focus();
                    }, 0);
                }
            }
        }
    }

    function toggleReceptionistNotificationMenu(event) {
        event.stopPropagation();
        const menu = document.getElementById('receptionistNotificationMenu');
        const box = document.getElementById('receptionistHeaderSearchBox');
        const userMenu = document.getElementById('receptionistUserMenu');

        if (box) {
            box.classList.remove('show');
        }
        if (userMenu) {
            userMenu.classList.remove('show');
        }
        if (menu) {
            menu.classList.toggle('show');
        }
    }

    function toggleReceptionistUserMenu(event) {
        event.stopPropagation();
        const menu = document.getElementById('receptionistUserMenu');
        const box = document.getElementById('receptionistHeaderSearchBox');
        const notifMenu = document.getElementById('receptionistNotificationMenu');

        if (box) {
            box.classList.remove('show');
        }
        if (notifMenu) {
            notifMenu.classList.remove('show');
        }
        if (menu) {
            menu.classList.toggle('show');
        }
    }

    function normalizeFeatureKeyword(keyword) {
        return (keyword || '')
            .toLowerCase()
            .trim()
            .normalize('NFD')
            .replace(/[\u0300-\u036f]/g, '');
    }

    function resolveReceptionistFeaturePath(keyword, contextPath) {
        const q = normalizeFeatureKeyword(keyword);

        const mappings = [
            {keys: ['dashboard', 'trang chu', 'tong quan'], path: '/receptionist/dashboard'},
            {keys: ['hoi vien', 'member', 'members'], path: '/receptionist/members'},
            {keys: ['dang ky goi', 'goi tap', 'membership', 'memberships'], path: '/receptionist/memberships'},
            {keys: ['dang ky lop', 'lop hoc', 'class registration', 'class registrations'], path: '/receptionist/class-registrations'},
            {keys: ['thanh toan', 'payment', 'payments'], path: '/receptionist/payments'},
            {keys: ['tap thu', 'trial', 'trials'], path: '/receptionist/trials'},
            {keys: ['tu van', 'consultation', 'consultations'], path: '/receptionist/consultations'},
            {keys: ['ho so', 'profile'], path: '/receptionist/profile'},
            {keys: ['doi mat khau', 'mat khau', 'change password'], path: '/receptionist/change-password'}
        ];

        for (let i = 0; i < mappings.length; i++) {
            for (let j = 0; j < mappings[i].keys.length; j++) {
                if (q.includes(mappings[i].keys[j])) {
                    return contextPath + mappings[i].path;
                }
            }
        }

        return null;
    }

    function submitReceptionistFeatureSearch(event) {
        event.preventDefault();
        const input = document.getElementById('receptionistFeatureKeyword');
        const contextPath = '${pageContext.request.contextPath}';
        const keyword = input ? input.value : '';
        const target = resolveReceptionistFeaturePath(keyword, contextPath);

        if (target) {
            window.location.href = target;
            return false;
        }

        alert('Không tìm thấy chức năng phù hợp. Hãy nhập ví dụ như: hội viên, thanh toán, đăng ký lớp, tập thử...');
        return false;
    }

    document.addEventListener('click', function (event) {
        const searchWrap = document.getElementById('receptionistHeaderSearchWrap');
        const notificationWrap = document.getElementById('receptionistNotificationDropdown');
        const userWrap = document.getElementById('receptionistUserDropdown');
        const searchBox = document.getElementById('receptionistHeaderSearchBox');
        const notificationMenu = document.getElementById('receptionistNotificationMenu');
        const userMenu = document.getElementById('receptionistUserMenu');

        if (searchWrap && !searchWrap.contains(event.target) && searchBox) {
            searchBox.classList.remove('show');
        }

        if (notificationWrap && !notificationWrap.contains(event.target) && notificationMenu) {
            notificationMenu.classList.remove('show');
        }

        if (userWrap && !userWrap.contains(event.target) && userMenu) {
            userMenu.classList.remove('show');
        }
    });


    function initSharedUiEnhancements() {
        document.querySelectorAll('.alert-success, .alert-error').forEach(function (alertBox) {
            if (alertBox.dataset.enhanced === 'true') {
                return;
            }

            alertBox.dataset.enhanced = 'true';
            window.setTimeout(function () {
                alertBox.classList.add('is-hiding');
                window.setTimeout(function () {
                    if (alertBox && alertBox.parentNode) {
                        alertBox.parentNode.removeChild(alertBox);
                    }
                }, 220);
            }, 4200);
        });

        document.querySelectorAll('.js-image-preview').forEach(function (img) {
            if (img.dataset.previewBound === 'true') {
                return;
            }

            img.dataset.previewBound = 'true';
            img.addEventListener('click', function () {
                let modal = document.getElementById('sharedImageModal');
                if (!modal) {
                    modal = document.createElement('div');
                    modal.id = 'sharedImageModal';
                    modal.className = 'image-modal';
                    modal.innerHTML = '' +
                        '<div class="image-modal-dialog">' +
                        '  <button type="button" class="image-close" aria-label="Đóng">&times;</button>' +
                        '  <img class="image-modal-content" alt="Xem ảnh lớn">' +
                        '  <div class="image-modal-caption"></div>' +
                        '</div>';
                    document.body.appendChild(modal);

                    modal.addEventListener('click', function (event) {
                        if (event.target === modal || event.target.classList.contains('image-close')) {
                            modal.classList.remove('show');
                        }
                    });

                    document.addEventListener('keydown', function (event) {
                        if (event.key === 'Escape') {
                            modal.classList.remove('show');
                        }
                    });
                }

                const modalImg = modal.querySelector('.image-modal-content');
                const modalCaption = modal.querySelector('.image-modal-caption');
                const fullSrc = img.dataset.fullSrc || img.getAttribute('src');
                const label = img.dataset.previewLabel || img.getAttribute('alt') || 'Hình ảnh';

                modalImg.setAttribute('src', fullSrc);
                modalImg.setAttribute('alt', label);
                modalCaption.textContent = label;
                modal.classList.add('show');
            });
        });
    }

    document.addEventListener('DOMContentLoaded', initSharedUiEnhancements);

</script>
