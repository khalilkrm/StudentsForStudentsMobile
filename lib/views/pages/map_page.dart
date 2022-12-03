import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/stores/map_store.dart';

class MapPage extends StatefulWidget {
  final String _destination;

  const MapPage({super.key, destination}) : _destination = destination;

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  MapStore? _mapStore;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var store = Provider.of<MapStore>(context, listen: false);
      store.onError(() => _showErrorDialog());
      store.initialize(widget._destination, _controller);
    });
  }

  @override
  void didChangeDependencies() {
    _mapStore ??= Provider.of<MapStore>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _mapStore?.disposeFromListenCurrentLocation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapStore>(
      builder: (context, store, child) => Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          markers: store.markers,
          polylines: store.routes,
          initialCameraPosition: CameraPosition(
            target:
                LatLng(store.userPositionLatitude, store.userPositionLongitude),
            zoom: 14.4746,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: ClipOval(
          child: Material(
            color: Colors.white, // button color
            child: InkWell(
              splashColor: Colors.grey, // inkwell color
              child: const SizedBox(
                  width: 56, height: 56, child: Icon(Icons.my_location)),
              onTap: () async {
                await store.setCameraToCurrentPosition(_controller);
              },
            ),
          ),
        ),
      ),
    );
  }

  _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(_mapStore?.error ?? "Unknown error"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
