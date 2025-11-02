import 'package:dev_shop/controllers/cart_controller.dart';
import 'package:dev_shop/views/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/product_controller.dart';
import '../../core/constants/colors.dart';
import '../../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.product.isFavorite.value
              ? 'Adicionado aos favoritos!'
              : 'Removido dos favoritos!',
        ),
        backgroundColor: widget.product.isFavorite.value
            ? AppColors.success
            : AppColors.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showImageGallery() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: SizedBox(
          height: 400,
          child: PageView.builder(
            itemCount: productImages.length,
            controller: PageController(initialPage: selectedImageIndex),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: productImages[index].isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(productImages[index]),
                          fit: BoxFit.contain,
                        )
                      : null,
                  color: AppColors.background,
                ),
                child: productImages[index].isEmpty
                    ? const Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: AppColors.textSecondary,
                      )
                    : null,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      title: Text(
        widget.product.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: [
        Obx(
          () => IconButton(
            onPressed: _toggleFavorite,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                widget.product.isFavorite.value
                    ? Icons.favorite
                    : Icons.favorite_border,
                key: ValueKey(widget.product.isFavorite.value),
                color: widget.product.isFavorite.value
                    ? Colors.red
                    : Colors.white,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            // Compartilhar produto
          },
          icon: const Icon(Icons.share),
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
          children: [
            GestureDetector(
              onTap: _showImageGallery,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: widget.product.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.product.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 64,
                                color: AppColors.textSecondary,
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Icon(
                            Icons.shopping_bag,
                            size: 64,
                            color: AppColors.textSecondary,
                          ),
                        ),
                ),
              ),
            ),
            if (widget.product.isOnSale ||
                widget.product.discountPercentage > 0)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '-${widget.product.discountPercentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (widget.product.stock <= 5 && widget.product.stock > 0)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Últimas ${widget.product.stock} unidades',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.product.category,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'R\$ ${widget.product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              if (widget.product.oldPrice != null) ...[
                const SizedBox(width: 12),
                Text(
                  'R\$ ${widget.product.oldPrice!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.textSecondary.withOpacity(0.6),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                widget.product.stock > 0 ? Icons.check_circle : Icons.error,
                color: widget.product.stock > 0
                    ? AppColors.success
                    : AppColors.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.product.stock > 0
                    ? 'Em estoque (${widget.product.stock} unidades)'
                    : 'Fora de estoque',
                style: TextStyle(
                  color: widget.product.stock > 0
                      ? AppColors.success
                      : AppColors.error,
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
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: AppColors.warning, size: 24),
                const SizedBox(width: 4),
                Text(
                  widget.product.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
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
                    return Icon(
                      index < widget.product.rating.floor()
                          ? Icons.star
                          : index < widget.product.rating
                          ? Icons.star_half
                          : Icons.star_border,
                      color: AppColors.warning,
                      size: 18,
                    );
                  }),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.product.reviewCount} avaliações',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('Ver todas')),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Descrição',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.product.description,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecsSection() {
    List<Map<String, String>> specs = _getProductSpecs();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Especificações',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...specs
              .map(
                (spec) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          spec['label']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          spec['value']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildRelatedSection() {
    return FutureBuilder<List<Product>>(
      future: productController.getAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) return const SizedBox.shrink();

        final products = snapshot.data ?? [];
        final relatedProducts = products
            .where(
              (p) =>
                  p.category == widget.product.category &&
                  p.id != widget.product.id,
            )
            .take(4)
            .toList();

        if (relatedProducts.isEmpty) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Produtos relacionados',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: relatedProducts.length,
                  itemBuilder: (context, index) {
                    final product = relatedProducts[index];
                    return Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppColors.background,
                                    ),
                                    child: product.imageUrl.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.network(
                                              product.imageUrl,
                                              width: double.infinity,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return const Icon(
                                                      Icons.image_not_supported,
                                                      color: AppColors
                                                          .textSecondary,
                                                    );
                                                  },
                                            ),
                                          )
                                        : const Icon(
                                            Icons.shopping_bag,
                                            color: AppColors.textSecondary,
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'R\$ ${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
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
      },
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.textSecondary.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: quantity > 1
                        ? () {
                            setState(() {
                              quantity--;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.remove, size: 18),
                    color: AppColors.textSecondary,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '$quantity',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: quantity < widget.product.stock
                        ? () {
                            setState(() {
                              quantity++;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.add, size: 18),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),

            FloatingActionButton.extended(
              onPressed: () {
                CartController().addProduct(widget.product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Produto adicionado!',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                widget.product.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.all(20),
                    duration: const Duration(seconds: 3),
                  ),
                );
                Navigator.pop(context);
              },
              backgroundColor: const Color.fromARGB(255, 203, 255, 107),
              icon: const Icon(
                Icons.shopping_cart,
                color: Color.fromARGB(255, 41, 41, 41),
              ),
              label: Text(
                'Comprar',
                style: GoogleFonts.poppins(
                  color: const Color.fromARGB(255, 41, 41, 41),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getProductSpecs() {
    switch (widget.product.category.toLowerCase()) {
      case 'eletrônicos':
        return [
          {'label': 'Marca', 'value': 'Apple/Samsung'},
          {'label': 'Garantia', 'value': '1 ano'},
          {'label': 'Cor', 'value': 'Titanium/Preto'},
          {'label': 'Peso', 'value': '221g'},
        ];
      case 'calçados':
        return [
          {'label': 'Marca', 'value': 'Nike/Adidas'},
          {'label': 'Material', 'value': 'Sintético'},
          {'label': 'Numeração', 'value': '35 ao 44'},
          {'label': 'Cor', 'value': 'Múltiplas cores'},
        ];
      case 'games':
        return [
          {'label': 'Plataforma', 'value': 'PlayStation 5'},
          {'label': 'Armazenamento', 'value': '825GB SSD'},
          {'label': 'Resolução', 'value': '4K UHD'},
          {'label': 'Garantia', 'value': '1 ano'},
        ];
      default:
        return [
          {'label': 'Categoria', 'value': widget.product.category},
          {'label': 'Disponibilidade', 'value': 'Em estoque'},
          {'label': 'Entrega', 'value': '2-5 dias úteis'},
          {'label': 'Garantia', 'value': '30 dias'},
        ];
    }
  }
}
