import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart';
import 'package:mypointfrontend/appData/provider/userdata.dart';
import 'package:mypointfrontend/widgets/feedbackrelated.dart';
import 'package:provider/provider.dart';

class ItemOrder extends StatelessWidget {
  const ItemOrder({super.key});

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    String name = args['Itemname'];
    String price = args['price'];
    String category = args['category'];
    String shopname = args['Shopname'];
    String currentpoints = args['clientpoints'];
    int item_id = args['item_id'];
    String username = args['username'];

    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 25,
                height: 25,
                child: IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 124, 124, 124)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShopInfo(itemname: name, price: price, category: category, shopname: shopname),
              Divider(
                height: 60.0,
                color: Colors.grey[300],
                thickness: 1,
              ),
              const Text(
                'Item:',
                style: TextStyle(color: Colors.black, letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10, // 10 pixel box to have a space
              ),
              Text(
                name,
                style: TextStyle(
                  color: Color.fromARGB(255, 127, 127, 127),
                  letterSpacing: 2,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 30, // 10 pixel box to have a space
              ),
              const Text(
                'Shop name',
                style: TextStyle(color: Colors.black, letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10, // 10 pixel box to have a space
              ),
              Text(
                shopname,
                style: TextStyle(
                  color: Color.fromARGB(255, 127, 127, 127),
                  letterSpacing: 2,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 30, // 10 pixel box to have a space
              ),
              const Text(
                'Price',
                style: TextStyle(color: Colors.black, letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10, // 10 pixel box to have a space
              ),
              Text(
                price,
                style: TextStyle(
                  color: Color.fromARGB(255, 127, 127, 127),
                  letterSpacing: 2,
                  fontSize: 20.0,
                ),
              ),
              Divider(
                height: 60.0,
                color: Colors.grey[300],
                thickness: 1,
              ),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  const Text('username',
                      style:
                          TextStyle(color: Colors.black, letterSpacing: 2, fontWeight: FontWeight.bold)),
                  Text(username,
                      style: TextStyle(
                        color: Color.fromARGB(255, 127, 127, 127),
                        fontSize: 18,
                        letterSpacing: 1.0,
                      )),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Icon(
                    Icons.point_of_sale,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  const Text('Current points',
                      style:
                          TextStyle(color: Colors.black, letterSpacing: 2, fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(currentpoints,
                      style: TextStyle(
                        color: Color.fromARGB(255, 127, 127, 127),
                        fontSize: 18,
                        letterSpacing: 1.0,
                      )),
                ],
              ),
              Divider(
                height: 60.0,
                color: Colors.grey[300],
                thickness: 1,
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
                  SizedBox(
                    width: 50,
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.money, color: Colors.white),
                    label: Text('Buy'),
                    onPressed: () async {
                      try {
                        var token = await context.read<User>().getAcessToken();

                        Response response = await post(
                            Uri.parse('http://${FlutterConfig.get('API_ADDRESS')}/api/item/$item_id/'),
                            headers: {'Authorization': 'Bearer ' + token!});
                        var jsonData = jsonDecode(response.body);
                        print(response.statusCode);
                        print(response.statusCode);

                        print(response.statusCode);

                        print(response.statusCode);

                        print(response.statusCode);

                        if (response.statusCode == 200) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Sucess!'),
                                content: Text('The transaction was completed \n'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      int count = 0;
                                      Navigator.popUntil(context, (route) {
                                        print(route.settings.name);
                                        return count++ == 3;
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text('The transaction was cancelled \n'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      int count = 0;
                                      Navigator.popUntil(context, (route) {
                                        print(route.settings.name);
                                        return count++ == 3;
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('The transaction was cancelled \n'),
                              actions: [
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    int count = 0;
                                    Navigator.popUntil(context, (route) {
                                      print(route.settings.name);
                                      return count++ == 3;
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
          ),
        ),
      ],
    ));
  }
}
