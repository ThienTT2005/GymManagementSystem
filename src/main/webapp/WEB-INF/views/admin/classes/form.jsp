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

            <div class="page-header">
                <div>
                    <h1>
                        <c:choose>
                            <c:when test="${viewOnly}">Chi tiết lớp học</c:when>
                            <c:when test="${isEdit}">Cập nhật lớp học</c:when>
                            <c:otherwise>Thêm lớp học</c:otherwise>
                        </c:choose>
                    </h1>
                </div>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <c:choose>
                <c:when test="${viewOnly}">
                    <div class="page-card">
                        <h2>${gymClass.className}</h2>

                        <div class="detail-grid">
                            <div>
                                <strong>Dịch vụ:</strong>
                                ${gymClass.service != null ? gymClass.service.serviceName : '-'}
                            </div>
                            <div>
                                <strong>Huấn luyện viên:</strong>
                                ${gymClass.trainerName}
                            </div>
                            <div>
                                <strong>Số học viên hiện tại:</strong>
                                ${gymClass.currentMember}
                            </div>
                            <div>
                                <strong>Số lượng tối đa:</strong>
                                ${gymClass.maxMember}
                            </div>
                            <div>
                                <strong>Trạng thái:</strong>
                                <span class="status-badge ${gymClass.status == 1 ? 'active' : 'inactive'}">
                                    ${gymClass.status == 1 ? 'Hoạt động' : 'Ngừng hoạt động'}
                                </span>
                            </div>
                        </div>

                        <c:if test="${not empty gymClass.description}">
                            <div class="profile-section-title" style="margin-top:24px;">
                                <h3>Mô tả lớp học</h3>
                            </div>
                            <div class="profile-detail-item full-row">
                                <p>${gymClass.description}</p>
                            </div>
                        </c:if>

                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/admin/classes" class="btn-light">
                                <i class="fa-solid fa-arrow-left"></i>
                                <span>Quay lại</span>
                            </a>

                            <a href="${pageContext.request.contextPath}/admin/classes/edit/${gymClass.classId}" class="btn-primary">
                                <i class="fa-solid fa-pen"></i>
                                <span>Chỉnh sửa</span>
                            </a>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <c:if test="${not empty org.springframework.validation.BindingResult.gymClass}">
                        <div class="alert-error">
                            <form:errors path="*" element="div"/>
                        </div>
                    </c:if>

                    <div class="page-card form-card">

                        <form:form method="post" modelAttribute="gymClass" class="admin-form">

                            <c:if test="${isEdit}">
                                <form:hidden path="classId"/>
                            </c:if>

                            <div class="form-grid">

                                <div class="form-group full-width">
                                    <label for="className">Tên lớp</label>
                                    <form:input path="className" id="className"/>
                                    <form:errors path="className" cssClass="error-text"/>
                                </div>

                                <div class="form-group">
                                    <label for="serviceId">Dịch vụ</label>
                                    <select id="serviceId" name="serviceId">
                                        <option value="">-- Chọn --</option>
                                        <c:forEach var="s" items="${services}">
                                            <option value="${s.serviceId}"
                                                <c:if test="${gymClass.service != null && gymClass.service.serviceId == s.serviceId}">selected</c:if>>
                                                ${s.serviceName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="trainerId">Huấn luyện viên</label>
                                    <select id="trainerId" name="trainerId">
                                        <option value="">-- Chọn --</option>
                                        <c:forEach var="t" items="${trainers}">
                                            <option value="${t.trainerId}"
                                                <c:if test="${gymClass.trainer != null && gymClass.trainer.trainerId == t.trainerId}">selected</c:if>>
                                                ${t.staffName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="maxMember">Số lượng tối đa</label>
                                    <form:input path="maxMember" id="maxMember" type="number" min="1"/>
                                    <form:errors path="maxMember" cssClass="error-text"/>
                                </div>

                                <div class="form-group">
                                    <label for="currentMember">Số lượng hiện tại</label>
                                    <form:input path="currentMember" id="currentMember" type="number" min="0"/>
                                    <form:errors path="currentMember" cssClass="error-text"/>
                                </div>

                                <div class="form-group full-width">
                                    <label for="status">Trạng thái</label>
                                    <form:select path="status" id="status">
                                        <form:option value="1">Hoạt động</form:option>
                                        <form:option value="0">Ngừng hoạt động</form:option>
                                    </form:select>
                                    <form:errors path="status" cssClass="error-text"/>
                                </div>

                                <div class="form-group full-width">
                                    <label for="description">Mô tả</label>
                                    <form:textarea path="description" id="description" rows="4"/>
                                    <form:errors path="description" cssClass="error-text"/>
                                </div>

                            </div>

                            <div class="form-actions">

                                <a href="${pageContext.request.contextPath}/admin/classes" class="btn-light">
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
                </c:otherwise>
            </c:choose>

        </main>

    </div>

</div>
</body>
</html>