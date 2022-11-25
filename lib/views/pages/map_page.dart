import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/stores/map_store.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  int _polylineIdCounter = 1;

  final Set<Marker> _markers = <Marker>{};
  final Set<Polyline> _polylines = <Polyline>{};

  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    var store = Provider.of<MapStore>(context, listen: false);
    store.currentPosition();
    _setMarkers(LatLng(
      store.currentPositionLatitude,
      store.currentPostionLongitude,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapStore>(
      builder: (context, store, child) => Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          markers: _markers,
          polylines: _polylines,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              store.currentPositionLatitude,
              store.currentPostionLongitude,
            ),
            zoom: 14.4746,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async => await _position(store),
          label: const Text('To the lake!'),
          icon: const Icon(Icons.directions_boat),
        ),
      ),
    );
  }

  Future<void> _position(MapStore store) async {
    await store.direction('Milan', 'Paris');

    _goToPlace(
      store.latitude,
      store.longitude,
      store.boundsNe,
      store.boundsSw,
    );
    _setPolyline(store.polylineDecoded);
  }

  Future<void> _goToPlace(
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 14.4746,
        ),
      ),
    );
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
          ),
          25),
    );
    _setMarkers(LatLng(lat, lng));
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineVal),
        consumeTapEvents: true,
        color: Colors.blue,
        width: 5,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }

  void _setMarkers(LatLng latLng) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId("marker"),
          position: latLng,
        ),
      );
    });
  }
}
