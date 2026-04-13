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
                    <h1>${isEdit ? 'Cập nhật thanh toán' : 'Thêm thanh toán'}</h1>
                </div>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card form-card">
                <form:form method="post"
                           modelAttribute="payment"
                           enctype="multipart/form-data"
                           class="admin-form">

                    <div class="form-grid">

                        <div class="form-group full-width">
                            <label for="membershipId">Đăng ký gói tập</label>
                            <select id="membershipId" name="membershipId">
                                <option value="">-- Không chọn --</option>
                                <c:forEach var="m" items="${memberships}">
                                    <option value="${m.membershipId}">
                                            ${m.member.fullname} - ${m.gymPackage.packageName} - ${m.status}
                                    </option>
                                </c:forEach>
                            </select>
                            <p class="field-hint">Chỉ chọn một trong hai: gói tập hoặc lớp học.</p>
                        </div>

                        <div class="form-group full-width">
                            <label for="classRegistrationId">Đăng ký lớp học</label>
                            <select id="classRegistrationId" name="classRegistrationId">
                                <option value="">-- Không chọn --</option>
                                <c:forEach var="r" items="${classRegistrations}">
                                    <option value="${r.registrationId}">
                                            ${r.member.fullname} - ${r.gymClass.className} - ${r.status}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="amount">Số tiền</label>
                            <form:input path="amount" id="amount" type="number" step="0.01"/>
                            <form:errors path="amount" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label for="paymentMethod">Phương thức</label>
                            <form:select path="paymentMethod" id="paymentMethod">
                                <form:option value="CASH">Tiền mặt</form:option>
                                <form:option value="BANK_TRANSFER">Chuyển khoản</form:option>
                            </form:select>
                        </div>

                        <div class="form-group">
                            <label for="paymentDate">Ngày thanh toán</label>
                            <form:input path="paymentDate" id="paymentDate" type="date"/>
                            <form:errors path="paymentDate" cssClass="error-text"/>
                        </div>

                        <div class="form-group">
                            <label for="status">Trạng thái</label>
                            <form:select path="status" id="status">
                                <form:option value="PENDING">Chờ duyệt</form:option>
                                <form:option value="CANCELLED">Đã hủy</form:option>
                            </form:select>
                        </div>

                        <div class="form-group full-width">
                            <label for="proofFile">Minh chứng thanh toán</label>
                            <input id="proofFile" type="file" name="proofFile" accept="image/*">
                        </div>

                        <div class="form-group full-width">
                            <label for="note">Ghi chú</label>
                            <form:textarea path="note" id="note" rows="4"/>
                        </div>

                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/receptionist/payments" class="btn-light">
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