<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng ký dịch vụ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receptionist.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="app-shell">

    <%@ include file="/WEB-INF/views/layout/receptionist-header.jsp" %>

    <div class="app-body">
        <%@ include file="/WEB-INF/views/layout/receptionist-sidebar.jsp" %>

        <div class="app-content">
            <div class="page-card">
                <h2 class="page-title">Đăng ký dịch vụ</h2>

                <c:if test="${not empty success}">
                    <div class="alert success-alert">${success}</div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert error-alert">${error}</div>
                </c:if>

                <div class="form-card register-card">
                    <h3 class="form-title">Thông tin hội viên</h3>

                    <form method="post"
                          enctype="multipart/form-data"
                          action="${pageContext.request.contextPath}/receptionist/register-service"
                          class="member-form">

                        <div class="form-grid">

                            <div class="form-group">
                                <label>Hội viên</label>
                                <div class="input-icon">
                                    <i class="fa-regular fa-user"></i>
                                    <select name="memberId" required>
                                        <option value="">Chọn hội viên</option>
                                        <c:forEach var="m" items="${members}">
                                            <option value="${m.memberId}">${m.fullname}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Dịch vụ</label>
                                <div class="input-icon">
                                    <i class="fa-solid fa-layer-group"></i>
                                    <select name="serviceId" required>
                                        <option value="">Chọn dịch vụ</option>
                                        <c:forEach var="s" items="${services}">
                                            <option value="${s.serviceId}">${s.serviceName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Lớp học</label>
                                <div class="input-icon">
                                    <i class="fa-solid fa-calendar-days"></i>
                                    <select name="classId">
                                        <option value="">Không chọn</option>
                                        <c:forEach var="c" items="${classes}">
                                            <option value="${c.classId}">
                                                ${c.className} (${c.currentMember}/${c.maxMember})
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Minh chứng (có thể bỏ trống nếu thanh toán tại quầy)</label>
                                <div class="file-upload-box">
                                    <label class="file-upload-label">
                                        <i class="fa-regular fa-image"></i>
                                        <span>Chọn tệp</span>
                                        <input type="file" name="proofFile">
                                    </label>
                                </div>
                            </div>

                        </div>

                        <div class="form-submit">
                            <button type="submit" class="primary-btn">Đăng ký</button>
                        </div>

                    </form>
                </div>

                <div class="table-card" style="margin-top: 24px;">
                    <h3 class="form-title">Danh sách đăng ký dịch vụ</h3>

                    <div class="table-wrap">
                        <table class="custom-table">
                            <thead>
                            <tr>
                                <th>Mã</th>
                                <th>Hội viên</th>
                                <th>Dịch vụ</th>
                                <th>Lớp học</th>
                                <th>Ngày đăng ký</th>
                                <th>Ngày bắt đầu</th>
                                <th>Ngày kết thúc</th>
                                <th>Trạng thái</th>
                                <th>Ghi chú</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty classRegistrations}">
                                    <c:forEach var="item" items="${classRegistrations}">
                                        <tr>
                                            <td>#${item.registrationId}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.member != null}">
                                                        ${item.member.fullname}
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.service != null}">
                                                        ${item.service.serviceName}
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.gymClass != null}">
                                                        ${item.gymClass.className}
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${item.registrationDate}</td>
                                            <td>${item.startDate}</td>
                                            <td>${item.endDate}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.status eq 'ACTIVE'}">
                                                        <span class="status-badge active">ACTIVE</span>
                                                    </c:when>
                                                    <c:when test="${item.status eq 'REJECTED'}">
                                                        <span class="status-badge cancelled">REJECTED</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge pending">${item.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${item.note}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" style="text-align: center;">Chưa có đăng ký dịch vụ nào.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>
</body>
</html>