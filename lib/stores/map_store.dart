import 'dart:async';

import 'package:flutter/material.dart' as material;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:student_for_student_mobile/repositories/google_map_repository.dart';

class MapStore extends material.ChangeNotifier {
  final GoogleMapRepository _repository;

  // Markers on the map
  final Set<Marker> markers = <Marker>{};
  final int _markerIdCounter = 1;

  // Polylines on the map
  final Set<Polyline> polylines = <Polyline>{};
  final int _polylineIdCounter = 1;

  // Current position inputs
  double userPositionLatitude = 0;
  double userPositionLongitude = 0;

  final Location _location = Location();

  String? error;

  StreamSubscription<LocationData>? _locationSubscription;

  void Function(LatLng)? _onUserPositionChanged;
  void Function(String)? _onErrorListeningUserPosition;

  MapStore({required GoogleMapRepository repository})
      : _repository = repository;

  Future<void> initialize(
    String destination,
    Completer<GoogleMapController> controller,
  ) async {
    // TODO Ask for permission to use location

    // TODO Catch error of permission
    var userPosition = await _location.getLocation();

    userPositionLatitude = userPosition.latitude ?? 0.0;
    userPositionLongitude = userPosition.longitude ?? 0.0;

    var origin = await _getCurrentLatLngAsAddress(
      userPositionLatitude,
      userPositionLongitude,
    );

    var route = await _getRoute(origin, destination);

    _onUserPositionChanged = (latlng) async {
      userPositionLatitude = latlng.latitude;
      userPositionLongitude = latlng.longitude;
      notifyListeners();
    };

    _onErrorListeningUserPosition = (error) async {
      material.debugPrint("Error listening user position: $error");
      _setError(error);
      notifyListeners();
    };

    _startListeningUserPosition(_location);

    _setPoints(route);

    _setMarkers([
      LatLng(
        route.startLocation.latitude,
        route.startLocation.longitude,
      ),
      LatLng(
        route.endLocation.latitude,
        route.endLocation.longitude,
      ),
    ]);

    _moveCameraAboveRoute(controller, route);

    notifyListeners();
  }

  // --------------------------------
  // Store methods
  // --------------------------------

  void _setError(String error) {
    this.error = error;
  }

  /// Listen to the current position of the user
  void _startListeningUserPosition(Location location) {
    var locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      _onUserPositionChanged!.call(LatLng(
        currentLocation.latitude ?? 0.0,
        currentLocation.longitude ?? 0.0,
      ));
    });

    locationSubscription.onError((error) {
      _onErrorListeningUserPosition!.call(error);
    });

    _locationSubscription = locationSubscription;
  }

  // --------------------------------
  // Drawing on the map methods
  // --------------------------------

  Future<void> setCameraToCurrentPosition(controller) async {
    await _setCameraPosition(
        controller, userPositionLatitude, userPositionLongitude);
  }

  /// Set the route on the array listened by the map
  void _setPoints(Route route) {
    polylines.clear();
    polylines.add(
      Polyline(
        polylineId: PolylineId(_nextPolylineId()),
        width: 5,
        points: route.points,
        color: material.Colors.blue,
      ),
    );
  }

  /// Set the markers on the array listened by the map
  /// Markers are the start and the end of the route
  void _setMarkers(List<LatLng> latLngs) {
    markers.clear();
    markers.addAll(latLngs.map(
      (latLng) => Marker(
        markerId: MarkerId(_nextMarkerId()),
        position: latLng,
      ),
    ));
  }

  Future<void> _moveCameraAboveRoute(
    Completer<GoogleMapController> completer,
    Route route,
  ) async {
    final GoogleMapController controller = await completer.future;
    _setCameraPosition(
      completer,
      route.startLocation.latitude,
      route.startLocation.longitude,
    );
    _setCameraZoom(controller, route.southwestBounds, route.northeastBounds);
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

  String _nextPolylineId() {
    return "polyline_id_$_polylineIdCounter";
  }

  String _nextMarkerId() {
    return "polyline_id_$_markerIdCounter";
  }

  // --------------------------------
  // Fetching data methods
  // --------------------------------

  /// Get routes from an origin to a destination
  Future<Route> _getRoute(
    String origin,
    String destination,
  ) async {
    return await _repository.getRoute(origin, destination);
  }

  Future<String> _getCurrentLatLngAsAddress(
      double latitude, double longitude) async {
    return await _repository.fetchAdressFromLatLng(latitude, longitude);
  }

  // --------------------------------
  // Dispose methods
  // --------------------------------

  void disposeFromListenCurrentLocation() {
    _locationSubscription?.cancel();
  }
}
