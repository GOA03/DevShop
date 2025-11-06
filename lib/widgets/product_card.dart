import 'package:dev_shop/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/colors.dart'; // Ainda usado para cores de "marca" (ex: secondary, warning)
import '../models/product_model.dart';
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
    // Obter as cores do tema atual (claro ou escuro)
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            // ALTERAÇÃO: Cor do card vinda do tema (branco no claro, cinza escuro no escuro)
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                // ALTERAÇÃO: Sombra subtil que funciona em ambos os modos
                color: Colors.black.withOpacity(theme.brightness == Brightness.light ? 0.05 : 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      // ALTERAÇÃO: Cor de fundo da imagem (placeholder) vinda do tema
                      // Usa a cor de fundo do ecrã, que é ligeiramente diferente da superfície do card
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Image.network(
                        widget.product.imageUrl,
                        width: double.maxFinite,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              // ALTERAÇÃO: Cor do ícone de erro vinda do tema
                              color: colorScheme.onSurface.withOpacity(0.4),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Selo de desconto (mantém cor de "marca" fixa)
                  if (widget.product.isOnSale &&
                      widget.product.discountPercentage > 0)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary, // Cor de destaque (vermelho)
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '-${widget.product.discountPercentage.toStringAsFixed(0)}%',
                          style: GoogleFonts.poppins(
                            color: Colors.white, // Texto branco sempre contrasta com AppColors.secondary
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                  // Botão Favorito
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Obx(
                          () => GestureDetector(
                        onTap: widget.onFavoriteToggle,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            // ALTERAÇÃO: Cor de fundo vinda do tema
                            color: colorScheme.surface,
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
                              key: ValueKey(widget.product.isFavorite.value),
                              size: 20,
                              // ALTERAÇÃO: Cor do ícone inativo vinda do tema
                              color: widget.product.isFavorite.value
                                  ? AppColors.secondary // Cor de "ativo" (vermelho)
                                  : colorScheme.onSurface.withOpacity(0.7), // Cor de "inativo" (tema)
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Selo de Stock Baixo (mantém cor de "aviso" fixa)
                  if (widget.product.stock <= 5 && widget.product.stock > 0)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning, // Cor de aviso (laranja)
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Últimas ${widget.product.stock} unidades',
                          style: GoogleFonts.poppins(
                            color: Colors.white, // Texto branco contrasta com AppColors.warning
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Secção de Texto (Informações)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Categoria
                          Text(
                            widget.product.category,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              // ALTERAÇÃO: Cor primária vinda do tema
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Nome do Produto
                          Text(
                            widget.product.name,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              // ALTERAÇÃO: Cor do texto principal vinda do tema
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),

                      // Rating
                      if (widget.product.rating > 0)
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber[700], // Manter cor de estrela fixa (amarelo)
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.product.rating.toStringAsFixed(1),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                // ALTERAÇÃO: Cor do texto vinda do tema
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${widget.product.reviewCount})',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                // ALTERAÇÃO: Cor do texto secundário vinda do tema
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                      // Preço e Botão Adicionar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Preço Antigo (se existir)
                              if (widget.product.oldPrice != null)
                                Text(
                                  widget.product.category,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    // ALTERAÇÃO: Cor do texto secundário vinda do tema
                                    color: colorScheme.onSurface.withOpacity(0.7),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              // Preço Atual
                              Text(
                                'R\$ ${widget.product.price.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  // ALTERAÇÃO: Cor primária vinda do tema
                                  color: colorScheme.primary,
                                ),
                              ),

                          // Botão Adicionar ao Carrinho
                          GestureDetector(
                            onTap: widget.onAddToCart,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                // ALTERAÇÃO: Cor primária vinda do tema
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    // ALTERAÇÃO: Sombra da cor primária vinda do tema
                                    color: colorScheme.primary.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.add_shopping_cart,
                                // ALTERAÇÃO: Cor do ícone que contrasta com a cor primária
                                color: colorScheme.onPrimary,
                                size: 20,
                              ),
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