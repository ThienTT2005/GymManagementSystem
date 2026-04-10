@Entity
@Table(name = "members")
public class Member {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int memberId;

    private String fullname;
    private String phone;
    private String email;
    private String address;
    private String gender;

    private java.util.Date dob;

    private int status;
    private String avatar;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
}