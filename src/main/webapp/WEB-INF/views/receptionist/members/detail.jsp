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
    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

        <main class="app-content">

            <!-- HEADER -->
            <div class="page-header">
                <div>
                    <h1>Chi tiết hội viên</h1>
                </div>

                <div class="table-actions">
                    <a href="${pageContext.request.contextPath}/receptionist/members" class="btn-light">
                        <i class="fa-solid fa-arrow-left"></i>
                    </a>

                    <a href="${pageContext.request.contextPath}/receptionist/members/edit/${member.memberId}" class="btn-primary">
                        <i class="fa-solid fa-pen"></i>
                    </a>
                </div>
            </div>

            <div class="profile-page-grid">

                <!-- LEFT -->
                <div class="profile-left-card">

                    <img class="profile-avatar-large js-image-preview"
                         src="${pageContext.request.contextPath}/${empty member.avatar ? 'assets/images/default-avatar.png' : (member.avatar.startsWith('assets/') ? member.avatar : 'uploads/'.concat(member.avatar))}"
                         data-preview-label="${member.fullname}"
                         alt="${member.fullname}">

                    <div>
                        <h3>${empty member.fullname ? 'Hội viên' : member.fullname}</h3>
                        <div class="profile-role-text">Hội viên</div>
                    </div>

                    <div class="profile-meta">
                        <span class="status-badge ${member.status == 1 ? 'active' : 'inactive'}">
                            ${member.status == 1 ? 'Hoạt động' : 'Ngừng'}
                        </span>
                    </div>

                    <!-- QUICK INFO -->
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

                <!-- RIGHT -->
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
                            <label>Tài khoản</label>
                            <p>${member.user != null ? member.user.username : 'Chưa liên kết'}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>SĐT</label>
                            <p>${empty member.phone ? '---' : member.phone}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Email</label>
                            <p>${empty member.email ? '---' : member.email}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Địa chỉ</label>
                            <p>${empty member.address ? '---' : member.address}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Giới tính</label>
                            <p>${empty member.gender ? '---' : member.gender}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Ngày sinh</label>
                            <p>${empty member.dob ? '---' : member.dob}</p>
                        </div>

                        <!-- PACKAGE -->
                        <div class="profile-detail-item">
                            <label>Gói</label>
                            <p>${empty member.currentPackageName ? 'Chưa có' : member.currentPackageName}</p>
                        </div>

                        <div class="profile-detail-item">
                            <label>Trạng thái gói</label>
                            <p>${empty member.currentMembershipStatus ? '---' : member.currentMembershipStatus}</p>
                        </div>

                        <div class="profile-detail-item full-row">
                            <label>Hết hạn</label>
                            <p>${empty member.currentMembershipEndDate ? '---' : member.currentMembershipEndDate}</p>
                        </div>

                        <!-- SERVICES -->
                        <div class="profile-detail-item full-row">
                            <label>Dịch vụ</label>

                            <c:choose>
                                <c:when test="${not empty currentClassRegistrations}">
                                    <div class="profile-list-block">
                                        <c:forEach var="registration" items="${currentClassRegistrations}">
                                            <div class="profile-list-item">
                                                <strong>
                                                    ${registration.service != null ? registration.service.serviceName : '---'}
                                                </strong>
                                                <span>
                                                    ${registration.status == 'ACTIVE' ? 'Đang học' : 'Chờ'}
                                                </span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <p>Chưa đăng ký</p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- CLASSES -->
                        <div class="profile-detail-item full-row">
                            <label>Lớp học</label>

                            <c:choose>
                                <c:when test="${not empty currentClassRegistrations}">
                                    <div class="profile-list-block">
                                        <c:forEach var="registration" items="${currentClassRegistrations}">
                                            <div class="profile-list-item">
                                                <strong>
                                                    ${registration.gymClass != null ? registration.gymClass.className : '---'}
                                                </strong>
                                                <span>
                                                    ${registration.startDate} - ${registration.endDate}
                                                </span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <p>Chưa tham gia</p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                    </div>

                    <!-- ACTION -->
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/receptionist/members" class="btn-light">
                            <i class="fa-solid fa-arrow-left"></i>
                        </a>

                        <a href="${pageContext.request.contextPath}/receptionist/members/edit/${member.memberId}" class="btn-primary">
                            <i class="fa-solid fa-pen"></i>
                        </a>
                    </div>

                </div>
            </div>

        </main>
    </div>
</div>
</body>
</html>