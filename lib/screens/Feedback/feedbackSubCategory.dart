import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mypointfrontend/widgets/facilityheader.dart';
import 'package:mypointfrontend/widgets/feedbackrelated.dart';

import 'package:mypointfrontend/appData/provider/rendermap.dart';
import 'package:provider/provider.dart';

import '../../appData/provider/userdata.dart';

class FeedSubCatScreen extends StatefulWidget {
  const FeedSubCatScreen({super.key});

  @override
  State<FeedSubCatScreen> createState() => _FeedSubCatScreenState();
}

class _FeedSubCatScreenState extends State<FeedSubCatScreen> {
  Future<bool> insertFeedback(double score, Facility f, String ftype, String fsubtype, String text,
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
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    String textComment = "";
    Map m = ModalRoute.of(context)!.settings.arguments as Map;
    Facility f = m['Facility'];
    Image icon = m['icon'];
    Color color = m['color'];
    double user_lat = m['lat'];
    double user_log = m['log'];
    String feedbacktype = m['ftype'];
    String feedbacksubtype = m['fstype'];
    double rating = 3;
    return Scaffold(
        body: Column(
      children: [
        FacilityHeader(f: f),
        SizedBox(height: 20),
        Text(
          feedbacksubtype,
          style: GoogleFonts.comfortaa(
              textStyle: TextStyle(fontSize: 16), color: Colors.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        CategorySelected(color: color, icon: icon),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '     Report feedback',
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
          itemCount: 5,
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
        SizedBox(
          height: 40,
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
                  // do something when the button is pressedf
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
                  return count++ == 4;
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
                Response response = await post(
                  Uri.parse('http://${FlutterConfig.get('API_ADDRESS')}/api/feedback/'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': 'Bearer ' + token!
                  },
                  body: jsonEncode({
                    "feedback_category": feedbacktype,
                    "feedback_subcategory": feedbacksubtype,
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
                if (response.statusCode == 200 && jsonData['points_added'] != '0') {
                  print('feedback  inserted');
                  Navigator.pushNamed(context, '/feedback/catagory/subcatagory/thankyou', arguments: {
                    'color': color,
                    'icon': icon,
                    'Facility': f,
                    'fstype': feedbacksubtype,
                    'login': true,
                    'points': jsonData['points_added']
                  });
                } else if (response.statusCode == 200 && jsonData['points_added'] == '0') {
                  Navigator.pushNamed(context, '/feedback/catagory/subcatagory/thankyou', arguments: {
                    'color': color,
                    'icon': icon,
                    'Facility': f,
                    'fstype': feedbacksubtype,
                    'login': false,
                    'points': '0'
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
      ],
    ));
  }
}
