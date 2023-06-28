import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mypointfrontend/appData/provider/userdata.dart';
import 'package:mypointfrontend/widgets/feedbackrelated.dart';

import 'package:mypointfrontend/appData/provider/rendermap.dart';
import 'package:provider/provider.dart';

class FeedbackMainScreen extends StatefulWidget {
  const FeedbackMainScreen({super.key});

  @override
  State<FeedbackMainScreen> createState() => _FeedbackMainScreenState();
}

class _FeedbackMainScreenState extends State<FeedbackMainScreen> {
  Future<void> insertFeedback(double score, Facility f, String ftype, String fsubtype, String text,
      double user_long, double user_lat) async {
    print(ftype);
    print(fsubtype);
    int scoreInt = score.toInt();
    DateTime now = DateTime.now().toUtc();
    String formattedTime = now.toIso8601String();

    Response response = await post(
      Uri.parse('http://${FlutterConfig.get('API_ADDRESS')}/api/feedback/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "feedback_category": ftype,
        "feedback_subcategory": fsubtype,
        "time_action": formattedTime,
        "score": scoreInt,
        "image_url": null,
        "text": text,
        "facility": f.asset_id,
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
    String textComment = "";
    Map m = ModalRoute.of(context)!.settings.arguments as Map;
    Facility f = m['Facility'];
    double user_lat = m['lat'];
    double user_log = m['long'];
    List<dynamic> times = [];
    bool setInformation = false;
    int len = 0;

    try {
      times = m['times'];
      setInformation = true;
      len = times.length;
    } catch (e) {
      print('Facility has no information');
      setInformation = false;
      len = times.length;
      if (times.length > 6) {
        len = 6;
      }
    }
    double rating = 0;
    return Scaffold(
        body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
              child: SizedBox(
                width: 35,
                height: 25,
                child: IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 124, 124, 124)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Container(padding: const EdgeInsets.fromLTRB(25, 80, 0, 0), child: FacilityInfo(f: f)),
          ],
        ),
        SizedBox(height: 20),
        CategorySelected(
            color: Colors.grey,
            icon: Image.asset(
              'assets/general.png',
              width: 40,
              height: 40,
            )),
        SizedBox(height: 20),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '     Report general feedback',
            style: GoogleFonts.comfortaa(
                textStyle: TextStyle(fontSize: 16), color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        RatingBar.builder(
          initialRating: 0,
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 4,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (ratingnow) {
            print(ratingnow);
            rating = ratingnow;
          },
        ),
        SizedBox(height: 30),
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
                DateTime now = DateTime.now().toUtc();
                String formattedTime = now.toIso8601String();
                String? token = await context.read<User>().getAcessToken();
                token ??= "";

                Response response = await post(
                  Uri.parse('http://${FlutterConfig.get('API_ADDRESS')}/api/feedback/'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': 'Bearer ' + token!
                  },
                  body: jsonEncode({
                    "feedback_category": 'General',
                    "feedback_subcategory": 'Classification',
                    "time_action": formattedTime,
                    "score": rating.toInt(),
                    "image_url": null,
                    "text": textComment,
                    "facility": f.asset_id,
                    "user_lat": user_lat,
                    "user_lon": user_log,
                  }),
                );
                var jsonData = jsonDecode(response.body);
                print(jsonData);
                print(jsonData['points_added'] != '0');
                print(jsonData['points_added']);
                if (response.statusCode == 200 && jsonData['points_added'] != '0') {
                  print('feedback  inserted');
                  Navigator.pushNamed(context, '/feedback', arguments: {
                    'Facility': f,
                    'lat': user_lat,
                    'long': user_log,
                    'login': true,
                    'points': jsonData['points_added'],
                  });
                } else if (response.statusCode == 200 && jsonData['points_added'] == '0') {
                  Navigator.pushNamed(context, '/feedback', arguments: {
                    'Facility': f,
                    'lat': user_lat,
                    'long': user_log,
                    'login': false,
                    'points': '0',
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Error creating feedback \n'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              int count = 0;
                              Navigator.popUntil(context, (route) {
                                print(route.settings.name);
                                return count++ == 2;
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(140, 40),
                backgroundColor: Colors.green[700],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: len,
            itemBuilder: (context, index) {
              print(times[index]);
              return Card(
                elevation: 0.0, // Set elevation to 0.0 to remove shadows
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0), // Customize border radius as needed
                ),
                margin: EdgeInsets.all(0.0), // Remove default card margin
                color: Colors.transparent, // Set card color to transparent
                child: ListTile(
                  onTap: () {},
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/bus.png',
                      fit: BoxFit.cover, // Adjust the fit property as needed
                    ),
                  ),
                  title: Text(times[index]['route_short_name'] + ' ' + times[index]['route_long_name']),
                  isThreeLine: false,
                  subtitle: Text(times[index]['arrival_time']),
                ),
              );
            },
          ),
        ),
      ],
    ));
  }
}
