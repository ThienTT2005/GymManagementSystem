@Entity
@Table(name = "staff")
public class Staff {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int staffId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private String fullName;
    private String phone;
    private String email;
    private String address;
    private String gender;

    private java.util.Date dob;

    private String position;
    private double salary;
    private java.util.Date hireDate;

    private String note;
    private int status;
    private String avatar;
}