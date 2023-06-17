import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart';
import 'package:mypointfrontend/widgets/textfields.dart';

class NewAccount extends StatefulWidget {
  const NewAccount({super.key});

  @override
  State<NewAccount> createState() => _NewAccountState();
}

class _NewAccountState extends State<NewAccount> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _userName = TextEditingController();
  final _userNameEmail = TextEditingController();
  final _userPassword = TextEditingController();
  final _userPasswordRepeat = TextEditingController();

  Future<void> CreateAccount(
      String firstName,
      String lastName,
      String userNameEmail,
      String userName,
      String userPassword,
      String userPasswordRepeat) async {
    if (userPassword == userPasswordRepeat) {
      Response response = await post(
          Uri.parse('http://${FlutterConfig.get('API_ADDRESS')}/api/clients/'),
          body: {
            "password": userPassword,
            "username": userName,
            "first_name": firstName,
            "last_name": lastName,
            "email": userNameEmail,
          });

      if (response.statusCode == 201) {
        int count = 0;
        Navigator.popUntil(context, (route) {
          print(route.settings.name);
          return count++ == 2;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Built');
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                top: 25 + MediaQuery.of(context).padding.top,
                left: 10,
                right: 10),
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
                        icon: Icon(Icons.arrow_back,
                            color: Color.fromARGB(255, 124, 124, 124)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                buildText(
                    controller: _firstName,
                    text: 'First Name',
                    icon: Icon(Icons.person)),
                const SizedBox(height: 15),
                buildText(
                    controller: _lastName,
                    text: 'Last Name',
                    icon: Icon(Icons.person)),
                const SizedBox(height: 15),
                buildText(
                    controller: _userNameEmail,
                    text: 'Email',
                    icon: Icon(Icons.person_2)),
                const SizedBox(height: 15),
                buildText(
                    controller: _userName,
                    text: 'Username',
                    icon: Icon(Icons.person_3)),
                const SizedBox(height: 15),
                buildTextPassword(userPassword: _userPassword),
                const SizedBox(height: 15),
                buildTextPassword(userPassword: _userPasswordRepeat),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  icon: Icon(Icons.login, color: Colors.white),
                  label: Text('CREATE'),
                  onPressed: () {
                    print('Clicked the button');
                    CreateAccount(
                        _firstName.text,
                        _lastName.text,
                        _userNameEmail.text,
                        _userName.text,
                        _userPassword.text,
                        _userPasswordRepeat.text);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 40)),
                )
              ],
            ),
          ),
        ));
  }
}
