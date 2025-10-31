import 'package:dev_shop/models/product.dart';

class CartController {
  // Singleton
  static final CartController _instance = CartController._internal();
  factory CartController() => _instance;
  CartController._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addProduct(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
  }

  void removeProduct(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
  }

  void updateQuantity(Product product, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
    }
  }

  void clearCart() {
    _items.clear();
  }

  double get totalAmount =>
      _items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  double get totalSavings => _items.fold(0, (sum, item) {
    if (item.product.oldPrice != null) {
      return sum +
          ((item.product.oldPrice! - item.product.price) * item.quantity);
    }
    return sum;
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}
