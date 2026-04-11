<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ttt.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/trainer-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/trainer-sidebar.jsp" %>

        <main class="app-content">

            <div class="page-header">
                <div>
                    <h1>Chi tiết học viên</h1>
                </div>

                <a href="${pageContext.request.contextPath}/trainer/class-members?classId=${classIdOfStudent}"
                   class="btn-light">
                    <i class="fa-solid fa-arrow-left"></i>
                </a>
            </div>

            <div class="profile-page-grid">

                <div class="profile-left-card">
                    <img class="profile-avatar-large js-image-preview"
                         src="${pageContext.request.contextPath}/uploads/${empty member.avatar ? 'default-avatar.png' : member.avatar}"
                         data-preview-label="${member.fullname}"
                         alt="${member.fullname}">

                    <div>
                        <h3>${empty member.fullname ? 'Học viên' : member.fullname}</h3>
                        <div class="profile-role-text">Học viên lớp phụ trách</div>
                    </div>

                    <div class="profile-meta">
                        <span class="status-badge ${member.status == 1 ? 'active' : 'inactive'}">
                            ${member.status == 1 ? 'Hoạt động' : 'Ngừng'}
                        </span>
                    </div>

                    <div class="profile-quick-info">
                        <div class="profile-quick-item">
                            <i class="fa-solid fa-phone"></i>
                            <span>${empty member.phone ? 'Chưa có SĐT' : member.phone}</span>
                        </div>

                        <div class="profile-quick-item">
                            <i class="fa-solid fa-envelope"></i>
                            <span>${empty member.email ? 'Chưa có email' : member.email}</span>
                        </div>

                        <div class="profile-quick-item">
                            <i class="fa-solid fa-location-dot"></i>
                            <span>${empty member.address ? 'Chưa cập nhật' : member.address}</span>
                        </div>
                    </div>
                </div>

                <div class="profile-right-card">
                    <div class="profile-section-title">
                        <h3>Thông tin chi tiết</h3>
                    </div>

                    <div class="profile-detail-grid">
                        <div class="profile-detail-item">
                            <label>Họ tên</label>
                            <p>${empty member.fullname ? '---' : member.fullname}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Giới tính</label>
                            <p>${empty member.gender ? '---' : member.gender}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>SĐT</label>
                            <p>${empty member.phone ? '---' : member.phone}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Email</label>
                            <p>${empty member.email ? '---' : member.email}</p>
                        </div>

                        <div class="profile-detail-item full-row">
                            <label>Địa chỉ</label>
                            <p>${empty member.address ? 'Chưa cập nhật' : member.address}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Ngày sinh</label>
                            <p>${empty member.dob ? '---' : member.dob}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Trạng thái</label>
                            <p>${member.status == 1 ? 'Hoạt động' : 'Ngừng'}</p>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/trainer/class-members?classId=${classIdOfStudent}"
                           class="btn-light">
                            <i class="fa-solid fa-arrow-left"></i>
                        </a>
                    </div>
                </div>

            </div>
        </main>
    </div>
</div>
</body>
</html>