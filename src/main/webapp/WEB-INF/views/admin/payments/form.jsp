<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body>

<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/layout/sidebar.jsp" %>

<div class="main-content">
    <div class="form-box payment-form-box">
        <div class="form-title">${pageTitle}</div>

        <form action="${pageContext.request.contextPath}/admin/payments/save" method="post">
            <input type="hidden" name="paymentId" value="${payment.paymentId}"/>

            <div class="form-grid">
                <div class="form-group">
                    <label>Hội viên</label>
                    <input type="text"
                           name="memberName"
                           value="${payment.memberName}"
                           placeholder="Nhập tên hội viên"
                           required>
                </div>

                <div class="form-group">
                    <label>Gói tập</label>
                    <input type="text"
                           name="packageName"
                           value="${payment.packageName}"
                           placeholder="Nhập tên gói tập"
                           required>
                </div>

                <div class="form-group">
                    <label>Số tiền</label>
                    <input type="number"
                           step="0.01"
                           min="0"
                           name="amount"
                           value="${payment.amount}"
                           placeholder="Nhập số tiền"
                           required>
                </div>

                <div class="form-group">
                    <label>Phương thức thanh toán</label>
                    <select name="paymentMethod">
                        <option value="">Chọn phương thức</option>
                        <option value="Tiền mặt" <c:if test="${payment.paymentMethod == 'Tiền mặt'}">selected</c:if>>Tiền mặt</option>
                        <option value="Chuyển khoản" <c:if test="${payment.paymentMethod == 'Chuyển khoản'}">selected</c:if>>Chuyển khoản</option>
                        <option value="Ví điện tử" <c:if test="${payment.paymentMethod == 'Ví điện tử'}">selected</c:if>>Ví điện tử</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Ngày thanh toán</label>
                    <input type="date"
                           name="paymentDate"
                           value="${payment.paymentDate}"
                           required>
                </div>

                <div class="form-group">
                    <label>Trạng thái</label>

                    <c:choose>
                        <c:when test="${empty payment.paymentId}">
                            <input type="text" value="Chờ duyệt" readonly>
                            <input type="hidden" name="status" value="Chờ duyệt">
                        </c:when>

                        <c:otherwise>
                            <input type="text" value="${payment.status}" readonly>
                            <input type="hidden" name="status" value="${payment.status}">
                        </c:otherwise>
                    </c:choose>

                    <div class="text-muted">
                        Trạng thái được cập nhật tại màn hình danh sách thanh toán bằng nút Duyệt / Từ chối.
                    </div>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-save">
                    <i class="fa-regular fa-floppy-disk"></i> Lưu
                </button>
                <a class="btn-back" href="${pageContext.request.contextPath}/admin/payments">
                    Quay lại
                </a>
            </div>
        </form>
    </div>

    <%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
</div>

</body>
</html>