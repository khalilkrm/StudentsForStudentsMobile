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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var store = Provider.of<MapStore>(context, listen: false);
      store.initialize(widget._destination, _controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapStore>(
      builder: (context, store, child) => Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          markers: store.markers,
          polylines: store.polylines,
          initialCameraPosition: CameraPosition(
            target: LatLng(store.currentLatitude, store.currentLongitude),
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
              onTap: () {
                store.setCameraToCurrentPosition(_controller);
              },
            ),
          ),
        ),
      ),
    );
  }
}
