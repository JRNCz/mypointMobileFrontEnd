import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:mypointfrontend/widgets/textfields.dart';
import 'package:mypointfrontend/widgets/buttons.dart';
import 'package:mypointfrontend/appData/provider/userdata.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _userNameEmail = TextEditingController();
  final _userPassword = TextEditingController();

  Future<bool> SignIn(String emailorUsername, String password) async {
    Future<bool> isSignedIn = context.read<User>().setTokens(emailorUsername, password);
    return isSignedIn;
  }

  @override
  Widget build(BuildContext context) {
    print('Built');
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 25 + MediaQuery.of(context).padding.top, left: 10, right: 10),
            child: Column(
              children: [
                Row(
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
                SizedBox(height: 20),
                buildText(
                  controller: _userNameEmail,
                  text: 'Username',
                  icon: Icon(Icons.email),
                ),
                const SizedBox(height: 20),
                buildTextPassword(userPassword: _userPassword),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.login, color: Colors.white),
                  label: Text('LOG IN'),
                  onPressed: () async {
                    print('Clicked the button');
                    bool isSignedIn = await SignIn(_userNameEmail.text, _userPassword.text);
                    if (isSignedIn) {
                      Navigator.pop(context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Invalid log in\n'),
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
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, minimumSize: Size(double.infinity, 40)),
                ),
                const SizedBox(height: 20),
                Divider(
                  color: Colors.grey[400],
                  thickness: 1,
                ),
                const SizedBox(height: 20),
                BuildButtonForgotPassword(),
                const SizedBox(height: 6),
                BuildButtonCreateAccount(),
              ],
            ),
          ),
        ));
  }
}
