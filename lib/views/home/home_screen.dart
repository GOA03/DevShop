import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/product_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../products/products_list_screen.dart';
import '../products/product_detail_screen.dart';
import '../profile/profile_screen.dart';
import '../favorites/favorites_screen.dart';
import '../cart/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final ProductController productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    _buildPromoBanner(),
                    const SizedBox(height: 25),
                    _buildCategories(),
                    const SizedBox(height: 25),
                    _buildFeaturedProducts(),
                    const SizedBox(height: 25),
                    _buildSpecialOffers(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildCartFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shopping_bag,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              AppStrings.appName,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -50,
                top: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(25),
                  ),
                ),
              ),
              Positioned(
                left: -30,
                bottom: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
            ),
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person_outline, color: Colors.white),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 30,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          onChanged: productController.search,
          decoration: InputDecoration(
            hintText: 'Buscar produtos...',
            hintStyle: GoogleFonts.poppins(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            suffixIcon: Container(
              margin: const EdgeInsets.only(right: 5),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: AppColors.textSecondary),
              ),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    final List<Map<String, dynamic>> banners = [
      {
        'title': 'Mega Ofertas',
        'subtitle': 'Até 70% OFF',
        'color1': AppColors.primary,
        'color2': AppColors.primaryDark,
        'icon': Icons.local_offer,
      },
      {
        'title': 'Frete Grátis',
        'subtitle': 'Em compras acima de R\$99',
        'color1': AppColors.secondary,
        'color2': const Color(0xFFE53E3E),
        'icon': Icons.local_shipping,
      },
      {
        'title': 'Novidades',
        'subtitle': 'Confira os lançamentos',
        'color1': AppColors.accent,
        'color2': const Color(0xFF319795),
        'icon': Icons.new_releases,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          SizedBox(
            height: 190,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: banners.length,
              itemBuilder: (context, index) {
                final banner = banners[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [banner['color1'], banner['color2']],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: banner['color1'].withAlpha(127),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -30,
                        bottom: -30,
                        child: Icon(
                          banner['icon'],
                          size: 150,
                          color: Colors.white.withAlpha(25),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              banner['title'],
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              banner['subtitle'],
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white.withAlpha(230),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Ver mais',
                                style: GoogleFonts.poppins(
                                  color: banner['color1'],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 25 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColors.primary
                      : AppColors.textSecondary.withAlpha(76),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final Map<String, Map<String, dynamic>> categoryStyles = {
      "Eletrônicos": {'icon': Icons.phone_android, 'color': Colors.blue},
      'Calçados': {'icon': Icons.directions_walk, 'color': Colors.pink},
      'Games': {'icon': Icons.sports_esports, 'color': Colors.green},
      'Moda': {'icon': Icons.checkroom, 'color': Colors.purple},
      'Esportes': {'icon': Icons.sports_soccer, 'color': Colors.orange},
    };
    const defaultStyle = {'icon': Icons.category, 'color': Colors.grey};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categorias',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Ver todas',
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: productController.availableCategories.length,
            itemBuilder: (context, index) {
              final categoryName = productController.availableCategories[index];
              final style = categoryStyles[categoryName] ?? defaultStyle;

              return Obx(() {
                final isSelected = productController.selectedCategories
                    .contains(categoryName);
                return Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: GestureDetector(
                    onTap: () {
                      productController.toggleCategory(categoryName);
                    },
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (style['color'] as Color)
                                : (style['color'] as Color).withAlpha(25),
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected
                                ? Border.all(
                                    color: style['color'] as Color,
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: Icon(
                            style['icon'] as IconData,
                            color: isSelected
                                ? Colors.white
                                : (style['color'] as Color),
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          categoryName,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Produtos em Destaque',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductsListScreen(),
                    ),
                  );
                },
                child: Text(
                  'Ver todos',
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 280,
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: productController.filteredProducts.length,
              itemBuilder: (context, index) {
                final product = productController.filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Container(
                    width: 180,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
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
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: Image.network(
                                product.imageUrl,
                                height: 140,
                                width: double.maxFinite,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.image_not_supported,
                                    size: 60,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: product.isOnSale
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Obx(
                                () => GestureDetector(
                                  onTap: () {
                                    productController.toggleFavorite(product);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(25),
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      product.isFavorite.value
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 20,
                                      color: product.isFavorite.value
                                          ? Colors.redAccent
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.rating.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Column(
                                children: [
                                  Text(
                                    'R\$ ${product.price.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  if (product.oldPrice != null) ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      'R\$ ${product.oldPrice!.toStringAsFixed(2)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialOffers() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B46C1), Color(0xFF9F7AEA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B46C1).withAlpha(76),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '🔥 Oferta Especial',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Ganhe 10% OFF',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Na sua primeira compra',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withAlpha(230),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'PRIMEIRA10',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF6B46C1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.local_offer_outlined,
            size: 80,
            color: Colors.white24,
          ),
        ],
      ),
    );
  }

  Widget _buildCartFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withAlpha(76),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartScreen()),
          );
        },
        backgroundColor: AppColors.secondary,
        icon: const Icon(Icons.shopping_cart, color: Colors.white),
        label: Text(
          'Carrinho',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Produtos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductsListScreen(),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}
