import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:mypointfrontend/appData/provider/rendermap.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final List<Facility> facilities = [];

  Future<void> getData() async {
    print('request incoming');
    Response response =
        await get(Uri.parse('http://${FlutterConfig.get('API_ADDRESS')}/api/facilities'));
    List jsonData = jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: false));
    for (final json in jsonData) {
      LatLng coordinates;
      try {
        coordinates = LatLng(json['latitude'], json['longitude']);
      } catch (e) {
        coordinates = LatLng(0, 0);
      }
      final facility = Facility(
          coordinates: coordinates,
          asset_name: json['stop_name'],
          asset_type: (json['asset_type'] != null && json['asset_type'].isNotEmpty)
              ? json['asset_type'].first
              : "",
          asset_id: json['asset_id']);
      facilities.add(facility);
    }
    print(jsonData);
    if (response.statusCode == 200) {
      await Navigator.pushNamed(context, '/home', arguments: facilities);
      facilities.clear();
      updateInformation();

      // update the information
    }
  }

  void updateInformation() {
    getData();
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  Widget build(BuildContext context) {
    print('VVVVVVVilt');

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 238, 238, 238),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpinKitWave(
              color: Color.fromARGB(255, 127, 127, 127),
              size: 50.0,
            ),
            SizedBox(
              height: 60,
            ),
            Text(
              'Mypoint',
              style: TextStyle(fontSize: 20),
            )
          ],
        ));
  }
}
