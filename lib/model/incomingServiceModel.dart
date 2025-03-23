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
    // Debug: Print raw JSON to check structure
    print('Raw JSON: $json');

    return IncomingServiceModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      reportType: json['reportType']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      latitude: (json['latitude'] != null)
          ? (json['latitude'] as num).toDouble()
          : 0.0,
      longitude: (json['longitude'] != null)
          ? (json['longitude'] as num).toDouble()
          : 0.0,
      thumbsUp: json['thumbsUp'] ?? 0,
      thumbsDown: json['thumbsDown'] ?? 0,
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
