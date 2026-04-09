<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thanh toán</title>
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
                <h2 class="page-title">Thanh toán</h2>
            </div>

            <c:if test="${not empty success}">
                <div class="alert success-alert">${success}</div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert error-alert">${error}</div>
            </c:if>

            <div class="list-card payment-card">

                <div class="list-toolbar">
                    <form method="get" action="${pageContext.request.contextPath}/receptionist/payment" class="search-form multi-search-form">
                        <div class="search-box">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo hội viên, gói tập, dịch vụ">
                        </div>

                        <select name="typeFilter" class="filter-select">
                            <option value="">Tất cả loại</option>
                            <option value="MEMBERSHIP" ${typeFilter eq 'MEMBERSHIP' ? 'selected' : ''}>Gói tập</option>
                            <option value="SERVICE" ${typeFilter eq 'SERVICE' ? 'selected' : ''}>Dịch vụ</option>
                        </select>

                        <select name="statusFilter" class="filter-select">
                            <option value="">Tất cả trạng thái</option>
                            <option value="PENDING" ${statusFilter eq 'PENDING' ? 'selected' : ''}>Pending</option>
                            <option value="PAID" ${statusFilter eq 'PAID' ? 'selected' : ''}>Paid</option>
                            <option value="REJECTED" ${statusFilter eq 'REJECTED' ? 'selected' : ''}>Rejected</option>
                        </select>

                        <button type="submit" class="filter-btn">Lọc</button>
                    </form>
                </div>

                <div class="table-wrap">
                    <table class="member-table payment-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Hội viên</th>
                            <th>Loại</th>
                            <th>Gói/Dịch vụ</th>
                            <th>Số tiền</th>
                            <th>Minh chứng</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:choose>
                            <c:when test="${not empty payments}">
                                <c:forEach var="p" items="${payments}">
                                    <tr>
                                        <td>${p.paymentId}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${p.membership != null}">
                                                    ${p.membership.member.fullname}
                                                </c:when>
                                                <c:when test="${p.classRegistration != null}">
                                                    ${p.classRegistration.member.fullname}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${p.membership != null}">
                                                    <span class="package-badge premium">Gói tập</span>
                                                </c:when>
                                                <c:when test="${p.classRegistration != null}">
                                                    <span class="status-badge pending">Dịch vụ</span>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${p.membership != null}">
                                                    ${p.membership.gymPackage.packageName}
                                                </c:when>
                                                <c:when test="${p.classRegistration != null}">
                                                    ${p.classRegistration.service.serviceName}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="money-cell">${p.amount} VNĐ</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty p.proofImage}">
                                                    <img src="${pageContext.request.contextPath}/uploads/payments/${p.proofImage}"
                                                         class="proof-thumb clickable-proof"
                                                         onclick="openProofModal('${pageContext.request.contextPath}/uploads/payments/${p.proofImage}')">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="proof-thumb proof-empty">No image</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${p.status eq 'PENDING'}">
                                                    <span class="status-badge pending">Pending</span>
                                                </c:when>
                                                <c:when test="${p.status eq 'PAID'}">
                                                    <span class="status-badge success">Paid</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge danger">Rejected</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:if test="${p.status eq 'PENDING'}">
                                                <div class="payment-actions">
                                                    <form method="post"
                                                          action="${pageContext.request.contextPath}/receptionist/payment/approve">
                                                        <input type="hidden" name="id" value="${p.paymentId}">
                                                        <button type="submit" class="action-btn approve-btn"
                                                                onclick="return confirm('Xác nhận duyệt thanh toán?')">
                                                            <i class="fa-solid fa-check"></i>
                                                        </button>
                                                    </form>

                                                    <form method="post"
                                                          action="${pageContext.request.contextPath}/receptionist/payment/reject">
                                                        <input type="hidden" name="id" value="${p.paymentId}">
                                                        <button type="submit" class="action-btn reject-btn"
                                                                onclick="return confirm('Từ chối thanh toán?')">
                                                            <i class="fa-solid fa-xmark"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="8" class="empty-row">Chưa có dữ liệu thanh toán</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="pagination-box">
                    <c:if test="${page > 1}">
                        <a class="page-btn"
                           href="?keyword=${keyword}&typeFilter=${typeFilter}&statusFilter=${statusFilter}&page=${page - 1}">&laquo;</a>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a class="page-btn ${i == page ? 'active' : ''}"
                           href="?keyword=${keyword}&typeFilter=${typeFilter}&statusFilter=${statusFilter}&page=${i}">
                            ${i}
                        </a>
                    </c:forEach>

                    <c:if test="${page < totalPages}">
                        <a class="page-btn"
                           href="?keyword=${keyword}&typeFilter=${typeFilter}&statusFilter=${statusFilter}&page=${page + 1}">&raquo;</a>
                    </c:if>
                </div>

            </div>
        </div>
    </div>
</div>

<div id="proofModal" class="proof-modal" onclick="closeProofModal()">
    <div class="proof-modal-content" onclick="event.stopPropagation()">
        <span class="proof-modal-close" onclick="closeProofModal()">&times;</span>
        <img id="proofModalImage" src="">
    </div>
</div>

<script>
    function openProofModal(imageSrc) {
        document.getElementById("proofModalImage").src = imageSrc;
        document.getElementById("proofModal").classList.add("show");
    }

    function closeProofModal() {
        document.getElementById("proofModal").classList.remove("show");
    }
</script>

</body>
</html>