package com.gym.GymManagementSystem.controller.trainer;

import com.gym.GymManagementSystem.model.ClassRegistration;
import com.gym.GymManagementSystem.model.GymClass;
import com.gym.GymManagementSystem.model.Member;
import com.gym.GymManagementSystem.model.Schedule;
import com.gym.GymManagementSystem.model.Trainer;
import com.gym.GymManagementSystem.model.User;
import com.gym.GymManagementSystem.service.ClassRegistrationService;
import com.gym.GymManagementSystem.service.MemberService;
import com.gym.GymManagementSystem.service.ScheduleService;
import com.gym.GymManagementSystem.service.TrainerService;
import com.gym.GymManagementSystem.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
public class TrainerController {

    private final ScheduleService scheduleService;
    private final ClassRegistrationService classRegistrationService;
    private final MemberService memberService;
    private final UserService userService;
    private final TrainerService trainerService;

    public TrainerController(ScheduleService scheduleService,
                             ClassRegistrationService classRegistrationService,
                             MemberService memberService,
                             UserService userService,
                             TrainerService trainerService) {
        this.scheduleService = scheduleService;
        this.classRegistrationService = classRegistrationService;
        this.memberService = memberService;
        this.userService = userService;
        this.trainerService = trainerService;
    }

    @GetMapping("/trainer/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        Trainer trainer = trainerService.getTrainerByUserId(user.getUserId());
        List<Schedule> trainerSchedules = getSchedulesOfTrainer(trainer);
        List<GymClass> trainerClasses = refreshCurrentMembers(getDistinctClasses(trainerSchedules));

        int activeStudentCount = 0;
        for (GymClass gymClass : trainerClasses) {
            activeStudentCount += classRegistrationService.findActiveByClassId(gymClass.getClassId()).size();
        }

        List<Schedule> upcomingSchedules = trainerSchedules.stream()
                .sorted(scheduleComparator())
                .limit(8)
                .toList();

        model.addAttribute("pageTitle", "Dashboard Trainer");
        model.addAttribute("activePage", "dashboard");
        model.addAttribute("classCount", trainerClasses.size());
        model.addAttribute("scheduleCount", trainerSchedules.size());
        model.addAttribute("activeStudentCount", activeStudentCount);
        model.addAttribute("upcomingSchedules", upcomingSchedules);
        model.addAttribute("trainerClasses", trainerClasses.stream().limit(5).toList());

        return "trainer/dashboard";
    }

    @GetMapping("/trainer/classes")
    public String classes(@RequestParam(required = false) String keyword,
                          HttpSession session,
                          Model model) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        Trainer trainer = trainerService.getTrainerByUserId(user.getUserId());
        List<GymClass> trainerClasses = refreshCurrentMembers(getDistinctClasses(getSchedulesOfTrainer(trainer)));

        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.trim().toLowerCase();
            trainerClasses = trainerClasses.stream()
                    .filter(c -> {
                        String className = c.getClassName() != null ? c.getClassName().toLowerCase() : "";
                        String serviceName = c.getService() != null && c.getService().getServiceName() != null
                                ? c.getService().getServiceName().toLowerCase()
                                : "";
                        return className.contains(kw) || serviceName.contains(kw);
                    })
                    .toList();
        }

        model.addAttribute("pageTitle", "Lớp đang phụ trách");
        model.addAttribute("activePage", "classes");
        model.addAttribute("keyword", keyword == null ? "" : keyword);
        model.addAttribute("trainerClasses", trainerClasses);

        return "trainer/classes";
    }

    @GetMapping("/trainer/schedule")
    public String schedule(@RequestParam(required = false) String keyword,
                           HttpSession session,
                           Model model) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        Trainer trainer = trainerService.getTrainerByUserId(user.getUserId());
        List<Schedule> schedules = getSchedulesOfTrainer(trainer);

        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.trim().toLowerCase();
            schedules = schedules.stream()
                    .filter(s -> {
                        String className = s.getGymClass() != null && s.getGymClass().getClassName() != null
                                ? s.getGymClass().getClassName().toLowerCase()
                                : "";
                        String serviceName = s.getGymClass() != null
                                && s.getGymClass().getService() != null
                                && s.getGymClass().getService().getServiceName() != null
                                ? s.getGymClass().getService().getServiceName().toLowerCase()
                                : "";
                        String day = s.getDayOfWeek() != null ? s.getDayOfWeek().toLowerCase() : "";
                        return className.contains(kw) || serviceName.contains(kw) || day.contains(kw);
                    })
                    .toList();
        }

        model.addAttribute("pageTitle", "Lịch dạy");
        model.addAttribute("activePage", "schedule");
        model.addAttribute("keyword", keyword == null ? "" : keyword);
        model.addAttribute("schedules", schedules);

        return "trainer/schedule";
    }

    @GetMapping("/trainer/class-members")
    public String classMembers(@RequestParam(required = false) Integer classId,
                               @RequestParam(required = false) String keyword,
                               HttpSession session,
                               Model model,
                               RedirectAttributes redirectAttributes) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        Trainer trainer = trainerService.getTrainerByUserId(user.getUserId());
        List<GymClass> trainerClasses = refreshCurrentMembers(getDistinctClasses(getSchedulesOfTrainer(trainer)));
        Set<Integer> allowedClassIds = trainerClasses.stream()
                .map(GymClass::getClassId)
                .collect(Collectors.toSet());

        List<ClassRegistration> classMembers = new ArrayList<>();

        if (classId != null) {
            if (!allowedClassIds.contains(classId)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Bạn không có quyền xem lớp này");
                return "redirect:/trainer/class-members";
            }
            classMembers = classRegistrationService.findActiveByClassId(classId);
        }

        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.trim().toLowerCase();
            classMembers = classMembers.stream()
                    .filter(r -> {
                        String fullName = r.getMember() != null && r.getMember().getFullname() != null
                                ? r.getMember().getFullname().toLowerCase()
                                : "";
                        String phone = r.getMember() != null && r.getMember().getPhone() != null
                                ? r.getMember().getPhone().toLowerCase()
                                : "";
                        String email = r.getMember() != null && r.getMember().getEmail() != null
                                ? r.getMember().getEmail().toLowerCase()
                                : "";
                        return fullName.contains(kw) || phone.contains(kw) || email.contains(kw);
                    })
                    .toList();
        }

        model.addAttribute("pageTitle", "Danh sách học viên");
        model.addAttribute("activePage", "class-members");
        model.addAttribute("trainerClasses", trainerClasses);
        model.addAttribute("selectedClassId", classId);
        model.addAttribute("keyword", keyword == null ? "" : keyword);
        model.addAttribute("classMembers", classMembers);

        return "trainer/students";
    }

    @GetMapping("/trainer/student-detail")
    public String studentDetail(@RequestParam Integer id,
                                @RequestParam Integer classId,
                                HttpSession session,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        Trainer trainer = trainerService.getTrainerByUserId(user.getUserId());
        List<GymClass> trainerClasses = refreshCurrentMembers(getDistinctClasses(getSchedulesOfTrainer(trainer)));

        boolean allowedClass = trainerClasses.stream()
                .anyMatch(c -> c.getClassId().equals(classId));

        if (!allowedClass) {
            redirectAttributes.addFlashAttribute("errorMessage", "Bạn không có quyền xem học viên này");
            return "redirect:/trainer/class-members";
        }

        Member member = memberService.getMemberById(id);
        if (member == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy học viên");
            return "redirect:/trainer/class-members?classId=" + classId;
        }

        boolean memberBelongsToClass = classRegistrationService.findActiveByClassId(classId).stream()
                .anyMatch(r -> r.getMember() != null && r.getMember().getMemberId().equals(id));

        if (!memberBelongsToClass) {
            redirectAttributes.addFlashAttribute("errorMessage", "Học viên không thuộc lớp này");
            return "redirect:/trainer/class-members?classId=" + classId;
        }

        model.addAttribute("pageTitle", "Chi tiết học viên");
        model.addAttribute("activePage", "class-members");
        model.addAttribute("member", member);
        model.addAttribute("classIdOfStudent", classId);

        return "trainer/student-detail";
    }

    @GetMapping("/trainer/class-detail")
    public String classDetail(@RequestParam Integer id,
                              HttpSession session,
                              Model model,
                              RedirectAttributes redirectAttributes) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        Trainer trainer = trainerService.getTrainerByUserId(user.getUserId());
        List<Schedule> trainerSchedules = getSchedulesOfTrainer(trainer);

        GymClass gymClass = trainerSchedules.stream()
                .map(Schedule::getGymClass)
                .filter(c -> c != null && c.getClassId().equals(id))
                .findFirst()
                .orElse(null);

        if (gymClass == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy lớp học");
            return "redirect:/trainer/classes";
        }

        refreshCurrentMember(gymClass);

        List<Schedule> schedules = trainerSchedules.stream()
                .filter(s -> s.getGymClass() != null && s.getGymClass().getClassId().equals(id))
                .sorted(scheduleComparator())
                .toList();

        List<ClassRegistration> classMembers = classRegistrationService.findActiveByClassId(id);

        model.addAttribute("pageTitle", "Chi tiết lớp học");
        model.addAttribute("activePage", "classes");
        model.addAttribute("gymClass", gymClass);
        model.addAttribute("schedules", schedules);
        model.addAttribute("classMembers", classMembers);
        model.addAttribute("memberCount", classMembers.size());

        return "trainer/class-detail";
    }

    @GetMapping("/trainer/profile")
    public String profile(HttpSession session, Model model) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        User freshUser = userService.getUserById(user.getUserId());

        model.addAttribute("pageTitle", "Hồ sơ cá nhân");
        model.addAttribute("activePage", "profile");
        model.addAttribute("user", freshUser);

        return "trainer/profile";
    }

    @GetMapping("/trainer/edit-profile")
    public String editProfile(HttpSession session, Model model) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        User freshUser = userService.getUserById(user.getUserId());

        model.addAttribute("pageTitle", "Cập nhật hồ sơ");
        model.addAttribute("activePage", "profile");
        model.addAttribute("user", freshUser);

        return "trainer/edit-profile";
    }

    @PostMapping("/trainer/edit-profile")
    public String editProfileSubmit(@RequestParam String username,
                                    @RequestParam(value = "avatarFile", required = false) MultipartFile avatarFile,
                                    HttpSession session,
                                    RedirectAttributes redirectAttributes) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        try {
            User updated = userService.updateOwnProfile(user.getUserId(), username);
            trainerService.updateOwnPhoto(user.getUserId(), avatarFile);

            if (updated != null) {
                session.setAttribute("loggedInUser", updated);
            }

            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật hồ sơ thành công");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/trainer/edit-profile";
        }

        return "redirect:/trainer/profile";
    }

    @GetMapping("/trainer/change-password")
    public String changePassword(Model model) {
        model.addAttribute("pageTitle", "Đổi mật khẩu");
        model.addAttribute("activePage", "profile");
        return "trainer/change-password";
    }

    @PostMapping("/trainer/change-password")
    public String changePasswordSubmit(@RequestParam String currentPassword,
                                       @RequestParam String newPassword,
                                       @RequestParam String confirmPassword,
                                       HttpSession session,
                                       RedirectAttributes redirectAttributes) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        try {
            userService.changePassword(
                    user.getUserId(),
                    currentPassword,
                    newPassword,
                    confirmPassword
            );
            redirectAttributes.addFlashAttribute("successMessage", "Đổi mật khẩu thành công");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/trainer/change-password";
    }

    private User getLoggedInUser(HttpSession session) {
        Object obj = session.getAttribute("loggedInUser");
        return obj instanceof User loggedIn ? loggedIn : null;
    }

    private List<Schedule> getSchedulesOfTrainer(Trainer trainer) {
        if (trainer == null) {
            return List.of();
        }

        return scheduleService.findAll().stream()
                .filter(s -> s.getStatus() != null && s.getStatus() == 1)
                .filter(s -> s.getGymClass() != null
                        && s.getGymClass().getTrainer() != null
                        && s.getGymClass().getTrainer().getTrainerId().equals(trainer.getTrainerId()))
                .sorted(scheduleComparator())
                .toList();
    }

    private List<GymClass> getDistinctClasses(List<Schedule> schedules) {
        Map<Integer, GymClass> map = new LinkedHashMap<>();
        for (Schedule s : schedules) {
            if (s.getGymClass() != null) {
                map.putIfAbsent(s.getGymClass().getClassId(), s.getGymClass());
            }
        }
        return new ArrayList<>(map.values());
    }

    private List<GymClass> refreshCurrentMembers(List<GymClass> classes) {
        classes.forEach(this::refreshCurrentMember);
        return classes;
    }

    private void refreshCurrentMember(GymClass gymClass) {
        if (gymClass == null || gymClass.getClassId() == null) {
            return;
        }
        gymClass.setCurrentMember(classRegistrationService.findActiveByClassId(gymClass.getClassId()).size());
    }

    private Comparator<Schedule> scheduleComparator() {
        return Comparator
                .comparing((Schedule s) -> Optional.ofNullable(s.getDayOfWeek()).orElse(""))
                .thenComparing(s -> Optional.ofNullable(s.getStartTime()).orElse(null),
                        Comparator.nullsLast(Comparator.naturalOrder()));
    }
}