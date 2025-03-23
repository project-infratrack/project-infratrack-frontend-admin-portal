class IncomingServiceModel {
  final String id;
  final String userId;
  final String reportType;
  final String description;
  final String location;
  final String image;
  final double latitude;
  final double longitude;
  final int thumbsUp;
  final int thumbsDown;

  IncomingServiceModel({
    required this.id,
    required this.userId,
    required this.reportType,
    required this.description,
    required this.location,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.thumbsUp,
    required this.thumbsDown,
  });

  factory IncomingServiceModel.fromJson(Map<String, dynamic> json) {
    return IncomingServiceModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      reportType: json['reportType'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      image: json['image'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      thumbsUp: json['thumbsUp'] as int,
      thumbsDown: json['thumbsDown'] as int,
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
      'latitude': latitude,
      'longitude': longitude,
      'thumbsUp': thumbsUp,
      'thumbsDown': thumbsDown,
    };
  }
}
