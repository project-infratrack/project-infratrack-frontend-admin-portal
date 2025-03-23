class IssueDescriptionModel {
  final String id;
  final String userId;
  final String reportType;
  final String description;
  final String location;
  final String image;
  final double latitude;
  final double longitude;
  final int? priorityLevel;
  final String? status;
  final int thumbsUp;
  final int thumbsDown;

  IssueDescriptionModel({
    required this.id,
    required this.userId,
    required this.reportType,
    required this.description,
    required this.location,
    required this.image,
    required this.latitude,
    required this.longitude,
    this.priorityLevel,
    this.status,
    required this.thumbsUp,
    required this.thumbsDown,
  });

  factory IssueDescriptionModel.fromJson(Map<String, dynamic> json) {
    return IssueDescriptionModel(
      id: json['id'],
      userId: json['userId'],
      reportType: json['reportType'],
      description: json['description'],
      location: json['location'],
      image: json['image'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      priorityLevel: json['priorityLevel'],
      status: json['status'],
      thumbsUp: json['thumbsUp'],
      thumbsDown: json['thumbsDown'],
    );
  }
}
