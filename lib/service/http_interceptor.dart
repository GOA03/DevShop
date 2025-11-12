import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_interceptor/models/interceptor_contract.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends InterceptorContract {
  final Logger logger = Logger();

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    logger.i(
      "➡️ [REQUEST] ${request.method} ${request.url}\n"
      "Headers: ${request.headers}\n"
      "Body: ${request is Request ? request.body : 'N/A'}",
    );
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    final status = response.statusCode;
    final requestUrl = response.request?.url.toString();

    // Pega o corpo se for Response (para logar JSON)
    final responseBody = response is Response ? response.body : null;

    if (status >= 200 && status < 300) {
      logger.i(
        "✅ [SUCCESS] $status → $requestUrl\n"
        "${responseBody ?? ''}",
      );
    } else {
      logger.w(
        "⚠️ [ERROR] $status → $requestUrl\n"
        "${responseBody ?? ''}",
      );

      // 🔹 Aqui entram as condições globais específicas
      switch (status) {
        case 401:
          _handleUnauthorized();
          break;

        case 403:
          _handleForbidden();
          break;

        case 500:
          _handleServerError(responseBody);
          break;

        default:
          // Outros erros genéricos
          logger.w("🚨 Erro HTTP genérico ($status)");
      }
    }

    return response;
  }

  /// 🔒 Token expirado / usuário não autorizado
  void _handleUnauthorized() {
    logger.e("🔑 Token expirado ou sessão inválida. Realizando logout...");

    // Se você tiver um `navigatorKey` global, pode redirecionar o usuário:
    // navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (_) => false);

    // Ou acionar um callback global / limpar token do storage, etc.
  }

  /// 🚫 Acesso negado
  void _handleForbidden() {
    logger.e("🚫 Acesso negado. O usuário não tem permissão para esta ação.");
  }

  /// 💥 Erro interno do servidor
  void _handleServerError(String? responseBody) {
    String? message;
    try {
      final decoded = jsonDecode(responseBody ?? '{}');
      message = decoded['message'] ?? decoded['error'] ?? 'Erro interno';
    } catch (_) {
      message = 'Erro interno desconhecido';
    }

    logger.e("💥 Erro interno do servidor: $message");
  }
}
