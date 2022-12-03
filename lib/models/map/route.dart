import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:student_for_student_mobile/models/map/route_location.dart';

class Route {
  final LocationPoint startLocation;
  final LocationPoint endLocation;
  final LocationPoint northeastBounds;
  final LocationPoint southwestBounds;
  final List<LocationPoint> points;

  Route({
    required this.startLocation,
    required this.endLocation,
    required this.northeastBounds,
    required this.southwestBounds,
    required this.points,
  });

  static fromJson(Map<String, dynamic> json) {
    final List<dynamic> routes = json['routes'];

    if (routes.isEmpty) {
      throw Exception("No route found");
    }

    return Route(
      startLocation: LocationPoint.fromJson(
          json['routes'][0]['legs'][0]['start_location']),
      endLocation:
          LocationPoint.fromJson(json['routes'][0]['legs'][0]['end_location']),
      northeastBounds:
          LocationPoint.fromJson(json['routes'][0]['bounds']['northeast']),
      southwestBounds:
          LocationPoint.fromJson(json['routes'][0]['bounds']['southwest']),
      points: PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points'])
          .map((point) => LocationPoint(
                latitude: point.latitude,
                longitude: point.longitude,
              ))
          .toList(),
    );
  }
}
