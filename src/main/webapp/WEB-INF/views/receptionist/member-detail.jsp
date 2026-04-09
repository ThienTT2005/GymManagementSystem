<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết hội viên</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>
    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

        <div class="app-content">
            <div class="page-topbar">
                <h2 class="page-title">Chi tiết hội viên</h2>
                <div class="page-actions">
                    <c:if test="${not empty member}">
                        <a href="${pageContext.request.contextPath}/receptionist/edit-member?id=${member.memberId}" class="add-btn">
                            <i class="fa-regular fa-pen-to-square"></i><span>Sửa hội viên</span>
                        </a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/receptionist/members" class="secondary-btn">Quay lại</a>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty member}">
                    <div class="detail-card">
                        <div class="detail-grid">
                            <div class="detail-item">
                                <label>ID hội viên</label>
                                <div class="detail-value">${member.memberId}</div>
                            </div>

                            <div class="detail-item">
                                <label>Họ tên</label>
                                <div class="detail-value">${member.fullname}</div>
                            </div>

                            <div class="detail-item">
                                <label>Số điện thoại</label>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty member.phone}">${member.phone}</c:when>
                                        <c:otherwise>--</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="detail-item">
                                <label>Email</label>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty member.email}">${member.email}</c:when>
                                        <c:otherwise>--</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="detail-item">
                                <label>Giới tính</label>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty member.gender}">${member.gender}</c:when>
                                        <c:otherwise>--</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="detail-item">
                                <label>Ngày sinh</label>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty member.dob}">${member.dob}</c:when>
                                        <c:otherwise>--</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="detail-item">
                                <label>Gói tập hiện tại</label>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty latestPackage and latestPackage ne '--'}">
                                            <span class="package-badge premium">${latestPackage}</span>
                                        </c:when>
                                        <c:otherwise>--</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="detail-item">
                                <label>Dịch vụ đã duyệt</label>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty approvedServicesText and approvedServicesText ne '--'}">
                                            ${approvedServicesText}
                                        </c:when>
                                        <c:otherwise>--</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="detail-item full-width">
                                <label>Địa chỉ</label>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty member.address}">${member.address}</c:when>
                                        <c:otherwise>--</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert error-alert">Không tìm thấy dữ liệu hội viên.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

</body>
</html>