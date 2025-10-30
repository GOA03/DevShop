import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/product_controller.dart';
import '../../core/constants/colors.dart'; // Ainda usado para cores de status (success, error, warning) e de "marca" (rating)
import '../../models/product_model.dart';
import '../../widgets/custom_button.dart';
import '../cart/cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {

  // ... (Controladores de animação, initState, dispose, _toggleFavorite, _showImageGallery, _addToCart)
  // (Nenhuma alteração de tema necessária nesses métodos, exceto nos
  // SnackBar e Diálogo, que já usam cores de status ou o tema do Material)
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  late final ProductController productController;

  int quantity = 1;
  int selectedImageIndex = 0;

  List<String> get productImages => [
    widget.product.imageUrl,
    widget.product.imageUrl,
    widget.product.imageUrl,
  ];

  @override
  void initState() {
    super.initState();
    productController = Get.find();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    productController.toggleFavorite(widget.product);
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.product.isFavorite.value
              ? 'Adicionado aos favoritos!'
              : 'Removido dos favoritos!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor:
        widget.product.isFavorite.value ? AppColors.success : Colors.orange.shade700,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showImageGallery() {
    if (productImages.length <= 1) return;
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: productImages.length,
                  controller: PageController(initialPage: selectedImageIndex),
                  onPageChanged: (index) => setState(() => selectedImageIndex = index),
                  itemBuilder: (context, index) {
                    return InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          // ALTERAÇÃO: Cor de fundo da imagem vinda do tema (branco ou cinza escuro)
                          color: Theme.of(context).colorScheme.surface,
                          image: productImages[index].isNotEmpty
                              ? DecorationImage(
                            image: NetworkImage(productImages[index]),
                            fit: BoxFit.contain,
                          )
                              : null,
                        ),
                        child: productImages[index].isEmpty
                            ? const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 64, color: AppColors.textSecondary,
                          ),
                        )
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Indicador de página (bolinhas)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(productImages.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: selectedImageIndex == index ? 12 : 8,
                    height: selectedImageIndex == index ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // ALTERAÇÃO: Cor do indicador vinda do tema
                      color: selectedImageIndex == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade600, // Cinza escuro para inativo
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToCart() {
    HapticFeedback.mediumImpact();

    // SnackBar de sucesso (verde) é uma cor de status, mantemos fixa.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Adicionado ao carrinho!', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  Text(
                    '${widget.product.name} (x$quantity)',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withOpacity(0.9)),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Ver carrinho',
          textColor: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.2),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const CartScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
                        .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          },
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ALTERAÇÃO: Cor de fundo vinda do tema
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageGallery(),
                    _buildProductInfo(),
                    _buildRatingSection(),
                    _buildDescriptionSection(),
                    _buildSpecsSection(),
                    _buildRelatedSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      // ALTERAÇÃO: Cores da AppBar vindas do tema
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      elevation: 2,
      title: Text(
        widget.product.name,
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        Obx(
              () => IconButton(
            onPressed: _toggleFavorite,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                widget.product.isFavorite.value
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                key: ValueKey(widget.product.isFavorite.value),
                // Cor de favorito (vermelho) é fixa, cor de inativo vem do tema
                color: widget.product.isFavorite.value
                    ? Colors.redAccent.shade100
                // ALTERAÇÃO: Cor do ícone inativo vinda do tema
                    : Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Compartilhar ${widget.product.name}... (em breve)')),
            );
          },
          icon: const Icon(Icons.share_outlined),
        ),
      ],
    );
  }

  Widget _buildImageGallery() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        height: 300,
        margin: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: _showImageGallery,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  // ALTERAÇÃO: Cor de fundo vinda do tema
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      // ALTERAÇÃO: Sombra reage ao tema
                      color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.1 : 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Hero(
                  tag: 'product_${widget.product.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: widget.product.imageUrl.isNotEmpty
                        ? Image.network(
                      productImages[selectedImageIndex],
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                            // ALTERAÇÃO: Cor do loading vinda do tema
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 64,
                            // ALTERAÇÃO: Cor do ícone vinda do tema
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        );
                      },
                    )
                        : Center(
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 64,
                        // ALTERAÇÃO: Cor do ícone vinda do tema
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Selos (desconto, stock) mantêm cores de "marca" fixas
            if (widget.product.isOnSale && widget.product.discountPercentage > 0)
              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    '-${widget.product.discountPercentage.toStringAsFixed(0)}%',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            if (widget.product.stock <= 5 && widget.product.stock > 0)
              Positioned(
                top: 12, right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    'Últimas ${widget.product.stock}!',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            if (productImages.length > 1)
              Positioned(
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    '${selectedImageIndex + 1} / ${productImages.length}',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // ALTERAÇÃO: Cor do card vinda do tema
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.05 : 0.1),
            blurRadius: 10, offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.name,
            style: GoogleFonts.poppins(
              fontSize: 24, fontWeight: FontWeight.bold,
              // ALTERAÇÃO: Cor do texto vinda do tema
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              // ALTERAÇÃO: Cor do chip vinda do tema
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.product.category,
              style: GoogleFonts.poppins(
                // ALTERAÇÃO: Cor do texto do chip vinda do tema
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12, fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'R\$ ${widget.product.price.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 28, fontWeight: FontWeight.bold,
                  // ALTERAÇÃO: Cor do preço vinda do tema
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              if (widget.product.oldPrice != null) ...[
                const SizedBox(width: 12),
                Text(
                  'R\$ ${widget.product.oldPrice!.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    decoration: TextDecoration.lineThrough,
                    // ALTERAÇÃO: Cor do preço antigo vinda do tema
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Cores de status (success/error) são mantidas
              Icon(
                widget.product.stock > 0 ? Icons.check_circle_outline_rounded : Icons.highlight_off_rounded,
                color: widget.product.stock > 0 ? AppColors.success : AppColors.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.product.stock > 0
                    ? 'Em stock (${widget.product.stock} ${widget.product.stock == 1 ? "unidade" : "unidades"})'
                    : 'Fora de stock',
                style: GoogleFonts.poppins(
                  // Cores de status são mantidas
                  color: widget.product.stock > 0 ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    if (widget.product.rating <= 0 && widget.product.reviewCount <= 0) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ALTERAÇÃO: Cor do card vinda do tema
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.05 : 0.1),
            blurRadius: 10, offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              // Cor de "aviso" (amarelo) é mantida
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: AppColors.warning, size: 22),
                const SizedBox(width: 6),
                Text(
                  widget.product.rating.toStringAsFixed(1),
                  style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold,
                    // ALTERAÇÃO: Cor do texto vinda do tema
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(5, (index) {
                    double rating = widget.product.rating;
                    IconData iconData;
                    if (index < rating.floor()) {
                      iconData = Icons.star_rounded;
                    } else if (index < rating && (rating - index) >= 0.5) {
                      iconData = Icons.star_half_rounded;
                    } else {
                      iconData = Icons.star_border_rounded;
                    }
                    // Cor de estrela (amarelo) é mantida
                    return Icon(iconData, color: AppColors.warning, size: 20);
                  }),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.product.reviewCount} ${widget.product.reviewCount == 1 ? "avaliação" : "avaliações"}',
                  style: GoogleFonts.poppins(
                    // ALTERAÇÃO: Cor do texto vinda do tema
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            // A cor do TextButton virá do tema automaticamente
            child: Text('Ver todas', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    if (widget.product.description.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // ALTERAÇÃO: Cor do card vinda do tema
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.05 : 0.1),
            blurRadius: 10, offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Descrição',
            style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.bold,
              // ALTERAÇÃO: Cor do texto vinda do tema
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.product.description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              // ALTERAÇÃO: Cor do texto vinda do tema
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecsSection() {
    List<Map<String, String>> specs = _getProductSpecs();
    if (specs.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // ALTERAÇÃO: Cor do card vinda do tema
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.05 : 0.1),
            blurRadius: 10, offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Especificações',
            style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.bold,
              // ALTERAÇÃO: Cor do texto vinda do tema
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ...specs.map(
                (spec) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      spec['label']!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        // ALTERAÇÃO: Cor do texto vinda do tema
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Text(
                      spec['value']!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        // ALTERAÇÃO: Cor do texto vinda do tema
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).toList(),
        ],
      ),
    );
  }

  Widget _buildRelatedSection() {
    List<Product> relatedProducts = mockProducts
        .where((p) => p.category == widget.product.category && p.id != widget.product.id)
        .take(4)
        .toList();

    if (relatedProducts.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Produtos Relacionados',
            style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.bold,
              // ALTERAÇÃO: Cor do texto vinda do tema
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: relatedProducts.length,
              itemBuilder: (context, index) {
                final product = relatedProducts[index];
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pushReplacement( context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => ProductDetailScreen(product: product),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                    // O Card usará automaticamente o CardTheme do tema
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              // ALTERAÇÃO: Cor de fundo vinda do tema
                              color: Theme.of(context).colorScheme.background,
                              child: product.imageUrl.isNotEmpty
                                  ? Image.network( product.imageUrl, fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                  // ALTERAÇÃO: Cor do ícone vinda do tema
                                  Center(child: Icon(Icons.broken_image_outlined, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))))
                              // ALTERAÇÃO: Cor do ícone vinda do tema
                                  : Center(child: Icon(Icons.shopping_bag_outlined, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    product.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13, fontWeight: FontWeight.w600,
                                      // ALTERAÇÃO: Cor do texto vinda do tema (já está dentro de um Card, então usa onSurface)
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                    maxLines: 2, overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'R\$ ${product.price.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, fontWeight: FontWeight.bold,
                                        // ALTERAÇÃO: Cor do preço vinda do tema
                                        color: Theme.of(context).colorScheme.primary
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        // ALTERAÇÃO: Cor de fundo vinda do tema
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            // ALTERAÇÃO: Sombra reage ao tema
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.1 : 0.3),
            blurRadius: 10, offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                // ALTERAÇÃO: Cor da borda vinda do tema
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                    icon: const Icon(Icons.remove, size: 18),
                    // ALTERAÇÃO: Cor do ícone vinda do tema (ou cinza se desabilitado)
                    color: quantity > 1 ? Theme.of(context).colorScheme.onSurface : Colors.grey.shade600,
                    splashRadius: 20,
                    constraints: const BoxConstraints(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '$quantity',
                      style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.bold,
                        // ALTERAÇÃO: Cor do texto vinda do tema
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: quantity < widget.product.stock ? () => setState(() => quantity++) : null,
                    icon: const Icon(Icons.add, size: 18),
                    // ALTERAÇÃO: Cor do ícone vinda do tema (ou cinza se desabilitado)
                    color: quantity < widget.product.stock ? Theme.of(context).colorScheme.onSurface : Colors.grey.shade600,
                    splashRadius: 20,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                text: 'Adicionar',
                onPressed: widget.product.stock > 0 ? _addToCart : null, // Desabilita se stock=0
                icon: Icons.add_shopping_cart_rounded,
                height: 52,
                // As cores de "desabilitado" são tratadas dentro do CustomButton
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função auxiliar (não precisa de cores do tema)
  List<Map<String, String>> _getProductSpecs() {
    // ... (Lógica permanece a mesma)
    switch (widget.product.category.toLowerCase()) {
      case 'eletrônicos':
        return [
          {'label': 'Marca', 'value': 'Marca Exemplo (Apple/Samsung/Sony)'},
          {'label': 'Modelo', 'value': widget.product.name.split(' ').last},
          {'label': 'Garantia', 'value': '12 meses'},
        ];
      case 'calçados':
        return [
          {'label': 'Marca', 'value': 'Marca Exemplo (Nike/Adidas)'},
          {'label': 'Material', 'value': 'Sintético (Simulado)'},
          {'label': 'Indicado para', 'value': 'Corrida / Casual (Simulado)'},
        ];
      case 'games':
        if (widget.product.id == '7') {
          return [
            {'label': 'Plataforma', 'value': 'PlayStation 5'},
            {'label': 'Armazenamento', 'value': 'SSD 825GB'},
            {'label': 'CPU', 'value': 'AMD Zen 2 (8x @ 3.5GHz)'},
          ];
        }
        return [];
      default:
        return [
          {'label': 'Disponibilidade', 'value': widget.product.stock > 0 ? 'Em estoque' : 'Fora de estoque'},
          {'label': 'SKU', 'value': 'SKU-${widget.product.id}-XYZ'},
        ];
    }
  }
}