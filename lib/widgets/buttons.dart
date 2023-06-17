import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mypointfrontend/appData/provider/rendermap.dart';

import '../appData/noProvider/feedbackprofile.dart';

class BuildButtonCreateAccount extends StatelessWidget {
  const BuildButtonCreateAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.account_box, color: Colors.blue),
      label: const Text(
        'CREATE AN ACCOUNT',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
      onPressed: () {
        print('Clicked the button');
        Navigator.pushNamed(context, '/createaccount');
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: BorderSide(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        minimumSize: Size(double.infinity, 40),
      ),
    );
  }
}

class BuildButtonForgotPassword extends StatelessWidget {
  const BuildButtonForgotPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.question_mark, color: Colors.blue),
      label: const Text('FORGOT PASSWORD?',
          style: TextStyle(
            color: Colors.blue,
          )),
      onPressed: () {
        print('Clicked the button');
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: BorderSide(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        minimumSize: Size(double.infinity, 40),
      ),
    );
  }
}

class FeedbackButtons extends StatelessWidget {
  const FeedbackButtons({
    super.key,
    required Facility asset,
    required double lat,
    required double long,
  })  : facility = asset,
        lati = lat,
        longi = long;

  final double lati;
  final double longi;
  final Facility facility;

  Color convertToRGB(double red, double green, double blue) {
    return Color.fromRGBO(red.toInt(), green.toInt(), blue.toInt(), 1.0);
  }

  @override
  Widget build(BuildContext context) {
    // RECEBO os items
    // get

    Future<List<FeedbackProfile>> getData() async {
      String Cat = "";
      List<FeedbackProfile> feedp = []; // The new list of feedback profiles
      int i = 0;
      String asset_type = facility.asset_type.replaceAll(' ', '');
      asset_type = asset_type.replaceAll(',', '');
      Response response = await get(
        Uri.parse('http://${FlutterConfig.get('API_ADDRESS')}/api/categories/' + asset_type + '/'),
      );

      var jsonData = jsonDecode(response.body);
      FeedbackProfile fp = FeedbackProfile();

      for (final json in jsonData) {
        if (json['feedback_category']['feedback_category_name'] != Cat) {
          Cat = json['feedback_category']['feedback_category_name'];
          if (i == 0) {
            fp.setCategory(json['feedback_category']['feedback_category_name']);
            fp.setSubcategory(json['feedback_subcategory']['feedback_subcategory_name']);
            // fp.setColorSubCategory(color)
            fp.setImageSubCategory(json['feedback_subcategory']['feedback_subcategory_imageurl']);
            fp.setColorSubCategory(convertToRGB(
                json['feedback_subcategory']['feedback_subcategory_color_red'],
                json['feedback_subcategory']['feedback_subcategory_color_green'],
                json['feedback_subcategory']['feedback_subcategory_color_blue']));
          } else {
            feedp.add(fp);
            fp = FeedbackProfile();
            fp.setCategory(json['feedback_category']['feedback_category_name']);

            fp.setColorCategory(convertToRGB(
                json['feedback_category']['feedback_category_color_red'],
                json['feedback_category']['feedback_category_color_green'],
                json['feedback_category']['feedback_category_color_blue']));
            fp.setImageCategory(json['feedback_category']['feedback_category_imageurl']);
            fp.setSubcategory(json['feedback_subcategory']['feedback_subcategory_name']);
            fp.setColorSubCategory(convertToRGB(
                json['feedback_subcategory']['feedback_subcategory_color_red'],
                json['feedback_subcategory']['feedback_subcategory_color_green'],
                json['feedback_subcategory']['feedback_subcategory_color_blue']));
            fp.setImageSubCategory(json['feedback_subcategory']['feedback_subcategory_imageurl']);
          }
        } else {
          fp.setSubcategory(json['feedback_subcategory']['feedback_subcategory_name']);
          fp.setImageSubCategory(json['feedback_subcategory']['feedback_subcategory_imageurl']);
          fp.setColorSubCategory(convertToRGB(
              json['feedback_subcategory']['feedback_subcategory_color_red'],
              json['feedback_subcategory']['feedback_subcategory_color_green'],
              json['feedback_subcategory']['feedback_subcategory_color_blue']));
        }
        i++;
      }
      feedp.add(fp);
      for (FeedbackProfile item in feedp) {
        print(item.category);
        print(item.subcategoriesImage);
        print(item.subcategories);
        for (int j = 0; j < item.subcategoriesColor.length; j++) print(item.subcategoriesColor[j].red);
      }
      return feedp;
    }

    Future<void> databaseFeedbackProfilesToMap(String type, String image, Color color) async {
      List<FeedbackProfile> feedbackProfiles = [];
      List<FeedbackProfile> list = await getData();
      Map<String, Image> map = {};
      Map<String, Color> mapColor = {};
      int i = 0;
      for (FeedbackProfile profile in list) {
        if (profile.category == type) {
          for (String subc in profile.subcategories) {
            map.putIfAbsent(
              subc,
              () => Image.asset(
                'assets/' + profile.subcategoriesImage[i],
                width: 40,
                height: 40,
              ),
            );
            mapColor.putIfAbsent(subc, () => profile.subcategoriesColor[i]);
            i++;
          }
        }
      }

      Navigator.pushNamed(
        context,
        '/feedback/catagory',
        arguments: {
          'mapcolor': mapColor,
          'Facility': facility,
          'color': color,
          'icon': Image.asset(
            image,
            width: 40,
            height: 40,
          ),
          'map': map,
          'type': type,
          'user_lat': lati,
          'user_long': longi
        },
      );
    }

    return Column(
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Text(
                '     Specify your problem, if desired',
                style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(fontSize: 16),
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 15,
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
                      onPressed: () async {
                        await databaseFeedbackProfilesToMap(
                            'Quality of Service', 'assets/qos.png', Colors.green);
                      },
                      child: Image.asset(
                        'assets/qos.png',
                        width: 40,
                        height: 40,
                      ),
                      backgroundColor: Colors.green,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Service Quality',
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
                      onPressed: () async {
                        await databaseFeedbackProfilesToMap('Security', 'assets/lock.png', Colors.red);
                      },
                      child: Image.asset(
                        'assets/lock.png',
                        width: 40,
                        height: 40,
                      ),
                      backgroundColor: Colors.red,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Security',
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
                      onPressed: () async {
                        await databaseFeedbackProfilesToMap(
                            'Maintenance', 'assets/maintenance.png', Colors.blue);
                      },
                      child: Image.asset(
                        'assets/maintenance.png',
                        width: 40,
                        height: 40,
                      ),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Maintenance',
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
    );
  }
}

class ButtonCategory extends StatelessWidget {
  const ButtonCategory(
      {super.key,
      required this.color,
      required this.icon,
      required this.text,
      required this.f,
      required this.ftype,
      required this.lati,
      required this.longi});

  final Image icon;
  final Color color;
  final String text;
  final Facility f;
  final String ftype;
  final double lati;
  final double longi;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 77,
      height: 135,
      child: Column(
        children: [
          FloatingActionButton.large(
            heroTag: null,
            onPressed: () {
              print(ftype);
              print(text);

              Navigator.pushNamed(context, '/feedback/catagory/subcatagory', arguments: {
                'color': color,
                'icon': icon,
                'Facility': f,
                'ftype': ftype,
                'fstype': text,
                'lat': lati,
                'log': longi
              });
            },
            child: icon,
            backgroundColor: color,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.comfortaa(
                textStyle: TextStyle(fontSize: 10.4), color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class AddCarParkButton extends StatelessWidget {
  const AddCarParkButton({
    super.key,
    required this.lat,
    required this.long,
  });

  final double lat;
  final double long;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 10,
        bottom: 180,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(244, 245, 244, 0.698),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1, 0),
              ),
            ],
          ),
          child: Material(
            color: Color.fromRGBO(244, 245, 244, 0.698),
            shape: CircleBorder(),
            child: IconButton(
              iconSize: 40,
              icon: Icon(Icons.local_parking, color: Color.fromARGB(255, 124, 124, 124)),
              onPressed: () async {
                Navigator.pushNamed(context, '/feedback/carpark/add', arguments: {
                  'lat': lat,
                  'long': long,
                });
              },
            ),
          ),
        ));
  }
}

class RefreshMapButton extends StatelessWidget {
  const RefreshMapButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 10,
        bottom: 100,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(244, 245, 244, 0.698),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1, 0),
              ),
            ],
          ),
          child: Material(
            color: Color.fromRGBO(244, 245, 244, 0.698),
            shape: CircleBorder(),
            child: IconButton(
              iconSize: 40,
              icon: Icon(Icons.refresh, color: Color.fromARGB(255, 124, 124, 124)),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ),
        ));
  }
}

class OpenMenu extends StatelessWidget {
  const OpenMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 50,
      child: Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color.fromRGBO(244, 245, 244, 0.698),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(1, 0),
            ),
          ],
        ),
        child: Material(
          color: Color.fromRGBO(244, 245, 244, 0.698),
          child: IconButton(
            icon: Icon(Icons.menu_outlined),
            color: Color.fromARGB(255, 127, 127, 127),
            onPressed: () {
              // Open the menu drawer
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
    );
  }
}

Positioned ScanFacilityButton(BuildContext context, RenderMap local, List<Facility> args) {
  void sendToScreen(double lat, double long, Facility f) {
    Navigator.pushNamed(context, '/feedback/placeholder', arguments: {
      'lat': lat,
      'Facility': f,
      'long': long,
    });
  }

  return Positioned(
      right: 10,
      bottom: 20,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(244, 245, 244, 0.698),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(1, 0),
            ),
          ],
        ),
        child: Material(
          color: Color.fromRGBO(244, 245, 244, 0.698),
          shape: CircleBorder(),
          child: IconButton(
            iconSize: 40,
            icon: Icon(Icons.qr_code, color: Color.fromARGB(255, 124, 124, 124)),
            onPressed: () async {
              bool isFound = false;
              dynamic result = await Navigator.pushNamed(context, "/scan");
              String id = result.substring(21, result.length - 2);
              args.forEach((element) async {
                if (element.asset_id == (id)) {
                  isFound = true;
                  sendToScreen(local.lat, local.long, element);
                }
              });
              if (!isFound) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('The QR Code is invalid \n'),
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
      ));
}
