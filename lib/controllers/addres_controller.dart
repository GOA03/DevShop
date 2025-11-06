import 'package:dev_shop/controllers/api/api_controller.dart';
import 'package:dev_shop/models/addres.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddresController {
  late SharedPreferences _pref;

  static final String url = ApiController().getUrl(Endpoint.products);
  http.Client client = ApiController().client;
  late String urlUser;

  @override
  Future<void> onInit() async {
    _pref = await SharedPreferences.getInstance();
  }

  //   Future<List<Addres>> getAll() async {
  //     final response = await client.get(Uri.parse(url));
  //   }
}
