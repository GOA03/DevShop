class ApiController {
  static const String url = "http://10.100.123.135:3000/";

  String getUrl(Endpoint endpoint) {
    return "$url${endpoint.name}";
  }
}

enum Endpoint { products, users, orders }
