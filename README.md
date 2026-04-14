# 🏋️ Hệ Thống Quản Lý Phòng Gym

## 📌 Giới thiệu

Hệ thống Quản lý Phòng Gym là ứng dụng web hỗ trợ quản lý hoạt động của phòng gym.
Hệ thống cung cấp các chức năng cho nhiều vai trò như Guest, Member, Receptionist, Trainer và Admin nhằm quản lý hội viên, gói tập, lớp học và thanh toán một cách hiệu quả.

---

## 👥 Các vai trò trong hệ thống

* **Guest**: Xem thông tin, đăng ký tập thử, tạo tài khoản
* **Member**: Đăng ký gói tập, upload minh chứng thanh toán, đăng ký lớp
* **Receptionist**: Duyệt đăng ký, xác nhận thanh toán, quản lý hội viên
* **Trainer**: Xem lịch dạy, quản lý học viên trong lớp
* **Admin**: Quản lý toàn bộ hệ thống

---

## 🛠️ Công nghệ sử dụng

* Java 17
* Spring Boot
* JSP / Servlet
* MySQL
* Maven

---

## 🚀 Hướng dẫn chạy dự án

### 1. Yêu cầu môi trường

* Java 17
* MySQL đang chạy
* Maven hoặc dùng `mvnw`

---

### 2. Cấu hình database

Mở file:

src/main/resources/application.properties

Cấu hình:

spring.datasource.url=jdbc:mysql://localhost:3306/gym_management_system?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=123456
spring.jpa.hibernate.ddl-auto=update
spring.sql.init.mode=always

**Lưu ý:**

* Chỉ cần chỉnh username và password đúng với MySQL
* Không cần tạo database thủ công

---

### 3. Chạy project

#### Windows

mvnw.cmd spring-boot:run

#### Mac/Linux

./mvnw spring-boot:run

Hoặc chạy trực tiếp class:
GymManagementSystemApplication

---

### 4. Truy cập hệ thống

http://localhost:8080

---

## 🔑 Tài khoản test

**Mật khẩu:** 123456

* **Admin:** admin
* **Receptionist:** lethanh_reception
* **Trainer:** phamhoang_pt
* **Member:** tranminh_tam

---

## 🔄 Chức năng chính

### 👤 Member

* Đăng ký lớp học
* Đăng ký gói tập
* Upload minh chứng thanh toán
* Xem lịch học

### 🧑‍💼 Receptionist

* Xác nhận thanh toán
* Duyệt đăng ký gói tập
* Duyệt đăng ký lớp học
* Quản lý hội viên
* Duyệt đăng ký tập thử
* Cập nhật tư vấn

### 🏋️ Trainer

* Xem lịch dạy
* Xem danh sách học viên
* Xem chi tiết học viên

### 🧑‍💻 Admin

* Quản lý user
* Quản lý hội viên
* Quản lý nhân viên
* Quản lý gói tập
* Quản lý dịch vụ
* Quản lý lớp học
* Quản lý lịch học
* Quản lý đăng ký gói tập
* Quản lý đăng ký lớp học
* Quản lý thanh toán
* Quản lý đăng ký tập thử
* Quản lý tư vấn
* Quản lý tin tức
* Xem báo cáo
