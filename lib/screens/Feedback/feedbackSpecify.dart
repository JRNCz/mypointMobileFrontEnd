import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mypointfrontend/appData/provider/rendermap.dart';
import 'package:mypointfrontend/widgets/buttons.dart';
import 'package:mypointfrontend/widgets/facilityheader.dart';
import 'package:mypointfrontend/widgets/feedbackrelated.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map mapContext = ModalRoute.of(context)!.settings.arguments as Map;

    Facility f = mapContext['Facility'];
    double lat = mapContext['lat'];
    double long = mapContext['long'];
    String points = mapContext['points'];
    bool wasLoggedIn = mapContext['login'];
    
    return Scaffold(
      body: Column(
        children: [
          FacilityHeaderNoBack(f: f),
          SizedBox(height: 20),
          Text(
            'Thank you',
            style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 20), color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            wasLoggedIn ? ('You won ${points} points!') : ('Log in to get points !'),
            style: GoogleFonts.comfortaa(
                textStyle: TextStyle(fontSize: 16), color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
          FeedbackButtons(asset: f, lat: lat, long: long),
          SizedBox(
            height: 20.0,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Icon(Icons.star, color: Colors.amber),
                  Text('2.5', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 52),
                  Icon(Icons.star, color: Colors.amber),
                  Text('3.3', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 52),
                  Icon(Icons.star, color: Colors.amber),
                  Text('4.5', style: TextStyle(fontSize: 20)),
                ],
              )
            ],
          ),
          SizedBox(
            height: 50.0,
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
                    return count++ == 2;
                  });
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(140, 40),
                  backgroundColor: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
