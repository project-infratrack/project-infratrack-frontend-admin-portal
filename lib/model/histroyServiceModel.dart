class HistoryServiceModel {
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
  final List<dynamic> thumbsUpUsers;
  final List<dynamic> thumbsDownUsers;

  HistoryServiceModel({
    required this.id,
    required this.userId,
    required this.reportType,
    required this.description,
    required this.location,
    this.image,
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

  factory HistoryServiceModel.fromJson(Map<String, dynamic> json) {
    return HistoryServiceModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      reportType: json['reportType'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      image: json['image'],
      status: json['status'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      priorityLevel: json['priorityLevel'] as String,
      thumbsUp: json['thumbsUp'] as int,
      thumbsDown: json['thumbsDown'] as int,
      approval: json['approval'] as String,
      thumbsUpUsers: json['thumbsUpUsers'] as List<dynamic>,
      thumbsDownUsers: json['thumbsDownUsers'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'reportType': reportType,
      'description': description,
      'location': location,
      'image': image,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'priorityLevel': priorityLevel,
      'thumbsUp': thumbsUp,
      'thumbsDown': thumbsDown,
      'approval': approval,
      'thumbsUpUsers': thumbsUpUsers,
      'thumbsDownUsers': thumbsDownUsers,
    };
  }
}
