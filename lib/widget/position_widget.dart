import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PositionWidget extends StatefulWidget {
  const PositionWidget({Key? key}) : super(key: key);

  @override
  State<PositionWidget> createState() => _PositionWidgetState();
}

class _PositionWidgetState extends State<PositionWidget> {
  Position? position;
  Set<Marker> markers = {};
  List<Polyline> polylines = [];

  void addPolyline() {
    // List<LatLng> decodedPath = polylinePoints.decodePolyline("dooBwouiUgDfB");
    String line = "~roBsluiU{BcB}@d@m@h@{BoDy@d@q@b@w@h@y@d@";
    List<PointLatLng> decodedPath = PolylinePoints().decodePolyline(line);
    List<LatLng> convertedPath = [];
    for (var point in decodedPath) {
      convertedPath.add(LatLng(point.latitude, point.longitude));
    }
    Polyline polyline = Polyline(
      polylineId: PolylineId('polyline'),
      points: convertedPath,
      color: Colors.blue,
      width: 10,
    );
    setState(() {
      polylines.add(polyline);
    });
  }

  void removeAllPolylines() {
    setState(() {
      polylines.clear();
    });
  }

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
        addPolyline();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (position == null) {
      return const Center(
          child: SizedBox(
              width: 100, height: 100, child: CircularProgressIndicator()));
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
        zoom: 17.0,
      ),
      markers: markers,
      mapType: MapType.satellite,
      polylines: Set<Polyline>.of(polylines),
    );
  }
}
