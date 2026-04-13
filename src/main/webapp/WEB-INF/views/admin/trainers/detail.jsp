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
    <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>

        <main class="app-content">
            <div class="page-header">
                <div>
                    <h1>Chi tiết huấn luyện viên</h1>
                </div>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="profile-page-grid">
                <div class="profile-left-card">
                    <img class="profile-avatar-large"
                         src="${pageContext.request.contextPath}/uploads/${empty trainer.photo ? 'default-avatar.png' : trainer.photo}"
                         alt="${trainer.staff != null ? trainer.staff.fullName : 'Huấn luyện viên'}">

                    <div>
                        <h3>${trainer.staff != null ? trainer.staff.fullName : 'Chưa cập nhật'}</h3>
                        <div class="profile-role-text">Huấn luyện viên</div>
                    </div>

                    <div class="profile-meta">
                        <span class="status-badge ${trainer.status == 1 ? 'active' : 'inactive'}">
                            ${trainer.status == 1 ? 'Hoạt động' : 'Ngừng hoạt động'}
                        </span>
                    </div>

                    <div class="profile-quick-info">
                        <div class="profile-quick-item">
                            <i class="fa-solid fa-phone"></i>
                            <span>${trainer.staff != null && not empty trainer.staff.phone ? trainer.staff.phone : 'Chưa cập nhật'}</span>
                        </div>

                        <div class="profile-quick-item">
                            <i class="fa-solid fa-envelope"></i>
                            <span>${trainer.staff != null && not empty trainer.staff.email ? trainer.staff.email : 'Chưa cập nhật'}</span>
                        </div>

                        <div class="profile-quick-item">
                            <i class="fa-solid fa-briefcase"></i>
                            <span>${trainer.staff != null && not empty trainer.staff.position ? trainer.staff.position : 'Trainer'}</span>
                        </div>
                    </div>

                    <c:if test="${not empty trainer.specialty}">
                        <div class="profile-specialty-box">
                            <strong>Chuyên môn</strong>
                            <span>${trainer.specialty}</span>
                        </div>
                    </c:if>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/trainers" class="btn-light">
                            <i class="fa-solid fa-arrow-left"></i>
                            <span>Quay lại</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/trainers/edit/${trainer.trainerId}" class="btn-primary">
                            <i class="fa-solid fa-pen"></i>
                            <span>Chỉnh sửa</span>
                        </a>
                    </div>
                </div>

                <div class="profile-right-card">
                    <div class="profile-section-title">
                        <h3>Thông tin chi tiết</h3>
                    </div>

                    <div class="profile-detail-grid">
                        <div class="profile-detail-item">
                            <label>Họ tên</label>
                            <p>${trainer.staff != null && not empty trainer.staff.fullName ? trainer.staff.fullName : 'Chưa cập nhật'}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Số điện thoại</label>
                            <p>${trainer.staff != null && not empty trainer.staff.phone ? trainer.staff.phone : 'Chưa cập nhật'}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Email</label>
                            <p>${trainer.staff != null && not empty trainer.staff.email ? trainer.staff.email : 'Chưa cập nhật'}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Giới tính</label>
                            <p>${trainer.staff != null && not empty trainer.staff.gender ? trainer.staff.gender : 'Chưa cập nhật'}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Ngày sinh</label>
                            <p>${trainer.staff != null && not empty trainer.staff.dob ? trainer.staff.dob : 'Chưa cập nhật'}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Ngày vào làm</label>
                            <p>${trainer.staff != null && not empty trainer.staff.hireDate ? trainer.staff.hireDate : 'Chưa cập nhật'}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Chức vụ</label>
                            <p>${trainer.staff != null && not empty trainer.staff.position ? trainer.staff.position : 'Trainer'}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Trạng thái</label>
                            <p>${trainer.status == 1 ? 'Hoạt động' : 'Ngừng hoạt động'}</p>
                        </div>

                        <div class="profile-detail-item full-row">
                            <label>Chuyên môn</label>
                            <p>${empty trainer.specialty ? 'Chưa cập nhật' : trainer.specialty}</p>
                        </div>

                        <div class="profile-detail-item full-row">
                            <label>Kinh nghiệm</label>
                            <p>${empty trainer.experience ? 'Chưa cập nhật' : trainer.experience}</p>
                        </div>

                        <div class="profile-detail-item full-row">
                            <label>Chứng chỉ</label>
                            <p>${empty trainer.certifications ? 'Chưa cập nhật' : trainer.certifications}</p>
                        </div>

                        <div class="profile-detail-item full-row">
                            <label>Địa chỉ</label>
                            <p>${trainer.staff != null && not empty trainer.staff.address ? trainer.staff.address : 'Chưa cập nhật'}</p>
                        </div>

                        <div class="profile-detail-item full-row">
                            <label>Ghi chú</label>
                            <p>${trainer.staff != null && not empty trainer.staff.note ? trainer.staff.note : 'Chưa cập nhật'}</p>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>