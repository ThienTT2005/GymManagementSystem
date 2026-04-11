@Entity
@Table(name = "packages")
public class PackageEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int packageId;

    private String packageName;
    private double price;
    private int durationMonths;
    private String description;
    private String image;
    private int status;
}