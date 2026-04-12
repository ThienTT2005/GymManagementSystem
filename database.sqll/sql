-- RESET DATABASE
DROP DATABASE IF EXISTS gym_management;
CREATE DATABASE gym_management;
USE gym_management;

-- 1. ROLES
CREATE TABLE roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- 2. USERS
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    status VARCHAR(20),
    role_id INT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
) ENGINE=InnoDB;

-- 3. MEMBERS
CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    fullname VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255),
    address VARCHAR(255),
    gender VARCHAR(10),
    dob DATE,
    status TINYINT,
    avatar VARCHAR(255),
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB;

-- 4. STAFF
CREATE TABLE staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    full_name VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255),
    address VARCHAR(255),
    gender VARCHAR(10),
    dob DATE,
    position VARCHAR(100),
    salary DOUBLE,
    hire_date DATE,
    note TEXT,
    status TINYINT,
    avatar VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB;

-- 5. TRAINERS
CREATE TABLE trainers (
    trainer_id INT PRIMARY KEY AUTO_INCREMENT,
    staff_id INT NOT NULL,
    specialty VARCHAR(255),
    experience INT,
    certifications TEXT,
    photo VARCHAR(255),
    status TINYINT,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
) ENGINE=InnoDB;

-- 6. PACKAGES
CREATE TABLE packages (
    package_id INT PRIMARY KEY AUTO_INCREMENT,
    package_name VARCHAR(255),
    price DOUBLE,
    duration_months INT,
    description TEXT,
    image VARCHAR(255),
    status TINYINT
) ENGINE=InnoDB;

-- 7. SERVICES
CREATE TABLE services (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    service_name VARCHAR(255),
    price DOUBLE,
    description TEXT,
    image VARCHAR(255),
    status TINYINT
) ENGINE=InnoDB;

-- 8. CLASSES
CREATE TABLE classes (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    class_name VARCHAR(255),
    service_id INT,
    trainer_id INT,
    max_member INT,
    current_member INT,
    description TEXT,
    status TINYINT,
    FOREIGN KEY (service_id) REFERENCES services(service_id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id)
) ENGINE=InnoDB;

-- 9. SCHEDULES
CREATE TABLE schedules (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT,
    day_of_week VARCHAR(20),
    start_time TIME,
    end_time TIME,
    status TINYINT,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
) ENGINE=InnoDB;

-- 10. MEMBERSHIPS
CREATE TABLE memberships (
    membership_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    package_id INT,
    start_date DATE,
    end_date DATE,
    status TINYINT,
    note TEXT,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (package_id) REFERENCES packages(package_id)
) ENGINE=InnoDB;

-- 11. CLASS_REGISTRATIONS
CREATE TABLE class_registrations (
    class_registration_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    class_id INT,
    service_id INT,
    start_date DATE,
    end_date DATE,
    registration_date DATE,
    status TINYINT,
    note TEXT,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id)
) ENGINE=InnoDB;

-- 12. PAYMENTS
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    membership_id INT NULL,
    class_registration_id INT NULL,
    amount DOUBLE,
    payment_method VARCHAR(50),
    payment_date DATETIME,
    proof_image VARCHAR(255),
    status VARCHAR(20),
    note TEXT,
    FOREIGN KEY (membership_id) REFERENCES memberships(membership_id),
    FOREIGN KEY (class_registration_id) REFERENCES class_registrations(class_registration_id)
) ENGINE=InnoDB;

-- 13. TRIAL_REQUESTS
CREATE TABLE trial_requests (
    trial_id INT PRIMARY KEY AUTO_INCREMENT,
    fullname VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255),
    preferred_date DATE,
    status VARCHAR(50),
    note TEXT
) ENGINE=InnoDB;

-- 14. CONSULTATIONS
CREATE TABLE consultations (
    consultation_id INT PRIMARY KEY AUTO_INCREMENT,
    fullname VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255),
    status VARCHAR(50)
) ENGINE=InnoDB;

-- 15. NEWS
CREATE TABLE news (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    content TEXT,
    category VARCHAR(100),
    image VARCHAR(255),
    status TINYINT
) ENGINE=InnoDB;

-- 16. NOTIFICATIONS
CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    title VARCHAR(255),
    message TEXT,
    is_read TINYINT,
    content TEXT,
    target_url VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB;

-- DATA
INSERT INTO roles (role_name) VALUES ('ADMIN'), ('MEMBER'), ('TRAINER');

INSERT INTO users (username, password, role_id, status)
VALUES ('admin', '123', 1, 'ACTIVE');