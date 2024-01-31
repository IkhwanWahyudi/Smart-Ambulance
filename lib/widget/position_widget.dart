import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PositionWidget extends StatefulWidget {
  const PositionWidget({Key? key}) : super(key: key);

  @override
  State<PositionWidget> createState() => _PositionWidgetState();
}

class _PositionWidgetState extends State<PositionWidget> {
  Position? position;
  Set<Marker> markers = {};

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _determinePosition().then((value) {
      setState(() {
        position = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (position == null) {
      return const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator())
        );
    }

    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position!.latitude, position!.longitude),
        infoWindow: const InfoWindow(
          title: 'Lokasi saat ini!',
        ),
      ),
    );

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(position!.latitude, position!.longitude),
        zoom: 16.0,
      ),
      markers: markers,
    );
  }
}
