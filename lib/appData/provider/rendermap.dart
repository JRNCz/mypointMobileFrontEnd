import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RenderMap extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String error = '';
  late GoogleMapController _mapsController;
  Set<Marker> markers = <Marker>{};

  RenderMap() {
    getPosition();
  }

  get MapController => _mapsController;

  Future<Position> onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    return getPosition();
  }

  void RenderFacility(element, imageurl, context) async {
    markers.add(
      Marker(
        markerId: MarkerId(element.asset_name),
        position: element.coordinates,
        onTap: () {
          Navigator.pushNamed(context, '/feedback', arguments: element);
        },
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(3, 3), devicePixelRatio: 1.0),
          imageurl,
        ),
      ),
    );
  }

  loadFacilities(List<Facility> facilities, context) {
    facilities.forEach((element) async {
      if (element.asset_type == 'Bus stop') {
        RenderFacility(element, 'assets/bus-stop.png', context);
      }
      if (element.asset_type == 'Tram, Streetcar, Light rail station') {
        RenderFacility(element, 'assets/carpark.png', context);
      }
    });
  }

  Future<Position> getPosition() async {
    try {
      Position p = await currentPos();
      lat = p.latitude;
      long = p.longitude;
      _mapsController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
      notifyListeners();
      return p;
    } catch (e) {
      error = e.toString();
      throw Exception('Failed to get position');
    }
  }

  Future<Position> currentPos() async {
    LocationPermission perm;

    // Check if location is enabled
    bool activated = await Geolocator.isLocationServiceEnabled();
    if (!activated) return Future.error('Please activate location');

    // Check if permissions are enabled
    perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        Future.error("Please activate access to location");
      }
    }

    //Check if user has permission of denied forever
    if (perm == LocationPermission.deniedForever) {
      Future.error("Please activate access to location");
    }

    return await Geolocator.getCurrentPosition();
  }
}

class Facility extends ClusterItem {
  late LatLng coordinates;
  String asset_name = "";
  String asset_type = "";
  String asset_id = "";

  Facility(
      {required this.coordinates,
      required this.asset_name,
      required this.asset_type,
      required this.asset_id});

  @override
  // TODO: implement location
  LatLng get location => coordinates;
}
