import 'dart:async';
import 'dart:convert' as convert;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:mypointfrontend/widgets/buttons.dart';
import 'package:mypointfrontend/widgets/sidemenu.dart';
import 'package:provider/provider.dart';
import 'package:mypointfrontend/appData/provider/rendermap.dart';

// Clustering maps

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late ClusterManager _manager;
  List<Facility> args = [];
  Completer<GoogleMapController> _controller = Completer();
  double lat = 0.0;
  double long = 0.0;

  Set<Marker> markers = Set();

  @override
  void initState() {
    _manager = _initClusterManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (args.isNotEmpty) {
      args = args;
    } else {
      args = ModalRoute.of(context)!.settings.arguments as List<Facility>;
      if (args.isNotEmpty) {
        List<Facility> clean = [];
        _manager.setItems(clean);
        for (var item in args) _manager.setItems(args);
      }
    }

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        drawer: SideMenu(_manager, args),
        body: ChangeNotifierProvider<RenderMap>(
          create: (context) => RenderMap(), // (context) => RenderMap()
          child: Builder(
            builder: (context) {
              final local = context.watch<RenderMap>();
              return Stack(
                children: [
                  GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(local.lat, local.long),
                        zoom: 15,
                      ),
                      markers: markers,
                      zoomControlsEnabled: true,
                      padding: EdgeInsets.only(top: 40.0, right: 10),
                      myLocationEnabled: true,
                      onMapCreated: (GoogleMapController controller) async {
                        Position p = await local.onMapCreated(controller);
                        _controller.complete(controller);
                        _manager.setMapId(controller.mapId);

                        lat = p.latitude;
                        long = p.longitude;
                      },
                      onCameraMove: _manager.onCameraMove,
                      onCameraIdle: _manager.updateMap),
                  ScanFacilityButton(context, local, args),
                  AddCarParkButton(lat: lat, long: long),
                  const RefreshMapButton(),
                  const OpenMenu(),
                ],
              );
            },
          ),
        ));
  }

  Future<Marker> Function(Cluster<Facility>) get _markerBuilder => (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () async {
            if (!cluster.isMultiple) {
              // request agora
              // para um endpoint para retirar todos os proximos buses
              // request para api/busstop/<id>
              if (cluster.items.first.asset_type == 'Bus stop') {
                Response response = await get(
                  Uri.parse('http://${FlutterConfig.get('API_ADDRESS')}/api/busstop/information/' +
                      cluster.items.first.asset_id),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                );
                var jsonData = convert.jsonDecode(response.body);
                print(jsonData.runtimeType);
                if (response.statusCode == 200) {
                  Navigator.pushNamed(context, '/feedback/placeholder', arguments: {
                    'Facility': cluster.items.first,
                    'lat': lat,
                    'long': long,
                    'times': jsonData
                  });
                } else {
                  Navigator.pushNamed(context, '/feedback/placeholder', arguments: {
                    'Facility': cluster.items.first,
                    'lat': lat,
                    'long': long,
                  });
                }
              }
              if (cluster.items.first.asset_type == 'Car Park') {
                Navigator.pushNamed(context, '/feedback/carpark', arguments: {
                  'Facility': cluster.items.first,
                  'lat': lat,
                  'long': long,
                });
              }
              if (cluster.items.first.asset_type == 'Mobility Station') {
                Navigator.pushNamed(context, '/feedback/placeholder', arguments: {
                  'Facility': cluster.items.first,
                  'lat': lat,
                  'long': long,
                });
              }
            }
          },
          icon: await _getMarkerBitmap(
              cluster.isMultiple ? 60 : 60, cluster.isMultiple ? true : false, cluster.items.first,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };

  ClusterManager _initClusterManager() {
    return ClusterManager<Facility>(
      args,
      _updateMarkers,
      markerBuilder: _markerBuilder,
      stopClusteringZoom: 16,
      extraPercent: 0.5,
    );
  }

  void _updateMarkers(Set<Marker> markers) {
    // print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<BitmapDescriptor> _getMarkerBitmap(
    int size,
    bool multiple,
    Facility facilitiy, {
    String? text,
  }) async {
    if (!multiple) {
      if (facilitiy.asset_type == 'Bus stop') {
        final Uint8List markerIcon = await getBytesFromAsset('assets/bus-stop.png', 45);
        return BitmapDescriptor.fromBytes(markerIcon);
      }
      if (facilitiy.asset_type == 'Car Park') {
        final Uint8List markerIcon = await getBytesFromAsset('assets/car-park.png', 45);
        return BitmapDescriptor.fromBytes(markerIcon);
      }
      if (facilitiy.asset_type == 'Mobility Station') {
        final Uint8List markerIcon = await getBytesFromAsset('assets/mobility-station.png', 45);
        return BitmapDescriptor.fromBytes(markerIcon);
      }
    }
    if (kIsWeb) size = (size / 2).floor();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5) // Shadow color and opacity
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5.0); // Shadow blur and spread radius
    final Paint paint1 = Paint()..color = Colors.white;
    final Paint paint2 = Paint()..color = Colors.black;

    // Draw shadow
    canvas.drawCircle(Offset(size / 2 + 2, size / 2 + 2), size / 2.8, shadowPaint);

    // Draw circles
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size / 3,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
}
