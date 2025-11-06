class Order {
  final int userId;
  final String orderId;
  final Status status;
  final String addresId;
  late double totalPrice;

  Order({
    required this.userId,
    required this.orderId,
    required this.status,
    required this.addresId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'orderId': orderId,
      'status': status,
      'addresId': addresId,
      'totalPrice': totalPrice,
    };
  }

  Order.fromJson(Map<String, dynamic> json)
    : userId = json['userId'] ?? 0,
      orderId = json['orderId'] ?? '',
      status = json['status'] ?? Status.nome,
      addresId = json['addresId'] ?? '',
      totalPrice = json['totalPrice'] ?? 0.0;
}

enum Status { sanded, preparing, delivered, paid, nome }
