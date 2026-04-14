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
            <strong>GYM PRO</strong>
        </div>
    </div>

    <div class="header-right">
        <div class="header-search-wrap" id="adminHeaderSearchWrap">
            <button type="button"
                    class="header-icon-btn"
                    title="Tìm kiếm"
                    id="adminHeaderSearchToggle">
                <i class="fa-solid fa-magnifying-glass"></i>
            </button>

            <form id="adminHeaderSearchBox"
                  class="header-search-box"
                  onsubmit="return submitAdminFeatureSearch(event)">
                <input type="text"
                       id="adminFeatureKeyword"
                       name="keyword"
                       value=""
                       placeholder="Tìm chức năng: hội viên, tài khoản, thanh toán...">
                <button type="submit" class="header-search-submit">
                    <i class="fa-solid fa-arrow-right"></i>
                </button>
            </form>
        </div>

        <div class="notification-dropdown" id="adminNotificationDropdown">
            <button type="button"
                    class="header-icon-btn"
                    title="Thông báo"
                    id="adminNotificationToggle"
                    aria-expanded="false">
                <i class="fa-solid fa-bell"></i>
                <c:if test="${unreadNotificationCount > 0}">
                    <span class="notif-badge">${unreadNotificationCount}</span>
                </c:if>
            </button>

            <div class="notif-menu" id="adminNotificationMenu">
                <div class="notif-title notif-title-row">
                    <div>
                        <strong>Thông báo</strong>
                        <span>${unreadNotificationCount} chưa đọc</span>
                    </div>
                    <c:if test="${unreadNotificationCount > 0}">
                        <form method="post" action="${pageContext.request.contextPath}/notifications/mark-all-read" class="notif-mark-all-form">
                            <input type="hidden" name="target" value="/admin/dashboard">
                            <button type="submit" class="notif-mark-all-btn">Đánh dấu tất cả đã đọc</button>
                        </form>
                    </c:if>
                </div>

                <c:choose>
                    <c:when test="${not empty headerNotifications}">
                        <c:forEach var="n" items="${headerNotifications}">
                            <a class="notif-item ${n.isRead ? 'notif-item-read' : 'notif-item-unread'}"
                               href="${pageContext.request.contextPath}/notifications/go?id=${n.notificationId}">
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

        <div class="user-dropdown" id="adminUserDropdown">
            <button type="button"
                    class="user-toggle"
                    id="adminUserToggle"
                    aria-expanded="false">
                <img class="header-avatar"
                     src="${pageContext.request.contextPath}/${empty loggedInUser.avatar ? 'assets/images/default-avatar.png' : (loggedInUser.avatar.startsWith('assets/') ? loggedInUser.avatar : 'uploads/'.concat(loggedInUser.avatar))}"
                     alt="${loggedInUser.displayName}">
                <div class="user-meta">
                    <strong>${loggedInUser.displayName}</strong>
                    <span>${loggedInUser.roleName}</span>
                </div>
                <i class="fa-solid fa-chevron-down"></i>
            </button>

            <div class="user-menu" id="adminUserMenu">
                <div class="user-menu-header">
                    <strong>${loggedInUser.displayName}</strong>
                    <span>${loggedInUser.roleName}</span>
                </div>

                <a href="${pageContext.request.contextPath}/admin/profile">
                    <i class="fa-solid fa-user"></i>
                    <span>Thông tin cá nhân</span>
                </a>

                <a href="${pageContext.request.contextPath}/admin/profile/change-password">
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
    function normalizeFeatureKeyword(keyword) {
        return (keyword || '')
            .toLowerCase()
            .trim()
            .normalize('NFD')
            .replace(/[\u0300-\u036f]/g, '');
    }

    function resolveAdminFeaturePath(keyword, contextPath) {
        const q = normalizeFeatureKeyword(keyword);

        const mappings = [
            {keys: ['dashboard', 'trang chu', 'tong quan'], path: '/admin/dashboard'},
            {keys: ['tai khoan', 'user', 'users'], path: '/admin/users'},
            {keys: ['hoi vien', 'member', 'members'], path: '/admin/members'},
            {keys: ['nhan vien', 'staff'], path: '/admin/staff'},
            {keys: ['huan luyen vien', 'trainer', 'trainers', 'hlv'], path: '/admin/trainers'},
            {keys: ['dich vu', 'service', 'services'], path: '/admin/services'},
            {keys: ['goi tap', 'package', 'packages', 'membership package'], path: '/admin/packages'},
            {keys: ['lop hoc', 'class', 'classes'], path: '/admin/classes'},
            {keys: ['lich hoc', 'schedule', 'schedules'], path: '/admin/schedules'},
            {keys: ['dang ky goi', 'membership', 'memberships'], path: '/admin/memberships'},
            {keys: ['dang ky lop', 'class registration', 'class registrations'], path: '/admin/class-registrations'},
            {keys: ['tap thu', 'trial', 'trials'], path: '/admin/trials'},
            {keys: ['tu van', 'contact', 'contacts'], path: '/admin/contacts'},
            {keys: ['thanh toan', 'payment', 'payments'], path: '/admin/payments'},
            {keys: ['tin tuc', 'news'], path: '/admin/news'},
            {keys: ['bao cao', 'report', 'reports'], path: '/admin/reports'},
            {keys: ['ho so', 'profile'], path: '/admin/profile'},
            {keys: ['doi mat khau', 'mat khau', 'change password'], path: '/admin/profile/change-password'}
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

    function submitAdminFeatureSearch(event) {
        event.preventDefault();
        const input = document.getElementById('adminFeatureKeyword');
        const contextPath = '${pageContext.request.contextPath}';
        const keyword = input ? input.value : '';
        const target = resolveAdminFeaturePath(keyword, contextPath);

        if (target) {
            window.location.href = target;
            return false;
        }

        alert('Không tìm thấy chức năng phù hợp. Hãy nhập ví dụ như: hội viên, tài khoản, thanh toán, lớp học, lịch học...');
        return false;
    }

    (function () {
        const searchWrap = document.getElementById('adminHeaderSearchWrap');
        const searchToggle = document.getElementById('adminHeaderSearchToggle');
        const searchBox = document.getElementById('adminHeaderSearchBox');
        const searchInput = document.getElementById('adminFeatureKeyword');

        const notificationWrap = document.getElementById('adminNotificationDropdown');
        const notificationToggle = document.getElementById('adminNotificationToggle');
        const notificationMenu = document.getElementById('adminNotificationMenu');

        const userWrap = document.getElementById('adminUserDropdown');
        const userToggle = document.getElementById('adminUserToggle');
        const userMenu = document.getElementById('adminUserMenu');

        function closeSearch() {
            if (searchBox) {
                searchBox.classList.remove('show');
            }
        }

        function closeNotification() {
            if (notificationMenu) {
                notificationMenu.classList.remove('show');
            }
            if (notificationToggle) {
                notificationToggle.setAttribute('aria-expanded', 'false');
            }
        }

        function closeUserMenu() {
            if (userMenu) {
                userMenu.classList.remove('show');
            }
            if (userToggle) {
                userToggle.setAttribute('aria-expanded', 'false');
            }
        }

        function closeAll() {
            closeSearch();
            closeNotification();
            closeUserMenu();
        }

        if (searchToggle) {
            searchToggle.addEventListener('click', function (event) {
                event.preventDefault();
                event.stopPropagation();

                const willShow = searchBox && !searchBox.classList.contains('show');

                closeNotification();
                closeUserMenu();

                if (searchBox) {
                    if (willShow) {
                        searchBox.classList.add('show');
                        if (searchInput) {
                            setTimeout(function () {
                                searchInput.focus();
                            }, 0);
                        }
                    } else {
                        searchBox.classList.remove('show');
                    }
                }
            });
        }

        if (notificationToggle) {
            notificationToggle.addEventListener('click', function (event) {
                event.preventDefault();
                event.stopPropagation();

                const willShow = notificationMenu && !notificationMenu.classList.contains('show');

                closeSearch();
                closeUserMenu();

                if (notificationMenu) {
                    if (willShow) {
                        notificationMenu.classList.add('show');
                        notificationToggle.setAttribute('aria-expanded', 'true');
                    } else {
                        notificationMenu.classList.remove('show');
                        notificationToggle.setAttribute('aria-expanded', 'false');
                    }
                }
            });
        }

        if (userToggle) {
            userToggle.addEventListener('click', function (event) {
                event.preventDefault();
                event.stopPropagation();

                const willShow = userMenu && !userMenu.classList.contains('show');

                closeSearch();
                closeNotification();

                if (userMenu) {
                    if (willShow) {
                        userMenu.classList.add('show');
                        userToggle.setAttribute('aria-expanded', 'true');
                    } else {
                        userMenu.classList.remove('show');
                        userToggle.setAttribute('aria-expanded', 'false');
                    }
                }
            });
        }

        if (searchWrap) {
            searchWrap.addEventListener('click', function (event) {
                event.stopPropagation();
            });
        }

        if (notificationWrap) {
            notificationWrap.addEventListener('click', function (event) {
                event.stopPropagation();
            });
        }

        if (userWrap) {
            userWrap.addEventListener('click', function (event) {
                event.stopPropagation();
            });
        }

        document.addEventListener('click', function () {
            closeAll();
        });

        document.addEventListener('keydown', function (event) {
            if (event.key === 'Escape') {
                closeAll();
            }
        });
    })();

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