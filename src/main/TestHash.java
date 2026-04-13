package com.gym.GymManagementSystem;

import com.gym.GymManagementSystem.util.PasswordUtil;

public class TestHash {
    public static void main(String[] args) {
        // Chạy file này để lấy chuỗi Bcrypt nếu bạn muốn đổi mật khẩu khác 123456
        String pass = "123456";
        System.out.println("Mật khẩu: " + pass);
        System.out.println("Mã hóa Bcrypt: " + PasswordUtil.hash(pass));
    }
}