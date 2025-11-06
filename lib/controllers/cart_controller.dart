import 'package:dev_shop/controllers/product_controller.dart';
import 'package:dev_shop/data/cart/cart_dao.dart';
import 'package:dev_shop/data/cart/cart_model.dart';
import 'package:dev_shop/models/product.dart';

class CartController {
  // Singleton
  static final CartController _instance = CartController._internal();
  factory CartController() => _instance;
  CartController._internal();

  final CartDao _dao = CartDao();
  List<CartItem> items = [];
  int? _userId; // Guarda o ID do usuário atual

  //List<CartItem> get items => _items;

  /// Load cart items for the given user; call this (await) after obtaining the userId.
  Future<void> loadItems(int userId) async {
    _userId = userId;
    items = await getCartItens(userId);
  }

  void addProduct(Product product) async {
    if (_userId == null) {
      return;
    }

    final index = items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      // Produto já existe → incrementa quantidade
      items[index].quantity++;
      await _dao.increaseQuantity(_userId!, product.id);
    } else {
      // Produto novo → insere no carrinho e banco
      items.add(CartItem(product: product, quantity: 1));
      final newCart = CartModel(1, _userId!, product.id);
      await _dao.save(newCart);
    }
  }

  void removeProduct(Product product) async {
    if (_userId == null) return;

    items.removeWhere((item) => item.product.id == product.id);
    await _dao.delete(_userId!, product.id);
  }

  /// Incrementa a quantidade de um produto
  Future<void> increaseQuantity(Product product) async {
    if (_userId == null) return;

    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index < 0) return;

    items[index].quantity++;
    await _dao.increaseQuantity(_userId!, product.id);
  }

  /// Decrementa a quantidade de um produto
  Future<void> decreaseQuantity(Product product) async {
    if (_userId == null) return;

    final index = items.indexWhere((item) => item.product.id == product.id);

    if (index < 0) return;

    final newQty = await _dao.decreaseQuantity(_userId!, product.id);
    if (newQty == 0) {
      items.removeAt(index);
    } else {
      items[index].quantity = newQty;
    }
  }

  void clearCart() async {
    _dao.deleteAll(_userId!);
    items = [];
  }

  double get totalAmount =>
      items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  double get totalSavings => items.fold(0, (sum, item) {
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

Future<List<CartItem>> getCartItens(int userId) async {
  final CartDao cartDao = CartDao();
  final ProductController productController = ProductController();

  final List<CartModel> cartItens = await cartDao.findAll(userId);

  final List<Product> products = await productController.getAll();
  Map<int, Product> productMap = {
    for (var product in products) product.id: product,
  };

  final List<CartItem> validItens = [];

  for (final cart in cartItens) {
    final product = productMap[cart.prodId];
    if (product == null || !product.isOnSale) {
      await cartDao.delete(userId, cart.prodId);
      continue;
    }

    validItens.add(CartItem(product: product, quantity: cart.quantity));
  }
  return validItens;
}
