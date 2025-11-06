class OrderItem {
  final String prodName;
  final int quantity;
  final double oldPrice;
  final double price;
  final String orderId;

  OrderItem({
    required this.prodName,
    required this.quantity,
    required this.oldPrice,
    required this.price,
    required this.orderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'prodName': prodName,
      'quantity': quantity,
      'oldPrice': oldPrice,
      'price': price,
      'orderId': orderId,
    };
  }

  OrderItem.fromJson(Map<String, dynamic> json)
    : prodName = json['prodName'] ?? '',
      quantity = json['quantity'] ?? 0,
      oldPrice = json['oldPrice'] != null ? json['oldPrice'].toDouble() : 0.0,
      price = json['price'] != null ? json['price'].toDouble() : 0.0,
      orderId = json['orderId'] ?? '';
}
