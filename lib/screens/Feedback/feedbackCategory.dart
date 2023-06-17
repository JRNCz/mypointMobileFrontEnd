import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mypointfrontend/appData/provider/rendermap.dart';
import 'package:mypointfrontend/widgets/buttons.dart';
import 'package:mypointfrontend/widgets/facilityheader.dart';
import 'package:mypointfrontend/widgets/feedbackrelated.dart';

class FeedbackCatScreen extends StatelessWidget {
  const FeedbackCatScreen({super.key});

  List<int> getDimensions(Map<String, Image> map) {
    List<int> arr = [0, 0];
    if (map.length == 0) {
      return arr;
    } else {
      if (map.length > 4) {
        arr[0] = 3;
        arr[1] = 3;
        return arr;
      } else {
        arr[0] = 2;
        arr[1] = 2;
        return arr;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Map m = ModalRoute.of(context)!.settings.arguments as Map;
    Facility f = m['Facility'];
    Image icon = m['icon'];
    double user_lat = m['user_lat'];
    double user_log = m['user_long'];
    Color color = m['color'];
    Map<String, Color> subCategoriesColor = m['mapcolor'];
    Map<String, Image> map = m['map'];
    String ftype = m['type'];
    int NumButtons = map.length;
    int NumText = -1;

    List<int> dimensions = getDimensions(map); // Não usa-se

    return Scaffold(
      body: Column(
        children: [
          FacilityHeader(f: f),
          SizedBox(height: 20),
          Text(ftype + ' feedback',
              textAlign: TextAlign.center,
              style: GoogleFonts.comfortaa(
                  textStyle: TextStyle(fontSize: 18), color: Colors.black, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          CategorySelected(color: color, icon: icon),
          SizedBox(height: 25),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('     Select category',
                style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(fontSize: 16),
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          ),
          Container(
            child: Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: dimensions[0],
                    itemBuilder: (context, index) {
                      if (NumButtons > 0) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(dimensions[1], (index) {
                                  if (NumButtons > 0) {
                                    NumText++;
                                    NumButtons--;
                                    return Row(
                                      children: [
                                        SizedBox(
                                          width: 30,
                                        ),
                                        ButtonCategory(
                                          color: subCategoriesColor.values.elementAt(NumText),
                                          icon: map.values.elementAt(NumText),
                                          text: map.keys.elementAt(NumText),
                                          f: f,
                                          ftype: ftype,
                                          lati: user_lat,
                                          longi: user_log,
                                        ),
                                        SizedBox(
                                          width: 30,
                                        )
                                      ],
                                    );
                                  } else {
                                    return Row();
                                  }
                                })),
                          ],
                        );
                      }
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
