import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:mypointfrontend/appData/provider/rendermap.dart';

class User extends ChangeNotifier {
  static const FlutterSecureStorage storage = FlutterSecureStorage();
  bool wasLoggedIn = false;

  void ChangeLoginState(bool state) {
    wasLoggedIn = state;
  }

  Future<bool> setTokens(emailorUsername, password) async {
    print('request incoming');

    Response response = await post(
      Uri.parse('http://${FlutterConfig.get('API_ADDRESS')}/api/token/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"username": emailorUsername, "password": password}),
    );

    var jsonData = jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: false));
    if (response.statusCode == 200) {
      await storeRefreshToken(jsonData['refresh']);
      await storeAcessToken(jsonData['access']);
      print(jsonData);
      return true;
    } else {
      print('Token retrival error');
      return false;
    }
  }

  Future<void> refreshToken() async {
    print('request incoming');
    String? refreshToken = await getRefreshToken();
    Response response = await post(
      Uri.parse('http://${FlutterConfig.get('API_ADDRESS')}/api/token/refresh/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"refresh": refreshToken}),
    );

    var jsonData = jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: false));
    if (response.statusCode == 200) {
      await storeAcessToken(jsonData['access']);
    } else {
      print('Refresh Acess token error');
    }
  }

  Future storeRefreshToken(String token) async {
    await storage.write(key: "Refreshtoken", value: token);
  }

  Future storeAcessToken(String token) async {
    await storage.write(key: "Acesstoken", value: token);
  }

  Future<String?> getRefreshToken() {
    return storage.read(key: "Refreshtoken");
  }

  Future<String?> getAcessToken() {
    return storage.read(key: "Acesstoken");
  }

  Future<Response> checkLogIn() async {
    var token = await getAcessToken();
    Response response = await get(
        Uri.parse('http://${FlutterConfig.get('API_ADDRESS')}/api/client/account/'),
        headers: {'Authorization': 'Bearer ' + token!});
    if (response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  }

  Future<void> Logout() async {
    await storage.write(key: "Acesstoken", value: "");
    await storage.write(key: "Refreshtoken", value: "");
  }
}
