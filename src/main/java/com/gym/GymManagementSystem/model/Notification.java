@Entity
@Table(name = "notifications")
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int notificationId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private String title;
    private String message;
    private int isRead;
    private String content;
    private String targetUrl;
}