class ApiController {
  static const String url = "http://192.168.0.4:3000/";

  String getUrl(Endpoint endpoint) {
    return "$url${endpoint.name}";
  }

  String getUrlNoAdd() {
    return url;
  }
}

enum Endpoint { products, users, orders }
