import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mypointfrontend/appData/provider/userdata.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    Map m = ModalRoute.of(context)!.settings.arguments as Map;
    String points = m['points'];
    String level = m['level'];
    String email = m['email'];
    String reputation = m['reputation'];
    String username = m['username'];

    print('rebuild');
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
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
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://gbengaawomodu.files.wordpress.com/2010/12/a-happy-adult.jpg'),
                      radius: 40.0,
                    ),
                  ),
                  Divider(
                    height: 60.0,
                    color: Colors.grey[300],
                    thickness: 1,
                  ),
                  const Text(
                    'USERNAME:',
                    style: TextStyle(color: Colors.black, letterSpacing: 2, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10, // 10 pixel box to have a space
                  ),
                  Text(
                    username,
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
                    'CURRENT LEVEL',
                    style: TextStyle(color: Colors.black, letterSpacing: 2, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10, // 10 pixel box to have a space
                  ),
                  Text(
                    level,
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
                    'POINTS',
                    style: TextStyle(color: Colors.black, letterSpacing: 2, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10, // 10 pixel box to have a space
                  ),
                  Text(
                    points,
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
                    'Email',
                    style: TextStyle(color: Colors.black, letterSpacing: 2, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10, // 10 pixel box to have a space
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      color: Color.fromARGB(255, 127, 127, 127),
                      letterSpacing: 2,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(
                    height: 30, // 10 pixel box to have a space
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.login, color: Colors.white),
                    label: Text('LOG OUT'),
                    onPressed: () async {
                      await context.read<User>().Logout();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, minimumSize: Size(double.infinity, 40)),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
