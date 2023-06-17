import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mypointfrontend/appData/noProvider/feedbackprofile.dart';
import 'package:mypointfrontend/appData/provider/rendermap.dart';

class FacilityInfo extends StatelessWidget {
  const FacilityInfo({
    super.key,
    required this.f,
  });

  final Facility f;

  @override
  Widget build(BuildContext context) {
    String inf = f.asset_type.toLowerCase();
    String assetType = f.asset_type.toLowerCase().replaceAllMapped(
        RegExp(r'\b\w'), (match) => match.group(0)!.toUpperCase());
    String assetName = f.asset_name;
    if (assetName.length > 25) {
      print(assetName);
      assetName = assetName.substring(0, 25);
      int i = 0;
      while (assetName.endsWith('-') ||
          assetName.endsWith('.') ||
          assetName.endsWith(' ')) {
        i++;
        assetName = assetName.substring(0, 25 - i);
      }
      assetName = assetName + '.';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset('assets/' + inf.replaceAll(" ", "-") + '.png',
            width: 64, fit: BoxFit.cover),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(assetType,
                style:
                    GoogleFonts.comfortaa(textStyle: TextStyle(fontSize: 23))),
            SizedBox(
              height: 10,
            ),
            Text(assetName,
                style:
                    GoogleFonts.comfortaa(textStyle: TextStyle(fontSize: 18))),
          ],
        ),
      ],
    );
  }
}

class ShopInfo extends StatelessWidget {
  const ShopInfo(
      {super.key,
      required this.itemname,
      required this.price,
      required this.category,
      required this.shopname});

  final String itemname;
  final String price;
  final String category;
  final String shopname;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/store.png', width: 64, fit: BoxFit.cover),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(itemname,
                style:
                    GoogleFonts.comfortaa(textStyle: TextStyle(fontSize: 23))),
            SizedBox(
              height: 10,
            ),
            Text(shopname,
                style:
                    GoogleFonts.comfortaa(textStyle: TextStyle(fontSize: 18))),
          ],
        ),
      ],
    );
  }
}

class CategorySelected extends StatelessWidget {
  const CategorySelected({
    super.key,
    required Color color,
    required Image icon,
  })  : selectionColor = color,
        selectionIcon = icon;

  final Image selectionIcon;
  final Color selectionColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Divider(
            thickness: 1,
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selectionColor,
          ),
          child: Center(
            child: selectionIcon,
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Divider(
            thickness: 1,
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}

class RatingHistogram extends StatelessWidget {
  final List<double> ratings;

  RatingHistogram({required this.ratings});

  @override
  Widget build(BuildContext context) {
    // Calculate the count for each rating
    Map<double, int> ratingCounts = {};
    for (var rating in ratings) {
      ratingCounts[rating] = (ratingCounts[rating] ?? 0) + 1;
    }

    return Center(
      child: Column(
        children: ratingCounts.entries.map((entry) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.amber),
              SizedBox(width: 4),
              Text('${entry.key}'),
              SizedBox(width: 4),
              Container(
                height: 20,
                width: MediaQuery.of(context).size.width * 0.5,
                child: LinearProgressIndicator(
                  color: Colors.yellow,
                  value: entry.value / ratings.length,
                  backgroundColor: Colors.grey[300],
                ),
              ),
              SizedBox(width: 8),
              Text('${entry.value}'),
            ],
          );
        }).toList(),
      ),
    );
  }
}
