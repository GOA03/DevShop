class ApiController {
  static const String url = "http://10.100.123.146:3000/";

  String getUrl(Endpoint endpoint) {
    return "$url${endpoint.name}";
  }

  String getUrlNoAdd() {
    return url;
  }
}

enum Endpoint { products, users, orders }
