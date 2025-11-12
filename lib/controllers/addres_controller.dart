import 'dart:convert';

import 'package:dev_shop/controllers/api/api_controller.dart';
import 'package:dev_shop/models/addres.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddresController {
  late SharedPreferences _pref;
  late final String _urlUser;
  late final int _userId;

  static final String url = ApiController().getUrl(Endpoint.addres);
  http.Client client = ApiController().client;

  Future<void> onInit() async {
    _pref = await SharedPreferences.getInstance();
    _userId = _pref.getInt('userId')!;
    _urlUser = ApiController().getUrlUser(_userId, Endpoint.addres);
  }

  Future<List<Addres>> getAll({required int id, required String token}) async {
    final response = await client.get(
      Uri.parse(_urlUser),
      headers: {"Authorization": "Bearer $token"},
    );

    final listDynamic = json.decode(response.body) as List;
    return listDynamic.map((e) => Addres.fromMap(e)).toList();
  }
}
