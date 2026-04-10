@Entity
@Table(name = "classes")
public class GymClass {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int classId;

    private String className;

    @ManyToOne
    @JoinColumn(name = "service_id")
    private Service service;

    @ManyToOne
    @JoinColumn(name = "trainer_id")
    private Trainer trainer;

    private int maxMember;
    private int currentMember;
    private String description;
    private int status;
}