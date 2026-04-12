package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.entity.News;
import com.gym.GymManagementSystem.repository.NewsRepository;
import com.gym.GymManagementSystem.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import com.gym.GymManagementSystem.repository.ConsultationRepository;
import com.gym.GymManagementSystem.entity.Consultation;
import com.gym.GymManagementSystem.dto.TrialRequestDto;
import com.gym.GymManagementSystem.repository.TrialRequestRepository;
import com.gym.GymManagementSystem.entity.TrialRequest;
import com.gym.GymManagementSystem.dto.FreeTrialDto;

@RestController
@RequestMapping("/api")
public class ApiController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private NewsRepository newsRepository;

    @GetMapping("/check-phone")
    public ResponseEntity<Boolean> checkPhone(@RequestParam String phone) {
        return ResponseEntity.ok(userRepository.existsByPhone(phone));
    }

    @Autowired
    private ConsultationRepository consultationRepository;

    @PostMapping("/consultations")
    public ResponseEntity<String> saveConsultation(@RequestBody TrialRequestDto dto) {
        Consultation request = new Consultation();
        request.setFullname(dto.getFullName());
        request.setPhone(dto.getPhone());
        request.setEmail(dto.getEmail());
        
        String genderText = "";
        if ("male".equals(dto.getGender())) genderText = "Nam";
        else if ("female".equals(dto.getGender())) genderText = "Nữ";
        else if ("other".equals(dto.getGender())) genderText = "Khác";

        String note = dto.getMessage() != null ? dto.getMessage() : "";
        if (!genderText.isEmpty()) {
            note = "Giới tính: " + genderText + "\nNội dung: " + note;
        }
        request.setNote(note);
        
        consultationRepository.save(request);
        
        return ResponseEntity.ok("Success");
    }

    @Autowired
    private TrialRequestRepository trialRequestRepository;

    @PostMapping("/trial-requests")
    public ResponseEntity<String> saveTrialRequest(@RequestBody FreeTrialDto dto) {
        TrialRequest request = new TrialRequest();
        request.setFullname(dto.getFullName());
        request.setPhone(dto.getPhone());
        request.setEmail(dto.getEmail());
        request.setPreferredDate(dto.getPreferredDate());
        request.setNote(dto.getNote());
        
        trialRequestRepository.save(request);
        
        return ResponseEntity.ok("Success");
    }
}
