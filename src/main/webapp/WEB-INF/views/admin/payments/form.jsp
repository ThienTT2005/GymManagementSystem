<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>
    <div class="app-body">
        <%@ include file="/WEB-INF/views/admin/layout/sidebar.jsp" %>

        <main class="app-content">
            <div class="page-header">
                <div>
                    <h1>${isEdit ? 'Cập nhật thanh toán' : 'Thêm thanh toán'}</h1>
                    <p>Thanh toán cho membership hoặc đăng ký lớp</p>
                </div>
            </div>

            <div class="page-card form-card">
                <form:form method="post" modelAttribute="payment" enctype="multipart/form-data" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group full-width">
                            <label>Membership</label>
                            <select name="membershipId">
                                <option value="">-- Chọn membership --</option>
                                <c:forEach var="m" items="${memberships}">
                                    <option value="${m.membershipId}"
                                        <c:if test="${payment.membership != null && payment.membership.membershipId == m.membershipId}">selected</c:if>>
                                            ${m.member.fullname} - ${m.gymPackage.packageName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group full-width">
                            <label>Class Registration</label>
                            <select name="classRegistrationId">
                                <option value="">-- Chọn class registration --</option>
                                <c:forEach var="r" items="${classRegistrations}">
                                    <option value="${r.registrationId}"
                                        <c:if test="${payment.classRegistration != null && payment.classRegistration.registrationId == r.registrationId}">selected</c:if>>
                                            ${r.member.fullname} - ${r.gymClass.className}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Số tiền</label>
                            <form:input path="amount" type="number" step="0.01"/>
                        </div>

                        <div class="form-group">
                            <label>Phương thức</label>
                            <form:input path="paymentMethod"/>
                        </div>

                        <div class="form-group">
                            <label>Ngày thanh toán</label>
                            <form:input path="paymentDate" type="date"/>
                        </div>

                        <div class="form-group">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="PENDING">PENDING</form:option>
                                <form:option value="PAID">PAID</form:option>
                                <form:option value="REJECTED">REJECTED</form:option>
                                <form:option value="CANCELLED">CANCELLED</form:option>
                            </form:select>
                        </div>

                        <div class="form-group full-width">
                            <label>Minh chứng</label>
                            <input type="file" name="proofFile" accept="image/*">
                        </div>

                        <c:if test="${isEdit and not empty payment.proofImage}">
                            <div class="form-group full-width">
                                <label>Ảnh hiện tại</label>
                                <img class="preview-image"
                                     src="${pageContext.request.contextPath}/uploads/${payment.proofImage}"
                                     alt="proof">
                            </div>
                        </c:if>

                        <div class="form-group full-width">
                            <label>Ghi chú</label>
                            <form:textarea path="note" rows="4"/>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/payments" class="btn-secondary">Quay lại</a>
                        <button type="submit" class="btn-primary">
                            <c:choose>
                                <c:when test="${isEdit}">Cập nhật</c:when>
                                <c:otherwise>Thêm mới</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form:form>
            </div>
        </main>
    </div>
</div>
</body>
</html>