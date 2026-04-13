<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
                   <h1>Bảng điều khiển lễ tân</h1>
               </div>
           </div>

           <section class="stats-grid dashboard-stats-grid">

               <a class="stat-card stat-card-link stat-card-variant-1"
                  href="${pageContext.request.contextPath}/receptionist/members">
                   <div class="stat-title">
                       <i class="fa-solid fa-users"></i>
                       <span>Tổng hội viên</span>
                   </div>
                   <div class="stat-value">${totalMembers}</div>
               </a>

               <a class="stat-card stat-card-link stat-card-variant-2"
                  href="${pageContext.request.contextPath}/receptionist/memberships">
                   <div class="stat-title">
                       <i class="fa-solid fa-address-card"></i>
                       <span>Gói chờ xử lý</span>
                   </div>
                   <div class="stat-value">${pendingMemberships}</div>
               </a>

               <a class="stat-card stat-card-link stat-card-variant-3"
                  href="${pageContext.request.contextPath}/receptionist/class-registrations">
                   <div class="stat-title">
                       <i class="fa-solid fa-list-check"></i>
                       <span>Lớp chờ xử lý</span>
                   </div>
                   <div class="stat-value">${pendingClassRegistrations}</div>
               </a>

               <a class="stat-card stat-card-link stat-card-variant-4"
                  href="${pageContext.request.contextPath}/receptionist/trials">
                   <div class="stat-title">
                       <i class="fa-solid fa-stopwatch"></i>
                       <span>Tập thử</span>
                   </div>
                   <div class="stat-value">${pendingTrials}</div>
               </a>

               <a class="stat-card stat-card-link stat-card-variant-5"
                  href="${pageContext.request.contextPath}/receptionist/consultations">
                   <div class="stat-title">
                       <i class="fa-solid fa-comments"></i>
                       <span>Tư vấn</span>
                   </div>
                   <div class="stat-value">${pendingConsultations}</div>
               </a>

           </section>

           <div class="dashboard-grid">

               <div class="dashboard-box">
                   <div class="dashboard-box-header">
                       <h3>Đăng ký gói gần đây</h3>
                       <a class="view-all-link" href="${pageContext.request.contextPath}/receptionist/memberships">Xem tất cả</a>
                   </div>

                   <div class="table-responsive">
                       <table class="dashboard-table">
                           <thead>
                           <tr>
                               <th>Hội viên</th>
                               <th>Gói</th>
                               <th>Trạng thái</th>
                           </tr>
                           </thead>

                           <tbody>
                           <c:choose>
                               <c:when test="${not empty recentMemberships}">
                                   <c:forEach var="item" items="${recentMemberships}">
                                       <tr>
                                           <td>${item.member != null ? item.member.fullname : '-'}</td>
                                           <td>${item.gymPackage != null ? item.gymPackage.packageName : '-'}</td>
                                           <td>
                                               <span class="status-badge
                                                   ${item.status == 'ACTIVE' ? 'active' :
                                                     item.status == 'PENDING' ? 'pending' :
                                                     item.status == 'REJECTED' ? 'inactive' : 'inactive'}">
                                                   ${item.status}
                                               </span>
                                           </td>
                                       </tr>
                                   </c:forEach>
                               </c:when>
                               <c:otherwise>
                                   <tr>
                                       <td colspan="3" class="empty-cell">Không có dữ liệu</td>
                                   </tr>
                               </c:otherwise>
                           </c:choose>
                           </tbody>
                       </table>
                   </div>
               </div>

               <div class="dashboard-box">
                   <div class="dashboard-box-header">
                       <h3>Đăng ký lớp gần đây</h3>
                       <a class="view-all-link" href="${pageContext.request.contextPath}/receptionist/class-registrations">Xem tất cả</a>
                   </div>

                   <div class="table-responsive">
                       <table class="dashboard-table">
                           <thead>
                           <tr>
                               <th>Hội viên</th>
                               <th>Lớp</th>
                               <th>Trạng thái</th>
                           </tr>
                           </thead>

                           <tbody>
                           <c:choose>
                               <c:when test="${not empty recentClassRegistrations}">
                                   <c:forEach var="item" items="${recentClassRegistrations}">
                                       <tr>
                                           <td>${item.member != null ? item.member.fullname : '-'}</td>
                                           <td>${item.gymClass != null ? item.gymClass.className : '-'}</td>
                                           <td>
                                               <span class="status-badge
                                                   ${item.status == 'ACTIVE' ? 'active' :
                                                     item.status == 'PENDING' ? 'pending' :
                                                     item.status == 'REJECTED' ? 'inactive' : 'inactive'}">
                                                   ${item.status}
                                               </span>
                                           </td>
                                       </tr>
                                   </c:forEach>
                               </c:when>
                               <c:otherwise>
                                   <tr>
                                       <td colspan="3" class="empty-cell">Không có dữ liệu</td>
                                   </tr>
                               </c:otherwise>
                           </c:choose>
                           </tbody>
                       </table>
                   </div>
               </div>

               <div class="dashboard-box">
                   <div class="dashboard-box-header">
                       <h3>Tập thử mới</h3>
                       <a class="view-all-link" href="${pageContext.request.contextPath}/receptionist/trials">Xem tất cả</a>
                   </div>

                   <div class="table-responsive">
                       <table class="dashboard-table">
                           <thead>
                           <tr>
                               <th>Họ tên</th>
                               <th>SĐT</th>
                               <th>Ngày</th>
                           </tr>
                           </thead>

                           <tbody>
                           <c:choose>
                               <c:when test="${not empty recentTrials}">
                                   <c:forEach var="item" items="${recentTrials}">
                                       <tr>
                                           <td>${item.fullname}</td>
                                           <td>${item.phone}</td>
                                           <td>
                                               ${item.preferredDate != null ? item.preferredDate.dayOfMonth : ''}/
                                               ${item.preferredDate != null ? item.preferredDate.monthValue : ''}/
                                               ${item.preferredDate != null ? item.preferredDate.year : ''}
                                           </td>
                                       </tr>
                                   </c:forEach>
                               </c:when>
                               <c:otherwise>
                                   <tr>
                                       <td colspan="3" class="empty-cell">Không có dữ liệu</td>
                                   </tr>
                               </c:otherwise>
                           </c:choose>
                           </tbody>
                       </table>
                   </div>
               </div>

               <div class="dashboard-box">
                   <div class="dashboard-box-header">
                       <h3>Tư vấn mới</h3>
                       <a class="view-all-link" href="${pageContext.request.contextPath}/receptionist/consultations">Xem tất cả</a>
                   </div>

                   <div class="table-responsive">
                       <table class="dashboard-table">
                           <thead>
                           <tr>
                               <th>Họ tên</th>
                               <th>SĐT</th>
                               <th>Email</th>
                           </tr>
                           </thead>

                           <tbody>
                           <c:choose>
                               <c:when test="${not empty recentConsultations}">
                                   <c:forEach var="item" items="${recentConsultations}">
                                       <tr>
                                           <td>${item.fullname}</td>
                                           <td>${item.phone}</td>
                                           <td>${item.email}</td>
                                       </tr>
                                   </c:forEach>
                               </c:when>
                               <c:otherwise>
                                   <tr>
                                       <td colspan="3" class="empty-cell">Không có dữ liệu</td>
                                   </tr>
                               </c:otherwise>
                           </c:choose>
                           </tbody>
                       </table>
                   </div>
               </div>

           </div>

       </main>
   </div>
</div>
</body>
</html>