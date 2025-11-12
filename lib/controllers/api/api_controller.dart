import 'package:dev_shop/service/http_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class ApiController {
  static const String url = "http://172.20.10.2:3000/";

  String getUrl(Endpoint endpoint) => "$url${endpoint.name}";

  String getUrlNoAdd() => url;

  String getUrlUser(int id, Endpoint endpoint) => "${url}users/$id/$endpoint";

  http.Client client = InterceptedClient.build(
    interceptors: [LoggerInterceptor()],
    requestTimeout: Duration(seconds: 10),
  );
}

enum Endpoint { products, users, orders, addres }
