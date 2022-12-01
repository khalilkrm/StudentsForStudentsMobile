import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:student_for_student_mobile/apis/google_map_api.dart';

class GoogleMapRepository {
  final GoogleMapApi _api;

  GoogleMapRepository({required GoogleMapApi api}) : _api = api;

  Future<Route> getRoute(
    String origin,
    String destination,
  ) async {
    var json = await _api.fetchDirection(origin, destination);
    return Route.fromJson(json);
    // var results = _simplifyDirectionResult(directions);
    // return Route(
    //   startLocation: Location(
    //       latitude: results['start_location']['lat'],
    //       longitude: results['start_location']['lng']),
    //   endLocation: Location(
    //       latitude: results['end_location']['lat'],
    //       longitude: results['end_location']['lng']),
    //   boundsNe: results['bounds_ne'],
    //   boundsSw: results['bounds_sw'],
    //   points: PolylinePoints()
    //       .decodePolyline(directions['polyline'])
    //       .map((point) => LatLng(point.latitude, point.longitude))
    //       .toList(),
    // );
  }

  Future<String> fetchAdressFromLatLng(
      double latitude, double longitude) async {
    final Map<String, dynamic> data =
        await _api.fetchAdressFromLatLng(latitude, longitude);
    final List<dynamic> results = data['results'];
    if (results.isNotEmpty) {
      final String address = results[0]['formatted_address'];
      return address;
    } else {
      throw Exception("No place found");
    }
  }

  // Map<String, dynamic> _simplifyDirectionResult(Map<String, dynamic> result) {
  //   return {
  //     'start_location': result['routes'][0]['legs'][0]['start_location'],
  //     'end_location': result['routes'][0]['legs'][0]['end_location'],
  //     'bounds_sw': result['routes'][0]['bounds']['southwest'],
  //     'bounds_ne': result['routes'][0]['bounds']['northeast'],
  //     'points': result['routes'][0]['overview_polyline']['points'],
  //   };
  // }
}

class Route {
  final RouteLocation startLocation;
  final RouteLocation endLocation;
  final Map<String, dynamic> northeastBounds;
  final Map<String, dynamic> southwestBounds;
  final List<LatLng> points;

  Route({
    required this.startLocation,
    required this.endLocation,
    required this.northeastBounds,
    required this.southwestBounds,
    required this.points,
  });

  static fromJson(Map<String, dynamic> json) {
    return Route(
      startLocation: RouteLocation.fromJson(
          json['routes'][0]['legs'][0]['start_location']),
      endLocation:
          RouteLocation.fromJson(json['routes'][0]['legs'][0]['end_location']),
      northeastBounds: json['routes'][0]['bounds']['northeast'],
      southwestBounds: json['routes'][0]['bounds']['southwest'],
      points: PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points'])
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList(),
    );
  }
}

class RouteLocation {
  final double latitude;
  final double longitude;

  RouteLocation({
    required this.latitude,
    required this.longitude,
  });

  static RouteLocation fromJson(Map<String, dynamic> json) {
    return RouteLocation(
      latitude: json['lat'],
      longitude: json['lng'],
    );
  }
}
