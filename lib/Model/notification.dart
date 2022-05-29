class NotificationModel {
  String heading;
  String content;
  String toUID;
  String fromUID;
  String createdAt;
  NotificationModel({
    required this.heading,
    required this.content,
    required this.toUID,
    required this.fromUID,
    required this.createdAt,
  });
}
