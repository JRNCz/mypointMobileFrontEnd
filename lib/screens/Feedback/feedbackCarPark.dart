import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:mypointfrontend/appData/provider/userdata.dart';
import 'package:mypointfrontend/widgets/facilityheader.dart';
import 'package:mypointfrontend/widgets/feedbackrelated.dart';

import 'package:mypointfrontend/appData/provider/rendermap.dart';
import 'package:provider/provider.dart';

class AddCarParkScreen extends StatefulWidget {
  const AddCarParkScreen({super.key});

  @override
  State<AddCarParkScreen> createState() => _AddCarParkScreenState();
}

class _AddCarParkScreenState extends State<AddCarParkScreen> {
  double fIconOpac = 1;
  double sIconOpac = 1;
  double tIconOpac = 1;
  double buttonSelected = 1;
  Future<void> insertFeedbackCarPark(double score, String ftype, String fsubtype, String text,
      double user_long, double user_lat) async {
    int scoreInt = score.toInt();
    DateTime now = DateTime.now().toUtc();
    String formattedTime = now.toIso8601String();

    String? token = await context.read<User>().getAcessToken();
    token ??= "";

    Response response = await post(
      Uri.parse('http://${FlutterConfig.get('API_ADDRESS')}/api/feedback/carpark'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token!,
      },
      body: jsonEncode({
        "feedback_category": ftype,
        "feedback_subcategory": fsubtype,
        "time_action": formattedTime,
        "score": scoreInt,
        "image_url": null,
        "text": text,
        "user_lat": user_lat,
        "user_lon": user_long,
      }),
    );
    var jsonData = jsonDecode(response.body);
    if (response.statusCode != 200) {
      print('error request');
      print(jsonData);
    } else {
      print('feedback inserted');
      print(jsonData);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map mapContext = ModalRoute.of(context)!.settings.arguments as Map;
    String textComment = "";
    double lat = mapContext['lat'];
    double long = mapContext['long'];
    Facility f = Facility(
        coordinates: LatLng(lat, long),
        asset_name: 'Car Park',
        asset_type: 'Car Park',
        asset_id: 'placeholder');
    print('a');
    print('a');
    print('a');

    return Scaffold(
      body: Column(
        children: [
          FacilityHeader(f: f),
          const SizedBox(height: 20),
          CategorySelected(
              color: const Color.fromRGBO(45, 207, 242, 1),
              icon: Image.asset(
                'assets/car-park.png',
                height: 45,
              )),
          Column(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    Text(
                      '     Report feedback ',
                      style: GoogleFonts.comfortaa(
                          textStyle: const TextStyle(fontSize: 16),
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          child: FloatingActionButton.large(
                            onPressed: () {
                              setState(() {
                                fIconOpac = 1;
                                buttonSelected = 1;
                                sIconOpac = 0.5;
                                tIconOpac = 0.5;
                              });
                            },
                            child: Image.asset(
                              'assets/crowd.png',
                              width: 40,
                              height: 40,
                            ),
                            backgroundColor: Color.fromRGBO(255, 0, 0, fIconOpac),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('Full',
                            style: GoogleFonts.comfortaa(
                                textStyle: const TextStyle(fontSize: 12),
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          child: FloatingActionButton.large(
                            onPressed: () {
                              setState(() {
                                fIconOpac = 0.5;
                                sIconOpac = 1;
                                tIconOpac = 0.5;
                                buttonSelected = 2;
                              });
                            },
                            child: Image.asset(
                              'assets/crowd.png',
                              width: 40,
                              height: 40,
                            ),
                            backgroundColor: Color.fromRGBO(255, 235, 59, sIconOpac),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('Half empty',
                            style: GoogleFonts.comfortaa(
                                textStyle: const TextStyle(fontSize: 12),
                                color: Colors.black,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                fIconOpac = 0.5;
                                sIconOpac = 0.5;
                                tIconOpac = 1;
                                buttonSelected = 5;
                              });
                            },
                            child: Image.asset(
                              'assets/crowd.png',
                              width: 40,
                              height: 40,
                            ),
                            backgroundColor: Color.fromRGBO(76, 175, 80, tIconOpac),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('Empty',
                            style: GoogleFonts.comfortaa(
                                textStyle: const TextStyle(fontSize: 12),
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ])
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Column(
            children: [],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                IconButton(
                  iconSize: 100,
                  icon: Image.asset(
                    'assets/photo-camera.png',
                    width: 100,
                    height: 100,
                  ),
                  onPressed: () {
                    // do something when the button is pressed
                    debugPrint('Hi there');
                  },
                ),
                const Text('Take a photo', style: TextStyle(fontSize: 18.0))
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            const SizedBox(
              height: 140,
              child: VerticalDivider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              children: [
                IconButton(
                  iconSize: 100,
                  icon: Image.asset(
                    'assets/comment.png',
                  ),
                  onPressed: () async {
                    // do something when the button is pressed
                    setState(() async {
                      textComment = await Navigator.pushNamed(context, '/comment') as String;
                    });
                  },
                ),
                const Text(
                  'Add comment',
                  style: TextStyle(fontSize: 18.0),
                )
              ],
            ),
          ]),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.cancel, color: Colors.white),
                label: const Text('Cancel'),
                onPressed: () {
                  int count = 0;
                  Navigator.popUntil(context, (route) {
                    print(route.settings.name);
                    return count++ == 1;
                  });
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(140, 40),
                  backgroundColor: Colors.grey[700],
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text('Send'),
                onPressed: () async {
                  int scoreInt = buttonSelected.toInt();
                  DateTime now = DateTime.now().toUtc();
                  String formattedTime = now.toIso8601String();

                  String? token = await context.read<User>().getAcessToken();
                  token ??= "";

                  Response response = await post(
                    Uri.parse('http://${FlutterConfig.get('API_ADDRESS')}/api/feedback/carpark'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization': 'Bearer ' + token!,
                    },
                    body: jsonEncode({
                      "feedback_category": 'Quality of Service',
                      "feedback_subcategory": 'Occupation',
                      "time_action": formattedTime,
                      "score": scoreInt,
                      "image_url": null,
                      "text": textComment,
                      "user_lat": lat,
                      "user_lon": long,
                    }),
                  );
                  var jsonData = jsonDecode(response.body);
                  if (response.statusCode == 200) {
                    print('feedback  inserted');
                    Navigator.pushNamed(context, '/feedback/carpark/add/thankyou', arguments: {
                      'color': const Color.fromRGBO(45, 207, 242, 1),
                      'icon': Image.asset(
                        'assets/car-park.png',
                        height: 45,
                      ),
                      'Facility': Facility(
                          asset_id: 'feedback_facility',
                          asset_name: 'Car Park',
                          coordinates: const LatLng(
                            -10,
                            10,
                          ),
                          asset_type: 'Car Park'),
                      'fstype': 'Occupation',
                      'login': true,
                      'points': jsonData['points_added']
                    });
                  } else {
                    print('feedback not inserted');
                    Navigator.pushNamed(context, '/feedback/carpark/add/thankyou', arguments: {
                      'color': const Color.fromRGBO(45, 207, 242, 1),
                      'icon': Image.asset(
                        'assets/car-park.png',
                        height: 45,
                      ),
                      'Facility': Facility(
                          asset_id: 'feedback_facility',
                          asset_name: 'Car Park',
                          coordinates: const LatLng(
                            -10,
                            10,
                          ),
                          asset_type: 'Car Park'),
                      'fstype': 'Occupation',
                      'login': false,
                      'points': '0'
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(140, 40),
                  backgroundColor: Colors.green[700],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
