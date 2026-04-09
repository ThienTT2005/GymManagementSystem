<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>
    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

        <main class="app-content">
            <div class="page-card form-card">
                <h2>Thêm thanh toán</h2>

                <form:form method="post" modelAttribute="payment" enctype="multipart/form-data" class="admin-form">
                    <div class="form-grid">
                        <div class="form-group full-width">
                            <label>Membership</label>
                            <select name="membershipId">
                                <option value="">-- Chọn membership --</option>
                                <c:forEach var="m" items="${memberships}">
                                    <option value="${m.membershipId}">${m.member.fullname} - ${m.gymPackage.packageName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group full-width">
                            <label>Class Registration</label>
                            <select name="classRegistrationId">
                                <option value="">-- Chọn class registration --</option>
                                <c:forEach var="r" items="${classRegistrations}">
                                    <option value="${r.registrationId}">${r.member.fullname} - ${r.gymClass.className}</option>
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
                            </form:select>
                        </div>

                        <div class="form-group full-width">
                            <label>Minh chứng</label>
                            <input type="file" name="proofFile" accept="image/*">
                        </div>

                        <div class="form-group full-width">
                            <label>Ghi chú</label>
                            <form:textarea path="note" rows="4"/>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/receptionist/payments" class="btn-secondary">Quay lại</a>
                        <button type="submit" class="btn-primary">Thêm mới</button>
                    </div>
                </form:form>
            </div>
        </main>
    </div>
</div>
</body>
</html>