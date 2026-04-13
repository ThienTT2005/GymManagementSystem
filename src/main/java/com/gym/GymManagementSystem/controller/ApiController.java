package com.gym.GymManagementSystem.controller;

import com.gym.GymManagementSystem.dto.PhoneCheckResponseDTO;
import com.gym.GymManagementSystem.dto.TrialRequestDTO;
import com.gym.GymManagementSystem.model.Consultation;
import com.gym.GymManagementSystem.model.TrialRegistration;
import com.gym.GymManagementSystem.repository.ConsultationRepository;
import com.gym.GymManagementSystem.repository.TrialRegistrationRepository;
import com.gym.GymManagementSystem.service.ConsultationService;
import com.gym.GymManagementSystem.service.TrialRegistrationService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class ApiController {

    private final ConsultationRepository consultationRepository;
    private final TrialRegistrationRepository trialRegistrationRepository;
    private final ConsultationService consultationService;
    private final TrialRegistrationService trialRegistrationService;

    public ApiController(ConsultationRepository consultationRepository,
                         TrialRegistrationRepository trialRegistrationRepository,
                         ConsultationService consultationService,
                         TrialRegistrationService trialRegistrationService) {
        this.consultationRepository = consultationRepository;
        this.trialRegistrationRepository = trialRegistrationRepository;
        this.consultationService = consultationService;
        this.trialRegistrationService = trialRegistrationService;
    }

    @GetMapping("/check-phone")
    public ResponseEntity<PhoneCheckResponseDTO> checkPhone(
            @RequestParam String phone,
            @RequestParam String type
    ) {
        String normalizedPhone = phone == null ? "" : phone.trim();
        boolean exists;

        if ("consultation".equalsIgnoreCase(type)) {
            exists = consultationRepository.existsByPhone(normalizedPhone);
        } else if ("trial".equalsIgnoreCase(type)) {
            exists = trialRegistrationRepository.existsByPhone(normalizedPhone);
        } else {
            return ResponseEntity.badRequest()
                    .body(new PhoneCheckResponseDTO(true, "Loại kiểm tra không hợp lệ"));
        }

        String message = exists
                ? "Bạn đã điền đơn này rồi, hãy chờ phản hồi từ chúng tôi."
                : "Số điện thoại hợp lệ, bạn có thể tiếp tục gửi đơn.";

        return ResponseEntity.ok(new PhoneCheckResponseDTO(exists, message));
    }

    @PostMapping("/consultations")
    public ResponseEntity<String> saveConsultation(@RequestBody TrialRequestDTO dto) {
        String phone = dto.getPhone() == null ? "" : dto.getPhone().trim();

        if (consultationRepository.existsByPhone(phone)) {
            return ResponseEntity.badRequest()
                    .body("Bạn đã gửi đơn tư vấn rồi, hãy chờ phản hồi từ chúng tôi.");
        }

        Consultation request = new Consultation();
        request.setFullname(dto.getFullName() == null ? "" : dto.getFullName().trim());
        request.setPhone(phone);
        request.setEmail(dto.getEmail());

        String genderText = "";
        if ("male".equalsIgnoreCase(dto.getGender())) {
            genderText = "Nam";
        } else if ("female".equalsIgnoreCase(dto.getGender())) {
            genderText = "Nữ";
        } else if ("other".equalsIgnoreCase(dto.getGender())) {
            genderText = "Khác";
        }

        String message = dto.getMessage() != null ? dto.getMessage().trim() : "";
        if (!genderText.isEmpty()) {
            message = "Giới tính: " + genderText + (message.isEmpty() ? "" : "\nNội dung: " + message);
        }

        request.setMessage(message);
        consultationService.createContact(request);
        return ResponseEntity.ok("Success");
    }

    @PostMapping("/trial-requests")
    public ResponseEntity<String> saveTrialRequest(@RequestBody TrialRequestDTO dto) {
        String phone = dto.getPhone() == null ? "" : dto.getPhone().trim();

        if (trialRegistrationRepository.existsByPhone(phone)) {
            return ResponseEntity.badRequest()
                    .body("Bạn đã gửi đơn đăng ký tập thử rồi, hãy chờ phản hồi từ chúng tôi.");
        }

        TrialRegistration request = new TrialRegistration();
        request.setFullname(dto.getFullName() == null ? "" : dto.getFullName().trim());
        request.setPhone(phone);
        request.setEmail(dto.getEmail());
        request.setPreferredDate(dto.getPreferredDate());
        request.setNote(dto.getNote());

        trialRegistrationService.createTrial(request);
        return ResponseEntity.ok("Success");
    }
}