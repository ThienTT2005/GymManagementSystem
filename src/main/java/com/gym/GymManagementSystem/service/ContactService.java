package com.gym.GymManagementSystem.service;

import com.gym.GymManagementSystem.entity.Contact;
import org.springframework.data.domain.Page;

import java.util.List;

public interface ContactService {
    List<Contact> findAll();
    Contact findById(Long id);
    Contact save(Contact contact);
    void deleteById(Long id);

    Page<Contact> searchContacts(String keyword, String status, int page, int size);
    void toggleStatus(Long id);
}