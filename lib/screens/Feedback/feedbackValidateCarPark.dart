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

class CarParkScreen extends StatefulWidget {
  const CarParkScreen({super.key});

  @override
  State<CarParkScreen> createState() => _CarParkScreenState();
}

class _CarParkScreenState extends State<CarParkScreen> {
  double fIconOpac = 1;
  double sIconOpac = 1;
  double tIconOpac = 1;
  double buttonSelected = 0;

  @override
  Widget build(BuildContext context) {
    Map mapContext = ModalRoute.of(context)!.settings.arguments as Map;
    String textComment = "";
    Facility f = mapContext['Facility'];
    double lat = mapContext['lat'];
    double long = mapContext['long'];

    Future<void> insertFeedbackCarPark(double score, String ftype, String fsubtype, String text,
        double user_long, double user_lat, String id) async {
      int scoreInt = score.toInt();
      DateTime now = DateTime.now().toUtc();
      String formattedTime = now.toIso8601String();
      String? token = await context.read<User>().getAcessToken();
      token ??= "";

      Response response = await post(
        Uri.parse('http://${FlutterConfig.get('API_ADDRESS')}/api/feedback/carpark/validate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token!,
        },
        body: jsonEncode({
          "facility": id,
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

    return Scaffold(
      body: Column(
        children: [
          FacilityHeader(f: f),
          SizedBox(height: 20),
          CategorySelected(
              color: Color.fromRGBO(45, 207, 242, 1),
              icon: Image.asset(
                'assets/car-park.png',
                height: 45,
              )),
          Column(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    Text(
                      '     Report feedback ',
                      style: GoogleFonts.comfortaa(
                          textStyle: TextStyle(fontSize: 16),
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
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
                        SizedBox(height: 20),
                        Text('Full',
                            style: GoogleFonts.comfortaa(
                                textStyle: TextStyle(fontSize: 12),
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
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
                        SizedBox(height: 20),
                        Text('Half empty',
                            style: GoogleFonts.comfortaa(
                                textStyle: TextStyle(fontSize: 12),
                                color: Colors.black,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    SizedBox(
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
                                buttonSelected = 3;
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
                        SizedBox(height: 20),
                        Text('Empty',
                            style: GoogleFonts.comfortaa(
                                textStyle: TextStyle(fontSize: 12),
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ])
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Column(
            children: [],
          ),
          SizedBox(
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
                Text('Take a photo', style: TextStyle(fontSize: 18.0))
              ],
            ),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              height: 140,
              child: VerticalDivider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
            SizedBox(
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
                Text(
                  'Add comment',
                  style: TextStyle(fontSize: 18.0),
                )
              ],
            ),
          ]),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.cancel, color: Colors.white),
                label: Text('Cancel'),
                onPressed: () {
                  int count = 0;
                  Navigator.popUntil(context, (route) {
                    print(route.settings.name);
                    return count++ == 1;
                  });
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(140, 40),
                  backgroundColor: Colors.grey[700],
                ),
              ),
              SizedBox(
                width: 50,
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.send, color: Colors.white),
                label: Text('Send'),
                onPressed: () async {
                  int scoreInt = buttonSelected.toInt();
                  DateTime now = DateTime.now().toUtc();
                  String formattedTime = now.toIso8601String();

                  String? token = await context.read<User>().getAcessToken();
                  token ??= "";

                  Response response = await post(
                    Uri.parse(
                        'http://${FlutterConfig.get('API_ADDRESS')}/api/feedback/carpark/validate'),
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
                      "facility": f.asset_id
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
                  fixedSize: Size(140, 40),
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
