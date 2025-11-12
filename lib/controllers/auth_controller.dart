import 'dart:convert';
import 'dart:io';

import 'package:dev_shop/controllers/api/api_controller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static final String url = ApiController().getUrlNoAdd();

  http.Client client = ApiController().client;

  Future<bool> login({required String email, required String password}) async {
    http.Response response = await client.post(
      Uri.parse('${url}login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode != 200) {
      String contet = json.decode(response.body);
      switch (contet) {
        case "Cannot find user":
          throw UserNotFindException();
      }
      throw HttpException(response.body);
    }
    saveInfor(response.body);
    return true;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    http.Response response = await client.post(
      Uri.parse('${url}register'),
      body: {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
      },
    );

    // if (response.statusCode != 201) {
    //   throw HttpException("Error register");
    // }
    saveInfor(response.body);
    return true;
  }

  void saveInfor(String body) async {
    Map<String, dynamic> map = json.decode(body);
    String token = map['accessToken'];
    String email = map['user']['email'];
    String name = map['user']['name'];
    String phone = map['user']['phone'];
    int id = map['user']['id'];

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("token", token);
    pref.setString("email", email);
    pref.setString("name", name);
    pref.setString("phone", phone);
    pref.setInt("userId", id);
  }
}

class UserNotFindException implements Exception {}
