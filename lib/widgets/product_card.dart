import 'package:dev_shop/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/colors.dart';
import '../models/product.dart';
import 'package:get/get.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onFavoriteToggle,
    this.onAddToCart,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final imageHeight = width * 0.6;

        // 🔹 Escala dinâmica de texto (com mínimo e máximo)
        double scale(double base, {double min = 12, double max = 22}) {
          final value = width * base;
          return value.clamp(min, max);
        }

        return GestureDetector(
          onTapDown: (_) => _animationController.forward(),
          onTapUp: (_) => _animationController.reverse(),
          onTapCancel: () => _animationController.reverse(),
          onTap: widget.onTap,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===================== IMAGEM =====================
                    Stack(
                      children: [
                        Container(
                          height: imageHeight,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(18),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(18),
                            ),
                            child: Image.network(
                              widget.product.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: width * 0.2,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // 🔹 DESCONTO
                        if (widget.product.isOnSale &&
                            widget.product.discountPercentage > 0)
                          Positioned(
                            top: width * 0.03,
                            left: width * 0.03,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '-${widget.product.discountPercentage.toStringAsFixed(0)}%',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: scale(0.04, min: 11, max: 14),
                                ),
                              ),
                            ),
                          ),

                        // 🔹 FAVORITO
                        Positioned(
                          top: width * 0.03,
                          right: width * 0.03,
                          child: Obx(
                            () => GestureDetector(
                              onTap: widget.onFavoriteToggle,
                              child: Container(
                                padding: EdgeInsets.all(width * 0.025),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    widget.product.isFavorite.value
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    key: ValueKey(
                                      widget.product.isFavorite.value,
                                    ),
                                    size: width * 0.14,
                                    color: widget.product.isFavorite.value
                                        ? AppColors.secondary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ===================== CONTEÚDO =====================
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.category,
                                  style: GoogleFonts.poppins(
                                    fontSize: scale(0.04, min: 12, max: 14),
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.product.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: scale(0.045, min: 13, max: 16),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),

                            if (widget.product.rating > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: scale(0.045, min: 14, max: 18),
                                      color: Colors.amber[700],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.product.rating.toStringAsFixed(1),
                                      style: GoogleFonts.poppins(
                                        fontSize: scale(0.04, min: 12, max: 14),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '(${widget.product.reviewCount})',
                                      style: GoogleFonts.poppins(
                                        fontSize: scale(
                                          0.035,
                                          min: 11,
                                          max: 13,
                                        ),
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (widget.product.oldPrice != null)
                                      Text(
                                        'R\$ ${widget.product.oldPrice!.toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: scale(
                                            0.035,
                                            min: 11,
                                            max: 13,
                                          ),
                                          color: AppColors.textSecondary,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    Text(
                                      'R\$ ${widget.product.price.toStringAsFixed(2)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: scale(0.06, min: 15, max: 19),
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    CartController().addProduct(widget.product);
                                    if (widget.onAddToCart != null) {
                                      widget.onAddToCart!();
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(
                                            0.3,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.white,
                                      size: scale(0.14, min: 16, max: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
