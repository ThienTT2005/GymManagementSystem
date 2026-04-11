@Entity
@Table(name = "memberships")
public class Membership {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int membershipId;

    @ManyToOne
    @JoinColumn(name = "member_id")
    private Member member;

    @ManyToOne
    @JoinColumn(name = "package_id")
    private PackageEntity packageEntity;

    private java.util.Date startDate;
    private java.util.Date endDate;
    private int status;
    private String note;
}