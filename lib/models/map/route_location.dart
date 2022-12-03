class LocationPoint {
  final double latitude;
  final double longitude;

  LocationPoint({
    required this.latitude,
    required this.longitude,
  });

  static LocationPoint fromJson(Map<String, dynamic> json) {
    return LocationPoint(
      latitude: json['lat'],
      longitude: json['lng'],
    );
  }
}
