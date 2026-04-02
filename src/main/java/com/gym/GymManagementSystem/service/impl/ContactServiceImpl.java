package com.gym.GymManagementSystem.service.impl;

import com.gym.GymManagementSystem.entity.Contact;
import com.gym.GymManagementSystem.repository.ContactRepository;
import com.gym.GymManagementSystem.service.ContactService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ContactServiceImpl implements ContactService {

    private final ContactRepository contactRepository;

    public ContactServiceImpl(ContactRepository contactRepository) {
        this.contactRepository = contactRepository;
    }

    @Override
    public List<Contact> findAll() {
        return contactRepository.findAll();
    }

    @Override
    public Contact findById(Long id) {
        return contactRepository.findById(id).orElse(null);
    }

    @Override
    public Contact save(Contact contact) {
        return contactRepository.save(contact);
    }

    @Override
    public void deleteById(Long id) {
        contactRepository.deleteById(id);
    }

    @Override
    public Page<Contact> searchContacts(String keyword, String status, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("contactDate").descending());
        return contactRepository.searchContacts(keyword, status, pageable);
    }

    @Override
    public void toggleStatus(Long id) {
        Contact contact = contactRepository.findById(id).orElse(null);
        if (contact != null) {
            if ("Đã phản hồi".equalsIgnoreCase(contact.getStatus())) {
                contact.setStatus("Chưa xử lý");
            } else {
                contact.setStatus("Đã phản hồi");
            }
            contactRepository.save(contact);
        }
    }
}