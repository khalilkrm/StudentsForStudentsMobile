import 'dart:async';

import 'package:flutter/material.dart' as material;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:student_for_student_mobile/models/map/route.dart';
import 'package:student_for_student_mobile/models/map/route_location.dart';
import 'package:student_for_student_mobile/repositories/google_map_repository.dart';

class MapStore extends material.ChangeNotifier {
  final GoogleMapRepository _repository;

  // Markers on the map
  final Set<Marker> markers = <Marker>{};
  int _markerIdCounter = 1;

  // Polylines on the map
  final Set<Polyline> routes = <Polyline>{};
  int _polylineIdCounter = 1;

  // Current position inputs
  double userPositionLatitude = 0;
  double userPositionLongitude = 0;

  final Location _location = Location();

  bool isError = false;
  String? error;
  Function _onError = () {};

  StreamSubscription<LocationData>? _locationSubscription;

  void Function(LatLng)? _onUserPositionChanged;
  void Function(String)? _onErrorListeningUserPosition;

  MapStore({required GoogleMapRepository repository})
      : _repository = repository;

  Future<void> initialize(
    String destination,
    Completer<GoogleMapController> controller,
  ) async {
    try {
      var userPosition = await _location.getLocation();
      userPositionLatitude = userPosition.latitude ?? 0.0;
      userPositionLongitude = userPosition.longitude ?? 0.0;
    } on Exception catch (e) {
      _setError("Unexpected error while initializing map : ${e.toString()}");
      material.debugPrint(
          "ERROR: error while getting user position: '${e.toString()}'");
      notifyListeners();
      return;
    }

    String origin;

    try {
      origin = await _getCurrentLatLngAsAddress(
        userPositionLatitude,
        userPositionLongitude,
      );
    } on Exception catch (e) {
      _setError("Unexpected error while initializing map : ${e.toString()}");
      material.debugPrint(
          "ERROR: error while getting current lat log as address: '${e.toString()}'");
      notifyListeners();
      return;
    }

    Route route;

    try {
      route = await _getRoute(origin, destination);
    } on Exception catch (e) {
      _setError("Unexpected error while initializing map : ${e.toString()}");
      material
          .debugPrint("ERROR: error while getting route: '${e.toString()}'");
      notifyListeners();
      return;
    }

    _onUserPositionChanged = (latlng) async {
      userPositionLatitude = latlng.latitude;
      userPositionLongitude = latlng.longitude;
      notifyListeners();
    };

    _onErrorListeningUserPosition = (error) async {
      material
          .debugPrint("Error listening user position: '${error.toString()}'");
      _setError(error);
      notifyListeners();
    };

    try {
      _startListeningUserPosition(_location);
    } on Exception catch (e) {
      _setError("Unexpected error while initializing map : ${e.toString()}");
      material.debugPrint(
          "ERROR: error while listening user position: '${e.toString()}'");
      notifyListeners();
      return;
    }

    try {
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
    } on Exception catch (e) {
      _setError("Unexpected error while initializing map : ${e.toString()}");
      material
          .debugPrint("ERROR: error while adding markers: '${e.toString()}'");
      notifyListeners();
      return;
    }

    try {
      _setPoints(route);
    } on Exception catch (e) {
      _setError("Unexpected error while initializing map : ${e.toString()}");
      material
          .debugPrint("ERROR: error while adding polylines: '${e.toString()}'");
      notifyListeners();
      return;
    }

    try {
      _moveCameraAboveRoute(controller, route);
    } on Exception catch (e) {
      _setError("Unexpected error while initializing map : ${e.toString()}");
      material
          .debugPrint("ERROR: error while moving camera: '${e.toString()}'");
      notifyListeners();
      return;
    }

    notifyListeners();
  }

  // --------------------------------
  // Store methods
  // --------------------------------

  void _setError(String error) {
    isError = true;
    this.error = error;
    _onError();
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
    routes.clear();
    routes.add(
      Polyline(
        polylineId: PolylineId(_nextPolylineId()),
        width: 5,
        points: route.points
            .map((e) => LatLng(
                  e.latitude,
                  e.longitude,
                ))
            .toList(),
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
    LocationPoint southwestBounds,
    LocationPoint northeastBounds,
  ) {
    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest:
              LatLng(southwestBounds.latitude, southwestBounds.longitude),
          northeast:
              LatLng(northeastBounds.latitude, northeastBounds.longitude),
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
    return "polyline_id_${_polylineIdCounter++}";
  }

  String _nextMarkerId() {
    return "marker_id_${_markerIdCounter++}";
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

  // --------------------------------
  // Setters
  // --------------------------------

  void onError(Function() onError) {
    _onError = onError;
  }
}
