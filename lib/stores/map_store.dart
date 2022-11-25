import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:student_for_student_mobile/apis/google_map_api.dart';

class MapStore extends ChangeNotifier {
  final Set<Marker> markers = <Marker>{};
  final Set<Polyline> polylines = <Polyline>{};
  final GoogleMapApi _api;

  // Set Polylines inputs
  List<PointLatLng> polylineDecoded = <PointLatLng>[];

  // Go to place inputs
  Map<String, dynamic> boundsNe = <String, dynamic>{};
  Map<String, dynamic> boundsSw = <String, dynamic>{};
  double latitude = 0;
  double longitude = 0;

  // Current position inputs
  double currentPositionLatitude = 0;
  double currentPostionLongitude = 0;

  MapStore({api}) : _api = api;

  direction(String origin, String destination) async {
    // Send the input that view needs to set polylines and
    var directions = await _api.getDirection(origin, destination);

    latitude = directions['start_location']['lat'];
    longitude = directions['start_location']['lng'];
    boundsNe = directions['bounds_ne'];
    boundsSw = directions['bounds_sw'];

    polylineDecoded = directions['polyline_decoded'];
  }

  currentPosition() async {
    // var location = await _api.getCurrentPosition();
    currentPositionLatitude = 37.42796133580664;
    currentPostionLongitude = -122.085749655962;
  }
}
