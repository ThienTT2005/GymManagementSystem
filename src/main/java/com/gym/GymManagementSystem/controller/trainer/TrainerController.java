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
        List<GymClass> trainerClasses = getDistinctClasses(trainerSchedules);

        int activeStudentCount = 0;
        for (GymClass gymClass : trainerClasses) {
            activeStudentCount += classRegistrationService.findActiveByClassId(gymClass.getClassId()).size();
        }

        List<Schedule> upcomingSchedules = trainerSchedules.stream()
                .sorted(Comparator
                        .comparing((Schedule s) -> Optional.ofNullable(s.getDayOfWeek()).orElse(""))
                        .thenComparing(s -> Optional.ofNullable(s.getStartTime()).orElse(null),
                                Comparator.nullsLast(Comparator.naturalOrder())))
                .limit(8)
                .toList();

        model.addAttribute("pageTitle", "Dashboard Trainer");
        model.addAttribute("activePage", "dashboard");
        model.addAttribute("trainerProfile", trainer);
        model.addAttribute("classCount", trainerClasses.size());
        model.addAttribute("scheduleCount", trainerSchedules.size());
        model.addAttribute("activeStudentCount", activeStudentCount);
        model.addAttribute("upcomingSchedules", upcomingSchedules);

        return "trainer/dashboard";
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
                                ? s.getGymClass().getClassName().toLowerCase() : "";
                        String day = s.getDayOfWeek() != null ? s.getDayOfWeek().toLowerCase() : "";
                        return className.contains(kw) || day.contains(kw);
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
                               Model model) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        Trainer trainer = trainerService.getTrainerByUserId(user.getUserId());
        List<GymClass> trainerClasses = getDistinctClasses(getSchedulesOfTrainer(trainer));

        List<ClassRegistration> classMembers = new ArrayList<>();
        if (classId != null) {
            classMembers = classRegistrationService.findActiveByClassId(classId);
        }

        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.trim().toLowerCase();
            classMembers = classMembers.stream()
                    .filter(r -> {
                        String fullName = r.getMember() != null && r.getMember().getFullname() != null
                                ? r.getMember().getFullname().toLowerCase() : "";
                        String phone = r.getMember() != null && r.getMember().getPhone() != null
                                ? r.getMember().getPhone().toLowerCase() : "";
                        String email = r.getMember() != null && r.getMember().getEmail() != null
                                ? r.getMember().getEmail().toLowerCase() : "";
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
                                @RequestParam(required = false) Integer classId,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        Member member = memberService.getMemberById(id);
        if (member == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy học viên");
            return "redirect:/trainer/class-members";
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
            return "redirect:/trainer/class-members";
        }

        List<Schedule> schedules = trainerSchedules.stream()
                .filter(s -> s.getGymClass() != null && s.getGymClass().getClassId().equals(id))
                .sorted(Comparator
                        .comparing((Schedule s) -> Optional.ofNullable(s.getDayOfWeek()).orElse(""))
                        .thenComparing(s -> Optional.ofNullable(s.getStartTime()).orElse(null),
                                Comparator.nullsLast(Comparator.naturalOrder())))
                .toList();

        List<ClassRegistration> classMembers = classRegistrationService.findActiveByClassId(id);

        model.addAttribute("pageTitle", "Chi tiết lớp học");
        model.addAttribute("activePage", "class-members");
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
        Trainer trainer = trainerService.getTrainerByUserId(user.getUserId());

        model.addAttribute("pageTitle", "Hồ sơ cá nhân");
        model.addAttribute("activePage", "profile");
        model.addAttribute("user", freshUser);
        model.addAttribute("trainerProfile", trainer);

        return "trainer/profile";
    }

    @GetMapping("/trainer/edit-profile")
    public String editProfile(HttpSession session, Model model) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        User freshUser = userService.getUserById(user.getUserId());
        Trainer trainer = trainerService.getTrainerByUserId(user.getUserId());

        model.addAttribute("pageTitle", "Cập nhật hồ sơ");
        model.addAttribute("activePage", "profile");
        model.addAttribute("user", freshUser);
        model.addAttribute("trainerProfile", trainer);

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

        User updated = userService.updateOwnProfile(user.getUserId(), username, avatarFile);
        session.setAttribute("loggedInUser", updated);

        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật hồ sơ thành công");
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
                                       HttpSession session,
                                       RedirectAttributes redirectAttributes) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        boolean ok = userService.changePassword(user.getUserId(), currentPassword, newPassword);

        if (ok) {
            redirectAttributes.addFlashAttribute("successMessage", "Đổi mật khẩu thành công");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Mật khẩu hiện tại không đúng");
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
                .sorted(Comparator
                        .comparing((Schedule s) -> Optional.ofNullable(s.getDayOfWeek()).orElse(""))
                        .thenComparing(s -> Optional.ofNullable(s.getStartTime()).orElse(null),
                                Comparator.nullsLast(Comparator.naturalOrder())))
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
}