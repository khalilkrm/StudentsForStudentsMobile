import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/stores/map_store.dart';

class MapPage extends StatefulWidget {
  final String _destination;

  const MapPage({super.key, required destination}) : _destination = destination;

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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void didChangeDependencies() {
    _mapStore ??= Provider.of<MapStore>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _mapStore?.disposeFromListenCurrentLocation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapStore>(
      builder: (context, store, child) => Scaffold(
        body: Stack(children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: store.markers,
            polylines: store.routes,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  store.userPositionLatitude, store.userPositionLongitude),
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: ClipOval(
            child: Material(
              color: Colors.white, // button color
              child: InkWell(
                splashColor: Colors.grey, // inkwell color
                child: const SizedBox(
                    width: 56, height: 56, child: Icon(Icons.arrow_back)),
                onTap: () async {
                  Navigator.pop(context);
                },
              ),
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
