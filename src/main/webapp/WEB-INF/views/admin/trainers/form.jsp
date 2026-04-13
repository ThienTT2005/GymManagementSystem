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
    <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>

        <main class="app-content">

            <!-- HEADER -->
            <div class="page-header">
                <div>
                    <h1>${isEdit ? 'Cập nhật huấn luyện viên' : 'Thêm huấn luyện viên'}</h1>
                </div>
            </div>

            <!-- ERROR -->
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <div class="page-card form-card">
                <form:form method="post"
                           modelAttribute="trainer"
                           enctype="multipart/form-data"
                           class="admin-form">

                    <div class="form-grid">

                        <!-- STAFF -->
                        <div class="form-group full-width">
                            <label>Nhân viên</label>
                            <select name="staffId">
                                <option value="">-- Chọn --</option>

                                <c:forEach var="s" items="${staffs}">
                                    <option value="${s.staffId}"
                                            <c:if test="${trainer.staff != null && trainer.staff.staffId == s.staffId}">selected</c:if>>
                                        ${s.fullName} - ${empty s.position ? 'Nhân viên' : s.position}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- SPECIALTY -->
                        <div class="form-group full-width">
                            <label>Chuyên môn</label>
                            <form:input path="specialty" placeholder="Yoga / Gym / Cardio..."/>
                            <form:errors path="specialty" cssClass="error-text"/>
                        </div>

                        <!-- STATUS -->
                        <div class="form-group">
                            <label>Trạng thái</label>
                            <form:select path="status">
                                <form:option value="1">Hoạt động</form:option>
                                <form:option value="0">Ngừng</form:option>
                            </form:select>
                            <form:errors path="status" cssClass="error-text"/>
                        </div>

                        <!-- PHOTO -->
                        <div class="form-group">
                            <label>Ảnh</label>
                            <input type="file" name="photoFile" accept="image/*">
                            <small class="text-muted">Upload nếu cần</small>
                        </div>

                        <!-- EXPERIENCE -->
                        <div class="form-group full-width">
                            <label>Kinh nghiệm</label>
                            <form:textarea path="experience"
                                           rows="3"
                                           placeholder="Mô tả kinh nghiệm..."/>
                            <form:errors path="experience" cssClass="error-text"/>
                        </div>

                        <!-- CERTIFICATIONS -->
                        <div class="form-group full-width">
                            <label>Chứng chỉ</label>
                            <form:textarea path="certifications"
                                           rows="3"
                                           placeholder="Chứng chỉ chuyên môn..."/>
                            <form:errors path="certifications" cssClass="error-text"/>
                        </div>

                        <!-- PREVIEW -->
                        <c:if test="${isEdit and not empty trainer.photo}">
                            <div class="form-group full-width">
                                <label>Ảnh hiện tại</label>
                                <img class="preview-image"
                                     src="${pageContext.request.contextPath}/uploads/${trainer.photo}"
                                     alt="${trainer.staffName}">
                            </div>
                        </c:if>

                    </div>

                    <!-- ACTION -->
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/trainers"
                           class="btn-light">
                            <i class="fa-solid fa-arrow-left"></i>
                        </a>

                        <button type="submit" class="btn-primary">
                            <i class="fa-solid fa-floppy-disk"></i>
                        </button>
                    </div>

                </form:form>
            </div>

        </main>
    </div>
</div>
</body>
</html>