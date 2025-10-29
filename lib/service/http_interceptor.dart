import 'package:http/http.dart';
import 'package:http_interceptor/models/interceptor_contract.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends InterceptorContract {
  Logger logger = Logger();

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    logger.d(
      "Requesting: ${request.url} \nHeaders: ${request.headers}\n Request: ${request.toString()}",
    );
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    if (response.statusCode ~/ 100 == 2) {
      Logger().i(
        "Response: ${response.request?.url} \nStatus Code: ${response.statusCode}\n Response: ${(response is Response) ? (response).body : ''}",
      );
    } else {
      Logger().w(
        "Response: ${response.request?.url} \nStatus Code: ${response.statusCode}\n Response: ${(response is Response) ? (response).body : ''}",
      );
    }
    return response;
  }
}
