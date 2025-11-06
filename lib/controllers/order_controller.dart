import 'package:dev_shop/controllers/api/api_controller.dart';
import 'package:dev_shop/service/http_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderController {
  static final String url = ApiController().getUrl(Endpoint.orders);
  http.Client client = InterceptedClient.build(
    interceptors: [LoggerInterceptor()],
  );

  late SharedPreferences _pref;
  late int _currentUserId;

  @override
  Future<void> onInit() async {
    _pref = await SharedPreferences.getInstance();
    _currentUserId = _pref.getInt('userId')!;
    //super.onInit();
  }
}
