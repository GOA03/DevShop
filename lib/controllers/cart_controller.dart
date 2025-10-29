import 'package:dev_shop/models/product.dart';

class CartController {
  static final CartController _instancia = CartController._interno();
  factory CartController() => _instancia;
  CartController._interno();

  final List<Product> itens = [];

  void adicionar(Product produto) {
    itens.add(produto);
  }
}
