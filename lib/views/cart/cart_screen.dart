import 'package:dev_shop/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../models/product.dart';
import '../../widgets/custom_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final CartController cartController = CartController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get totalAmount {
    return cartController.items.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  double get totalSavings {
    return cartController.items.fold(0.0, (sum, item) {
      final oldPrice = item.product.oldPrice;
      if (oldPrice != null) {
        return sum + ((oldPrice - item.product.price) * item.quantity);
      }
      return sum;
    });
  }

  void _updateQuantity(Product product, int newQuantity) {
    setState(() {
      cartController.updateQuantity(product, newQuantity);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newQuantity <= 0
              ? 'Item removido do carrinho'
              : 'Quantidade atualizada',
        ),
        backgroundColor: newQuantity <= 0 ? AppColors.error : AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Limpar Carrinho'),
        content: const Text('Deseja remover todos os itens do carrinho?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() => cartController.clearCart());
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Carrinho limpo com sucesso'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text(
              'Limpar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Finalizar Compra'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total: R\$ ${totalAmount.toStringAsFixed(2)}'),
            if (totalSavings > 0)
              Text(
                'Economia: R\$ ${totalSavings.toStringAsFixed(2)}',
                style: const TextStyle(color: AppColors.success),
              ),
            const SizedBox(height: 16),
            const Text('Confirma a finalização da compra?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() => cartController.clearCart());
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Compra finalizada com sucesso!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = cartController.items;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Meu Carrinho',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _showClearCartDialog,
            ),
        ],
      ),
      body: cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(),
      bottomNavigationBar: cartItems.isNotEmpty
          ? _buildCheckoutSection()
          : null,
    );
  }

  Widget _buildEmptyCart() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(12.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 120,
              color: AppColors.textSecondary.withAlpha(127),
            ),
            const SizedBox(height: 24),
            Text(
              'Seu carrinho está vazio',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Adicione produtos para continuar',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary.withAlpha(178),
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Explorar Produtos',
              onPressed: () => Navigator.pop(context),
              icon: Icons.shopping_bag_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartContent() {
    final cartItems = cartController.items;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            _buildCartSummaryHeader(cartItems),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: cartItems.length,
                itemBuilder: (_, index) => _buildCartItem(cartItems[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummaryHeader(List<CartItem> cartItems) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${cartItems.length} ${cartItems.length == 1 ? 'item' : 'itens'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              if (totalSavings > 0)
                Text(
                  'Economia: R\$ ${totalSavings.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          Text(
            'R\$ ${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: AppColors.background,
                child: item.product.imageUrl.isNotEmpty
                    ? Image.network(
                        item.product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_not_supported,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : const Icon(
                        Icons.shopping_bag,
                        color: AppColors.textSecondary,
                        size: 32,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        'R\$ ${item.product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      if (item.product.oldPrice != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            'R\$ ${item.product.oldPrice!.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.textSecondary.withAlpha(153),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildQuantityButton(
                            Icons.remove,
                            () => _updateQuantity(
                              item.product,
                              item.quantity - 1,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 11),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          _buildQuantityButton(
                            Icons.add,
                            () => _updateQuantity(
                              item.product,
                              item.quantity + 1,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'R\$ ${(item.product.price * item.quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'R\$ ${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            if (totalSavings > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Você economizou:',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'R\$ ${totalSavings.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Finalizar Compra',
              onPressed: _showCheckoutDialog,
              icon: Icons.shopping_cart_checkout,
            ),
          ],
        ),
      ),
    );
  }
}
