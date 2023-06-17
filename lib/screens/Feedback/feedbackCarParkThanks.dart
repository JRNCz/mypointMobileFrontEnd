import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mypointfrontend/appData/provider/rendermap.dart';
import 'package:mypointfrontend/widgets/facilityheader.dart';
import 'package:mypointfrontend/widgets/feedbackrelated.dart';

class CarParkFeedbackThankyou extends StatelessWidget {
  const CarParkFeedbackThankyou({super.key});

  @override
  Widget build(BuildContext context) {
    List<double> ratings = [
      1,
      2,
      2,
      3,
      4,
      5,
      5,
      4,
      5,
      5,
      5,
      4,
      4,
      4,
      5,
      5,
      5,
      5,
      5,
      5,
      5,
      5,
    ];

    Map m = ModalRoute.of(context)!.settings.arguments as Map;
    Facility f = m['Facility'];
    Image icon = m['icon'];
    Color color = m['color'];
    String feedbacksubtype = m['fstype'];
    bool wasLoggedIn = m['login'];
    String points = m['points'];
    return Scaffold(
      body: Column(children: [
        FacilityHeaderNoBack(f: f),
        SizedBox(height: 30),
        Text(
          feedbacksubtype,
          style: GoogleFonts.comfortaa(
              textStyle: TextStyle(fontSize: 16), color: Colors.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        CategorySelected(color: color, icon: icon),
        SizedBox(
          height: 30,
        ),
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
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Text(
            'Did you know that during last month....',
            style: GoogleFonts.comfortaa(
                textStyle: TextStyle(fontSize: 16), color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        RatingHistogram(ratings: ratings),
        SizedBox(
          height: 20,
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          label: Text('OK'),
          onPressed: () {
            int count = 0;
            Navigator.popUntil(context, (route) {
              print(route.settings.name);
              return count++ == 2;
            });
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(140, 40),
            backgroundColor: Color.fromARGB(255, 51, 111, 53),
          ),
        ),
      ]),
    );
  }
}
