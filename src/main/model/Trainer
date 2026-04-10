@Entity
@Table(name = "trainers")
public class Trainer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int trainerId;

    @ManyToOne
    @JoinColumn(name = "staff_id")
    private Staff staff;

    private String specialty;
    private int experience;
    private String certifications;
    private String photo;
    private int status;
}