import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String userscan = "";
  List<Barcode> barcodes = [];
  @override
  Widget build(BuildContext context) {
    bool done = true;
    return Scaffold(
        body: Stack(
      children: [
        MobileScanner(
          controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.normal,
            facing: CameraFacing.back,
            torchEnabled: true,
          ),
          onDetect: (capture) {
            barcodes = capture.barcodes;
            userscan = barcodes[0].rawValue as String;
            if (done == true) {
              done = false;
              Navigator.pop(context, userscan);
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
