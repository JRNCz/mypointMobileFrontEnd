import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mypointfrontend/appData/provider/userdata.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String userscan = "";
  List<Barcode> barcodes = [];
  @override
  getItemInfo(int databaseId) async {
    var token = await context.read<User>().getAcessToken();

    Response response = await get(
        Uri.parse('http://${FlutterConfig.get('API_ADDRESS')}/api/item/$databaseId'),
        headers: {'Authorization': 'Bearer ' + token!});
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData['item']['name']);
      print(jsonData['item']['price']);
      print(jsonData['item']['category']);
      print(jsonData['shop']['name']);

      Map data = {
        'Itemname': jsonData['item']['name'],
        'price': jsonData['item']['price'],
        'category': jsonData['item']['category'],
        'Shopname': jsonData['shop']['name'],
        'clientpoints': jsonData['client']['points'],
        'username': jsonData['client']['username'],
        'item_id': databaseId
      };
      Navigator.pushNamed(context, '/item/order', arguments: data);
    } else {
      Map data = {'Itemname': 'error'};
      AlertDialog(
        title: Text('Error'),
        content: Text('The item is invalid or the service is down\n'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  }

  Widget build(BuildContext context) {
    bool done = false;
    return Scaffold(
        body: Stack(
      children: [
        MobileScanner(
          controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.normal,
            facing: CameraFacing.back,
            torchEnabled: false,
          ),
          onDetect: (capture) {
            if (done == false) {
              try {
                barcodes = capture.barcodes;
                userscan = barcodes[0].rawValue as String;
                done = true;
                String id = userscan.substring(21, userscan.length - 2);
                int databaseId = int.parse(id);
                getItemInfo(databaseId);
              } catch (error) {
                print('Error');
                Map data = {'Itemname': 'error'};
                Navigator.pop(context, data);
              }
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: IconButton(
                  iconSize: 40,
                  icon: Icon(Icons.arrow_back, color: Colors.green),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
