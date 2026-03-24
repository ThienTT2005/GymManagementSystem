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
    <div class="form-box member-form-box">
        <div class="form-title">${pageTitle}</div>

        <form action="${pageContext.request.contextPath}/admin/members/save" method="post">
            <input type="hidden" name="membershipId" value="${membership.membershipId}"/>

            <div class="form-grid">
                <div class="form-group">
                    <label>Tên hội viên</label>
                    <input type="text"
                           name="memberName"
                           value="${membership.memberName}"
                           placeholder="Nhập tên hội viên"
                           required>
                </div>

                <div class="form-group">
                    <label>Gói tập</label>
                    <input type="text"
                           name="packageName"
                           value="${membership.packageName}"
                           placeholder="Nhập tên gói tập"
                           required>
                </div>

                <div class="form-group">
                    <label>Ngày bắt đầu</label>
                    <input type="date"
                           name="startDate"
                           value="${membership.startDate}"
                           required>
                </div>

                <div class="form-group">
                    <label>Ngày kết thúc</label>
                    <input type="date"
                           name="endDate"
                           value="${membership.endDate}"
                           required>
                </div>

                <div class="form-group">
                    <label>Trạng thái</label>
                    <select name="status">
                        <option value="Đang hoạt động"
                                <c:if test="${membership.status == 'Đang hoạt động'}">selected</c:if>>
                            Đang hoạt động
                        </option>
                        <option value="Tạm dừng"
                                <c:if test="${membership.status == 'Tạm dừng'}">selected</c:if>>
                            Tạm dừng
                        </option>
                        <option value="Hết hạn"
                                <c:if test="${membership.status == 'Hết hạn'}">selected</c:if>>
                            Hết hạn
                        </option>
                    </select>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-save">
                    <i class="fa-regular fa-floppy-disk"></i> Lưu
                </button>
                <a class="btn-back" href="${pageContext.request.contextPath}/admin/members">
                    Quay lại
                </a>
            </div>
        </form>
    </div>

    <%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const startDateInput = document.querySelector('input[name="startDate"]');
        const endDateInput = document.querySelector('input[name="endDate"]');

        if (startDateInput && endDateInput) {
            endDateInput.addEventListener("change", function () {
                if (startDateInput.value && endDateInput.value && endDateInput.value < startDateInput.value) {
                    alert("Ngày kết thúc không được nhỏ hơn ngày bắt đầu.");
                    endDateInput.value = "";
                }
            });
        }
    });
</script>

</body>
</html>