import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 25,
                  height: 25,
                  child: IconButton(
                    iconSize: 20,
                    icon: Icon(Icons.arrow_back,
                        color: Color.fromARGB(255, 124, 124, 124)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Text(
              'MyPoint is honored to collaborate with exceptional partners : ',
              textAlign: TextAlign.center,
              style: GoogleFonts.comfortaa(
                  textStyle: TextStyle(fontSize: 18),
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/ist.png',
                width: 250,
                height: 100,
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/inesc.png',
                width: 250,
                height: 100,
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Text(
            '2023',
            textAlign: TextAlign.center,
            style: GoogleFonts.comfortaa(
                textStyle: TextStyle(fontSize: 18),
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
