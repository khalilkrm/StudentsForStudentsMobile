import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:student_for_student_mobile/apis/google_map_api.dart';

class MapStore extends ChangeNotifier {
  final GoogleMapApi _api;

  // Markers on the map
  final Set<Marker> markers = <Marker>{};
  final int _markerIdCounter = 1;

  // Polylines on the map
  final Set<Polyline> polylines = <Polyline>{};
  final int _polylineIdCounter = 1;

  // Current position inputs
  double currentLatitude = 0;
  double currentLongitude = 0;

  final Location _location = Location();

  String? error;

  StreamSubscription<LocationData>? _locationSubscription;

  void Function(LatLng)? _onUserPositionChanged;
  void Function(String)? _onErrorListeningUserPosition;

  MapStore({api}) : _api = api;

  Future<void> initialize(
    String destination,
    Completer<GoogleMapController> controller,
  ) async {
    var current = await _location.getLocation();

    currentLatitude = current.latitude ?? 0.0;
    currentLongitude = current.longitude ?? 0.0;

    var origin = await _getCurrentLatLngAsAddress(
      currentLatitude,
      currentLongitude,
    );

    var directions = await _getRoutesFromRemote(origin, destination);

    _onUserPositionChanged = (latlng) async {
      currentLatitude = latlng.latitude;
      currentLongitude = latlng.longitude;
      notifyListeners();
    };

    _onErrorListeningUserPosition = (error) async {
      debugPrint("Error listening user position: $error");
      _setError(error);
      notifyListeners();
    };

    _startListeningUserPosition(_location);

    _setPolylines(directions);
    _moveCameraToDirections(controller, directions);
    _setMarkers(LatLng(directions.latitude, directions.longitude));

    notifyListeners();
  }

  Future<String> _getCurrentLatLngAsAddress(latitude, longitude) async {
    return await latLngToAdress(latitude, longitude);
  }

  void _setMarkers(LatLng latLng) {
    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId(_nextMarkerId()),
        position: latLng,
      ),
    );
  }

  void _setError(String error) {
    this.error = error;
  }

  /// Listen to the current position of the user
  void _startListeningUserPosition(Location location) {
    var locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      _onUserPositionChanged?.call(LatLng(
        currentLocation.latitude ?? 0.0,
        currentLocation.longitude ?? 0.0,
      ));
    });

    locationSubscription.onError((error) {
      _onErrorListeningUserPosition?.call(error);
    });

    _locationSubscription = locationSubscription;
  }

  /// TODO rep works
  Future<Directions> _getRoutesFromRemote(
    String origin,
    String destination,
  ) async {
    var directions = await _api.getDirection(origin, destination);
    return Directions(
      latitude: directions['start_location']['lat'],
      longitude: directions['start_location']['lng'],
      boundsNe: directions['bounds_ne'],
      boundsSw: directions['bounds_sw'],
      polylines: PolylinePoints()
          .decodePolyline(directions['polyline'])
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList(),
    );
  }

  _setPolylines(Directions directions) {
    polylines.clear();
    polylines.add(
      Polyline(
        polylineId: PolylineId(_nextPolylineId()),
        width: 5,
        points: directions.polylines,
        color: Colors.blue,
      ),
    );
  }

  Future<void> _moveCameraToDirections(
    Completer<GoogleMapController> completer,
    Directions directions,
  ) async {
    final GoogleMapController controller = await completer.future;
    _setCameraPosition(
      completer,
      directions.latitude,
      directions.longitude,
    );
    _setCameraZoom(controller, directions.boundsSw, directions.boundsNe);
  }

  void _setCameraZoom(
    GoogleMapController controller,
    Map<String, dynamic> boundsSw,
    Map<String, dynamic> boundsNe,
  ) {
    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
          northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
        ),
        25));
  }

  Future<void> _setCameraPosition(
    Completer<GoogleMapController> completer,
    double latitude,
    double longitude,
  ) async {
    final GoogleMapController controller = await completer.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 14.4746,
        ),
      ),
    );
  }

  setCameraToCurrentPosition(controller) {
    _setCameraPosition(controller, currentLatitude, currentLongitude);
  }

  String _nextPolylineId() {
    return "polyline_id_$_polylineIdCounter";
  }

  String _nextMarkerId() {
    return "polyline_id_$_markerIdCounter";
  }

  void disposeFromListenCurrentLocation() {
    _locationSubscription?.cancel();
  }

  Future<String> latLngToAdress(double latitude, double longitude) async {
    return await _api.getAdressFromLatLng(latitude, longitude);
  }
}

class Directions {
  final double latitude;
  final double longitude;
  final List<LatLng> polylines;
  Map<String, dynamic> boundsNe;
  Map<String, dynamic> boundsSw;

  Directions({
    required this.latitude,
    required this.longitude,
    required this.boundsNe,
    required this.boundsSw,
    required this.polylines,
  });
}
