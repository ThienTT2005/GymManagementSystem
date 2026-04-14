-- =========================
-- ROLES
-- =========================
INSERT IGNORE INTO roles (role_id, role_name) VALUES (1, 'ADMIN');
INSERT IGNORE INTO roles (role_id, role_name) VALUES (2, 'RECEPTIONIST');
INSERT IGNORE INTO roles (role_id, role_name) VALUES (3, 'TRAINER');
INSERT IGNORE INTO roles (role_id, role_name) VALUES (4, 'MEMBER');

-- =========================
-- USERS
-- Password mặc định: 123456
-- =========================
INSERT IGNORE INTO users (user_id, username, password, status, role_id, created_at, updated_at) VALUES
(1, 'admin', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 1, NOW(), NOW()),
(2, 'lethanh_reception', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 2, NOW(), NOW()),
(3, 'phamhoang_pt', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 3, NOW(), NOW()),
(4, 'nguyenlinh_yoga', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 3, NOW(), NOW()),
(5, 'dangquang_gym', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 3, NOW(), NOW()),
(6, 'tranminh_tam', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 4, NOW(), NOW()),
(7, 'hoangthuthao', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 4, NOW(), NOW()),
(8, 'vuvietanh', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 4, NOW(), NOW()),
(9, 'nguyenphuongmai', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 4, NOW(), NOW()),
(10, 'lequockhanh', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 4, NOW(), NOW()),
(11, 'phamngoclan', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 4, NOW(), NOW()),
(12, 'doanthanhvinh', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 4, NOW(), NOW()),
(13, 'buitheson', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 4, NOW(), NOW()),
(14, 'duongthuhien', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 4, NOW(), NOW()),
(15, 'ngokiencuong', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 4, NOW(), NOW());

-- =========================
-- STAFF
-- =========================
INSERT IGNORE INTO staff (staff_id, user_id, full_name, phone, email, position, salary, status, created_at, updated_at) VALUES
(1, 2, 'Lê Thành Lễ', '0912345678', 'lethanhle@fitgym.vn', 'Lễ tân', 8500000, 1, NOW(), NOW()),
(2, 3, 'Phạm Hoàng', '0987654321', 'phamhoang@fitgym.vn', 'Huấn luyện viên', 18000000, 1, NOW(), NOW()),
(3, 4, 'Nguyễn Khánh Linh', '0944556677', 'khanhlinh@fitgym.vn', 'Huấn luyện viên', 16000000, 1, NOW(), NOW()),
(4, 5, 'Đặng Nhật Quang', '0933221100', 'nhatquang@fitgym.vn', 'Huấn luyện viên', 17500000, 1, NOW(), NOW());

-- =========================
-- TRAINERS
-- =========================
INSERT IGNORE INTO trainers (trainer_id, staff_id, specialty, experience, certifications, photo, status, created_at, updated_at) VALUES
(1, 2, 'Căng cơ & Thể hình', '5 năm', 'Chứng chỉ PT Quốc tế NASM', 'assets/images/trainers/pt-hoang.png', 1, NOW(), NOW()),
(2, 3, 'Yoga & Pilates', '4 năm', 'Yoga Alliance RYT 200', 'assets/images/trainers/yoga-linh.png', 1, NOW(), NOW()),
(3, 4, 'Boxing & Cardio', '6 năm', 'HLV Boxing chuyên nghiệp', 'assets/images/trainers/boxing-quang.png', 1, NOW(), NOW());

-- =========================
-- MEMBERS
-- =========================
INSERT IGNORE INTO members (member_id, user_id, fullname, phone, email, status, created_at, updated_at) VALUES
(1, 6, 'Trần Minh Tâm', '0901234455', 'minhtam@gmail.com', 1, NOW(), NOW()),
(2, 7, 'Hoàng Thu Thảo', '0905667788', 'thuthao@gmail.com', 1, NOW(), NOW()),
(3, 8, 'Vũ Việt Anh', '0909112233', 'vietanh@gmail.com', 1, NOW(), NOW()),
(4, 9, 'Nguyễn Phương Mai', '0911889900', 'phuongmai@gmail.com', 1, NOW(), NOW()),
(5, 10, 'Lê Quốc Khánh', '0933445566', 'quockhanh@gmail.com', 1, NOW(), NOW()),
(6, 11, 'Phạm Ngọc Lan', '0988001122', 'ngoclan@gmail.com', 1, NOW(), NOW()),
(7, 12, 'Đoàn Thành Vinh', '0977443322', 'thanhvinh@gmail.com', 1, NOW(), NOW()),
(8, 13, 'Bùi Thế Sơn', '0944889911', 'theson@gmail.com', 1, NOW(), NOW()),
(9, 14, 'Dương Thu Hiền', '0911223344', 'thuhien@gmail.com', 1, NOW(), NOW()),
(10, 15, 'Ngô Kiên Cường', '0902998877', 'kiencuong@gmail.com', 1, NOW(), NOW());

-- =========================
-- PACKAGES
-- =========================
INSERT IGNORE INTO packages
(package_id, package_name, description, price, duration_months, status, created_at, updated_at)
VALUES
(1, 'Gói Cơ Bản (Standard)',
 'Tập gym không giới hạn trong 1 tháng, phù hợp cho người mới bắt đầu.',
 600000, 1, 1, NOW(), NOW()),

(2, 'Gói Tiết Kiệm (Saver)',
 'Gói 6 tháng giúp tiết kiệm chi phí, phù hợp cho người tập lâu dài và duy trì vóc dáng.',
 3200000, 6, 1, NOW(), NOW()),

(3, 'Hội Viên VIP (Elite)',
 'Gói 12 tháng dành cho hội viên muốn tập luyện nghiêm túc, ổn định và hiệu quả.',
 5500000, 12, 1, NOW(), NOW()),

(4, 'Thẻ Platinum (All-in-one)',
 'Gói cao cấp 12 tháng với đầy đủ quyền lợi và trải nghiệm dịch vụ tốt nhất.',
 12000000, 12, 1, NOW(), NOW());


-- =========================
-- SERVICES
-- =========================
INSERT IGNORE INTO services
(service_id, service_name, description, price, status, created_at, updated_at)
VALUES
(1, 'Yoga Trị Liệu & Thiền',
 'Giúp thư giãn, giảm stress, cải thiện độ dẻo dai và cân bằng cơ thể.',
 250000, 1, NOW(), NOW()),

(2, 'Boxing & Kickboxing',
 'Tăng sức bền, phản xạ và đốt mỡ hiệu quả với các bài tập cường độ cao.',
 300000, 1, NOW(), NOW()),

(3, 'Zumba & Aerobics',
 'Lớp nhảy sôi động giúp giảm cân, tăng năng lượng và tạo hứng thú khi tập luyện.',
 200000, 1, NOW(), NOW()),

(4, 'Huấn Luyện Viên Cá Nhân (PT)',
 'Huấn luyện 1 kèm 1 với giáo án riêng, giúp đạt mục tiêu nhanh và đúng cách.',
 500000, 1, NOW(), NOW());

-- =========================
-- CLASSES
-- =========================
INSERT IGNORE INTO classes (class_id, class_name, service_id, trainer_id, max_member, current_member, status, created_at, updated_at) VALUES
(1, 'Yoga Sáng - Năng Lượng Mới', 1, 2, 20, 0, 1, NOW(), NOW()),
(2, 'Boxing - Đánh Tan Stress', 2, 3, 15, 0, 1, NOW(), NOW()),
(3, 'Zumba - Đốt Cháy Calo', 3, 2, 30, 0, 1, NOW(), NOW()),
(4, 'Siết Cơ Chuyên Sâu', 4, 1, 10, 0, 1, NOW(), NOW());

-- =========================
-- SCHEDULES
-- =========================
INSERT IGNORE INTO schedules (schedule_id, class_id, day_of_week, start_time, end_time, status, created_at, updated_at) VALUES
(1, 1, 'MONDAY', '06:00:00', '07:30:00', 1, NOW(), NOW()),
(2, 1, 'WEDNESDAY', '06:00:00', '07:30:00', 1, NOW(), NOW()),
(3, 2, 'TUESDAY', '18:30:00', '20:00:00', 1, NOW(), NOW()),
(4, 3, 'SATURDAY', '19:00:00', '20:30:00', 1, NOW(), NOW());

-- =========================
-- NEWS
-- =========================
INSERT IGNORE INTO news (post_id, title, content, category, status, created_at, updated_at) VALUES
(1, 'Kế hoạch ăn uống lành mạnh mùa Hè', 'Để duy trì vóc dáng, việc nạp đủ 2 lít nước mỗi ngày và bổ sung các loại trái cây ít đường như bưởi, táo là cực kỳ cần thiết...', 'DINH DƯỠNG', 1, NOW(), NOW()),
(2, 'Bùng nổ Ưu đãi - Tập Gym chỉ từ 10k/ngày', 'Chào đón tháng mới, FitGym tung gói khuyến mãi siêu khủng dành cho tân hội viên khi đăng ký gói 12 tháng. Tặng ngay bộ quà tặng độc quyền...', 'KHUYẾN MÃI', 1, NOW(), NOW()),
(3, '5 Bài tập tại nhà hỗ trợ tăng cơ nhanh', 'Dù không đến phòng tập, bạn vẫn có thể duy trì vóc dáng với Push-up, Squat và Plank. Đây là những bài tập nền tảng giúp ổn định khung xương...', 'KINH NGHIỆM', 1, NOW(), NOW()),
(4, 'Thông báo: Lịch hoạt động dịp Lễ 30/04', 'Nhằm phục vụ nhu cầu tập luyện của quý hội viên, trung tâm xin thông báo vẫn mở cửa hoạt động xuyên suốt kỳ nghỉ lễ từ 8:00 đến 21:00...', 'THÔNG BÁO', 1, NOW(), NOW());

-- =========================
-- TRIAL REQUEST
-- =========================
INSERT IGNORE INTO trial_requests (trial_id, fullname, phone, email, preferred_date, status, created_at, updated_at) VALUES
(1, 'Lê Văn Mạnh', '0912999888', 'manhle@gmail.com', '2026-04-20', 'PENDING', NOW(), NOW()),
(2, 'Nguyễn Thị Hồng', '0905777666', 'hongnguyen@gmail.com', '2026-04-21', 'PENDING', NOW(), NOW()),
(3, 'Vũ Quang Đăng', '0988555444', 'dangvu@gmail.com', '2026-04-22', 'PENDING', NOW(), NOW());

-- =========================
-- CONSULTATION
-- =========================
INSERT IGNORE INTO consultations (consultation_id, fullname, phone, email, message, status, created_at, updated_at) VALUES
(1, 'Trần Kim Chi', '0944123123', 'kimchi@gmail.com', 'Tôi muốn tìm hiểu về lớp Yoga cho người bị đau lưng.', 'NEW', NOW(), NOW()),
(2, 'Hoàng Văn Thái', '0933456456', 'thaihoang@gmail.com', 'Cần tư vấn gói tập cho nam giới muốn tăng cân nhanh.', 'NEW', NOW(), NOW()),
(3, 'Bùi Minh Anh', '0922789789', 'minhanh@gmail.com', 'Hỏi về chi phí thuê PT kèm riêng 1-1 tại trung tâm.', 'NEW', NOW(), NOW());