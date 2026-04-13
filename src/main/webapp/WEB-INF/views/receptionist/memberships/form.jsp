<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

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
            <div class="page-header">
                <div>
                    <h1>${isEdit ? 'Cập nhật đăng ký gói tập' : 'Thêm đăng ký gói tập'}</h1>
                </div>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card form-card">
                <form:form method="post" modelAttribute="membership" class="admin-form">
                    <div class="form-grid">

                        <div class="form-group full-width">
                            <label for="memberId">Hội viên</label>
                            <select id="memberId" name="memberId" required>
                                <option value="">-- Chọn hội viên --</option>
                                <c:forEach var="m" items="${members}">
                                    <option value="${m.memberId}"
                                        <c:if test="${membership.member != null && membership.member.memberId == m.memberId}">selected</c:if>>
                                            ${m.fullname} - ${m.phone}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group full-width">
                            <label for="packageId">Gói tập</label>
                            <select id="packageId" name="packageId" required>
                                <option value="">-- Chọn gói tập --</option>
                                <c:forEach var="p" items="${packages}">
                                    <option value="${p.packageId}"
                                        <c:if test="${membership.gymPackage != null && membership.gymPackage.packageId == p.packageId}">selected</c:if>>
                                            ${p.packageName}
                                        <c:if test="${p.durationMonths != null}"> - ${p.durationMonths} tháng</c:if>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="startDate">Ngày bắt đầu</label>
                            <form:input path="startDate" id="startDate" type="date"/>
                            <p class="field-hint">Để trống nếu muốn hệ thống lấy ngày hiện tại.</p>
                        </div>

                        <div class="form-group">
                            <label for="endDate">Ngày kết thúc</label>
                            <form:input path="endDate" id="endDate" type="date"/>
                            <p class="field-hint">Để trống nếu muốn hệ thống tự cộng theo thời hạn gói tập.</p>
                        </div>

                        <div class="form-group full-width">
                            <label for="status">Trạng thái</label>
                            <form:select path="status" id="status">
                                <form:option value="PENDING">Chờ xử lý</form:option>
                                <form:option value="CANCELLED">Đã hủy</form:option>
                            </form:select>
                            <p class="field-hint">Sau khi thanh toán được duyệt, cần duyệt đăng ký ở danh sách để kích hoạt gói.</p>
                        </div>

                        <div class="form-group full-width">
                            <label for="note">Ghi chú</label>
                            <form:textarea path="note" id="note" rows="4"/>
                        </div>

                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/receptionist/memberships" class="btn-light">
                            <i class="fa-solid fa-arrow-left"></i>
                            <span>Quay lại</span>
                        </a>

                        <button type="submit" class="btn-primary">
                            <i class="fa-solid fa-floppy-disk"></i>
                            <span>${isEdit ? 'Cập nhật' : 'Thêm mới'}</span>
                        </button>
                    </div>
                </form:form>
            </div>
        </main>
    </div>
</div>
</body>
</html>