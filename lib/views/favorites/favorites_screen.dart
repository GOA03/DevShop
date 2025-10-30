import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../core/constants/colors.dart'; // Ainda usado para cor de "favorito" (vermelho)
import '../products/product_detail_screen.dart';
import '../../models/product_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find();
    // Obter o tema atual
    final theme = Theme.of(context);

    return Scaffold(
      // ALTERAÇÃO: Cor de fundo vinda do tema
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Meus Favoritos',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            // A cor do título já vem da AppBarTheme
          ),
        ),
        // ALTERAÇÃO: Cores da AppBar vindas do tema
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor, // Cor do ícone de voltar e do título
        elevation: 1,
      ),
      body: Obx(() { // Obx reage a mudanças na lista de favoritos
        if (productController.favoriteProducts.isEmpty) {
          // --- ECRÃ DE ESTADO VAZIO ---
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 80,
                  // ALTERAÇÃO: Cor do ícone vinda do tema
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 20),
                Text(
                  'Sua lista de favoritos está vazia!',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    // ALTERAÇÃO: Cor do texto vinda do tema
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Clique no coração dos produtos que você ama.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    // ALTERAÇÃO: Cor do texto vinda do tema
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        } else {
          // --- LISTA DE FAVORITOS ---
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: productController.favoriteProducts.length,
            itemBuilder: (context, index) {
              final product = productController.favoriteProducts[index];
              // Chama o método que constrói o card (já refatorado)
              return _buildFavoriteProductCard(context, product, productController);
            },
          );
        }
      }),
    );
  }

  // Método para construir cada Card de favorito
  Widget _buildFavoriteProductCard(
      BuildContext context, Product product, ProductController controller) {

    // Obter o tema atual
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      // O Card usa automaticamente o CardTheme (que já definimos no app_theme.dart)
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        shadowColor: Colors.black.withOpacity(theme.brightness == Brightness.light ? 0.1 : 0.2),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // ALTERAÇÃO: Ícone de erro usa cor do tema
                    return Icon(
                      Icons.image_not_supported,
                      size: 60,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        // ALTERAÇÃO: Cor do texto vinda do tema
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'R\$ ${product.price.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        // ALTERAÇÃO: Cor do preço vinda do tema
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.favorite,
                  // Cor de "favorito" (vermelho) é uma cor de status, mantemos fixa
                  color: Colors.redAccent,
                  size: 28,
                ),
                onPressed: () {
                  controller.toggleFavorite(product);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}