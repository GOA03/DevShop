import 'package:get/get.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import 'product_controller.dart';

class CartController extends GetxController {
  final ProductController _productController = Get.find<ProductController>();

  final RxList<CartItem> cartItems = <CartItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load cart from storage if needed, for now empty
  }

  // Get cart items with product details
  List<Map<String, dynamic>> get cartItemsWithDetails {
    return cartItems.map((cartItem) {
      final product = _productController.getProductById(cartItem.productId);
      if (product != null) {
        return {
          'cartItem': cartItem,
          'product': product,
        };
      } else {
        // Fallback product
        final fallbackProduct = Product(
          id: cartItem.productId,
          name: 'Produto não encontrado',
          description: '',
          price: 0.0,
          imageUrl: '',
          category: 'Desconhecido',
        );
        return {
          'cartItem': cartItem,
          'product': fallbackProduct,
        };
      }
    }).toList();
  }

  // Add product to cart
  void addToCart(String productId, {int quantity = 1}) {
    final existingIndex = cartItems.indexWhere((item) => item.productId == productId);
    if (existingIndex >= 0) {
      cartItems[existingIndex] = cartItems[existingIndex].copyWith(
        quantity: cartItems[existingIndex].quantity + quantity,
      );
    } else {
      cartItems.add(CartItem(productId: productId, quantity: quantity));
    }
    cartItems.refresh();
  }

  // Remove product from cart
  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item.productId == productId);
  }

  // Update quantity
  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
    } else {
      final index = cartItems.indexWhere((item) => item.productId == productId);
      if (index >= 0) {
        cartItems[index] = cartItems[index].copyWith(quantity: newQuantity);
        cartItems.refresh();
      }
    }
  }

  // Clear cart
  void clearCart() {
    cartItems.clear();
  }

  // Get total amount
  double get totalAmount {
    return cartItemsWithDetails.fold(0.0, (sum, item) {
      final product = item['product'] as Product;
      final cartItem = item['cartItem'] as CartItem;
      return sum + (product.price * cartItem.quantity);
    });
  }

  // Get total savings
  double get totalSavings {
    return cartItemsWithDetails.fold(0.0, (sum, item) {
      final product = item['product'] as Product;
      final cartItem = item['cartItem'] as CartItem;
      if (product.oldPrice != null) {
        return sum + ((product.oldPrice! - product.price) * cartItem.quantity);
      }
      return sum;
    });
  }

  // Get item count
  int get itemCount {
    return cartItems.length;
  }

  // Get total quantity
  int get totalQuantity {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}
