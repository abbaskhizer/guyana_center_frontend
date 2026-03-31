enum NotificationType { reportSubmitted, reportResolved, reportDismissed }

enum NotificationStatus { unread, read }

class AppNotification {
  final int id;
  final NotificationType type;
  final NotificationStatus status;
  final String title;
  final String message;
  final int? reportId;
  final int? listingId;
  final String? listingTitle;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.message,
    this.reportId,
    this.listingId,
    this.listingTitle,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    NotificationType type;
    switch (json['eventType'] ?? json['type']) {
      case 'report_submitted':
        type = NotificationType.reportSubmitted;
        break;
      case 'report_resolved':
        type = NotificationType.reportResolved;
        break;
      case 'report_dismissed':
        type = NotificationType.reportDismissed;
        break;
      default:
        type = NotificationType.reportSubmitted;
    }

    return AppNotification(
      id: json['id'] ?? 0,
      type: type,
      status: (json['isRead'] == true || json['is_read'] == true)
          ? NotificationStatus.read
          : NotificationStatus.unread,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      reportId: json['reportId'] ?? json['report_id'],
      listingId: json['listingId'] ?? json['listing_id'],
      listingTitle: json['listingTitle'] ?? json['listing_title'],
      createdAt: DateTime.parse(
        json['createdAt'] ??
            json['created_at'] ??
            DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'isRead': status == NotificationStatus.read,
      'title': title,
      'message': message,
      'reportId': reportId,
      'listingId': listingId,
      'listingTitle': listingTitle,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
