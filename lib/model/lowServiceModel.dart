class LowPriorityReport {
  final String id;
  final String userId;
  final String reportType;
  final String description;
  final String location;
  final String? image;
  final String status;
  final double latitude;
  final double longitude;
  final String priorityLevel;
  final int thumbsUp;
  final int thumbsDown;
  final String approval;
  final List<String> thumbsUpUsers;
  final List<String> thumbsDownUsers;

  LowPriorityReport({
    required this.id,
    required this.userId,
    required this.reportType,
    required this.description,
    required this.location,
    required this.image,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.priorityLevel,
    required this.thumbsUp,
    required this.thumbsDown,
    required this.approval,
    required this.thumbsUpUsers,
    required this.thumbsDownUsers,
  });

  factory LowPriorityReport.fromJson(Map<String, dynamic> json) {
    return LowPriorityReport(
      id: json['id'],
      userId: json['userId'],
      reportType: json['reportType'],
      description: json['description'],
      location: json['location'],
      image: json['image'],
      status: json['status'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      priorityLevel: json['priorityLevel'],
      thumbsUp: json['thumbsUp'],
      thumbsDown: json['thumbsDown'],
      approval: json['approval'],
      thumbsUpUsers: List<String>.from(json['thumbsUpUsers']),
      thumbsDownUsers: List<String>.from(json['thumbsDownUsers']),
    );
  }
}
