-- =========================
-- ROLES
-- =========================
INSERT IGNORE INTO roles (role_id, role_name) VALUES (1, 'ADMIN');
INSERT IGNORE INTO roles (role_id, role_name) VALUES (2, 'RECEPTIONIST');
INSERT IGNORE INTO roles (role_id, role_name) VALUES (3, 'TRAINER');
INSERT IGNORE INTO roles (role_id, role_name) VALUES (4, 'MEMBER');

-- =========================
-- USERS (PASSWORD = 123456)
-- =========================
INSERT IGNORE INTO users (
    user_id, username, password, status, role_id, created_at, updated_at
) VALUES
(1, 'admin', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 1, NOW(), NOW()),
(2, 'reception1', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 2, NOW(), NOW()),
(3, 'trainer1', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 3, NOW(), NOW()),
(4, 'member1', '$2a$10$brJ.xmlNzcNUDAWxiwaJXeO5stdOfZw5T0TGSAXypo1a/4FUftotO', 1, 4, NOW(), NOW());

-- =========================
-- STAFF
-- =========================
INSERT IGNORE INTO staff (
    staff_id, user_id, full_name, phone, email, position, salary, status, created_at, updated_at
) VALUES
(1, 2, 'Nguyen Le Tan', '0900000001', 'reception1@gym.com', 'Receptionist', 7000000, 1, NOW(), NOW()),
(2, 3, 'Tran HLV Hieu', '0900000002', 'trainer1@gym.com', 'Trainer', 15000000, 1, NOW(), NOW());

-- =========================
-- TRAINERS (model đang dùng photo)
-- =========================
INSERT IGNORE INTO trainers (
    trainer_id, staff_id, specialty, experience, certifications, photo, status, created_at, updated_at
) VALUES
(1, 2, 'Yoga & Fitness', '3 years', 'PT, Yoga', 'assets/images/default-avatar.png', 1, NOW(), NOW());

-- =========================
-- MEMBERS (model đang dùng fullname)
-- =========================
INSERT IGNORE INTO members (
    member_id, user_id, fullname, phone, email, status, created_at, updated_at
) VALUES
(1, 4, 'Le Duy Ngoc', '0900000003', 'member1@gym.com', 1, NOW(), NOW());

-- =========================
-- PACKAGES
-- =========================
INSERT IGNORE INTO packages (
    package_id, package_name, price, duration_months, status, created_at, updated_at
) VALUES
(1, 'Basic Monthly', 500000, 1, 1, NOW(), NOW()),
(2, 'VIP 6 Months', 2500000, 6, 1, NOW(), NOW());

-- =========================
-- SERVICES
-- =========================
INSERT IGNORE INTO services (
    service_id, service_name, price, status, created_at, updated_at
) VALUES
(1, 'Yoga', 200000, 1, NOW(), NOW()),
(2, 'Zumba', 250000, 1, NOW(), NOW());

-- =========================
-- CLASSES
-- =========================
INSERT IGNORE INTO classes (
    class_id, class_name, service_id, trainer_id, max_member, current_member, status, created_at, updated_at
) VALUES
(1, 'Yoga Morning Class', 1, 1, 20, 0, 1, NOW(), NOW());

-- =========================
-- SCHEDULES
-- =========================
INSERT IGNORE INTO schedules (
    schedule_id, class_id, day_of_week, start_time, end_time, status, created_at, updated_at
) VALUES
(1, 1, 'MONDAY', '08:00:00', '10:00:00', 1, NOW(), NOW()),
(2, 1, 'WEDNESDAY', '08:00:00', '10:00:00', 1, NOW(), NOW());

-- =========================
-- MEMBERSHIP (PENDING)
-- =========================
INSERT IGNORE INTO memberships (
    membership_id, member_id, package_id, start_date, end_date, status, note, created_at, updated_at
) VALUES
(1, 1, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 1 MONTH), 'PENDING', 'Chờ xác nhận thanh toán', NOW(), NOW());

-- =========================
-- CLASS REGISTRATION
-- =========================
INSERT IGNORE INTO class_registrations (
    class_registration_id, member_id, service_id, class_id, registration_date, status
)
VALUES (1, 1, 1, 1, CURDATE(), 'ACTIVE');
-- =========================
-- PAYMENT
-- =========================
INSERT IGNORE INTO payments (
    payment_id, membership_id, amount, payment_method, payment_date, status, created_at, updated_at
) VALUES
(1, 1, 500000, 'BANK_TRANSFER', CURDATE(), 'PENDING', NOW(), NOW());

-- =========================
-- TRIAL REQUEST
-- =========================
INSERT IGNORE INTO trial_requests (
    trial_id, fullname, phone, email, preferred_date, status, created_at, updated_at
) VALUES
(1, 'Nguyen Van A', '0900000009', 'trial@gym.com', CURDATE(), 'PENDING', NOW(), NOW());

-- =========================
-- CONSULTATION
-- =========================
INSERT IGNORE INTO consultations (
    consultation_id, fullname, phone, email, message, status, created_at, updated_at
) VALUES
(1, 'Tran Thi B', '0900000010', 'consult@gym.com', 'Tôi muốn tư vấn gói tập', 'NEW', NOW(), NOW());

-- =========================
-- NEWS
-- =========================
INSERT IGNORE INTO news (
    post_id, title, content, category, status, created_at, updated_at
) VALUES
(1, 'Khai trương phòng gym', 'Giảm giá 50% cho hội viên mới', 'PROMOTION', 1, NOW(), NOW());

-- =========================
-- NOTIFICATIONS
-- =========================
INSERT IGNORE INTO notifications (
    notification_id, user_id, title, message, is_read, status, created_at
) VALUES
(1, 1, 'Chào mừng', 'Chào mừng admin vào hệ thống', false, 1, NOW());