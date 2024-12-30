class LocationModel {
  final String userId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LocationModel({
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  // Convert from JSON (from API)
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      userId: json['userId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // Convert to JSON (to send to API)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
