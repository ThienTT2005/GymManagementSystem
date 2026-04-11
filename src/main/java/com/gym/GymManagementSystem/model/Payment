@Entity
@Table(name = "payments")
public class Payment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int paymentId;

    @ManyToOne
    @JoinColumn(name = "membership_id")
    private Membership membership;

    @Column(name = "class_registration_id")
    private Integer classRegistrationId;

    private double amount;
    private String paymentMethod;
    private java.util.Date paymentDate;
    private String proofImage;
    private String status;
    private String note;
}