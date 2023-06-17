import 'package:flutter/material.dart';
import 'package:mypointfrontend/widgets/feedbackrelated.dart';

import '../appData/provider/rendermap.dart';

class FacilityHeader extends StatelessWidget {
  const FacilityHeader({super.key, required this.f});

  final Facility f;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
          child: SizedBox(
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
        ),
        Container(padding: const EdgeInsets.fromLTRB(25, 80, 0, 0), child: FacilityInfo(f: f)),
      ],
    );
  }
}

class FacilityHeaderNoBack extends StatelessWidget {
  const FacilityHeaderNoBack({super.key, required this.f});

  final Facility f;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 50, 0, 0),
          child: SizedBox(
            width: 25,
            height: 25,
          ),
        ),
        Container(padding: const EdgeInsets.fromLTRB(25, 80, 0, 0), child: FacilityInfo(f: f)),
      ],
    );
  }
}
