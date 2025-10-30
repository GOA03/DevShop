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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
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
                    /*_buildCategories(),
                    const SizedBox(height: 25),*/
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
    // Determina a cor de fundo da AppBar com base no tema
    final appBarColor = Theme.of(context).appBarTheme.backgroundColor;
    final iconColor = Theme.of(context).appBarTheme.foregroundColor;
    final iconBgColor = Theme.of(context).brightness == Brightness.light
        ? Colors.white.withAlpha(51)
        : Colors.white.withAlpha(20);

    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      // ALTERAÇÃO: Cor de fundo vinda do tema
      backgroundColor: appBarColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // ALTERAÇÃO: Cor de fundo do ícone reage ao tema
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.shopping_bag,
                // ALTERAÇÃO: Cor do ícone vinda do tema
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              AppStrings.appName,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                // A cor do texto já é definida pelo tema da AppBar
              ),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            // ALTERAÇÃO: Gradiente apenas no modo claro
            gradient: Theme.of(context).brightness == Brightness.light
                ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDark],
            )
                : null, // Sem gradiente no modo escuro
            // Cor sólida para ambos os modos (no escuro, será a cor principal)
            color: appBarColor,
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
              // ALTERAÇÃO: Cor de fundo do ícone reage ao tema
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.notifications_outlined,
              // ALTERAÇÃO: Cor do ícone vinda do tema
              color: iconColor,
            ),
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // ALTERAÇÃO: Cor de fundo do ícone reage ao tema
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            // ALTERAÇÃO: Cor do ícone vinda do tema
            child: Icon(Icons.person_outline, color: iconColor),
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
          // ALTERAÇÃO: Cor da barra de pesquisa vinda do tema (surface = branco/cinza escuro)
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ALTERAÇÃO: Cor da sombra mais subtil
              color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.05 : 0.1),
              blurRadius: 30,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          onChanged: productController.search,
          // ALTERAÇÃO: Estilo do texto vindo do tema
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'Buscar produtos...',
            // ALTERAÇÃO: Cor do hint vinda do tema
            hintStyle: GoogleFonts.poppins(
              color: Theme.of(context).inputDecorationTheme.hintStyle?.color,
              fontSize: 14,
            ),
            suffixIcon: Container(
              margin: const EdgeInsets.only(right: 5),
              child: IconButton(
                onPressed: () {},
                // ALTERAÇÃO: Cor do ícone vinda do tema
                icon: Icon(Icons.search, color: Theme.of(context).inputDecorationTheme.prefixIconColor),
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
    // Os banners são conteúdo de "marca", então manter as cores fixas
    // (AppColors.primary, AppColors.secondary, etc.) é aceitável.
    final List<Map<String, dynamic>> banners = [
      {
        'title': 'Mega Ofertas',
        'subtitle': 'Até 70% OFF',
        'color1': AppColors.primary,
        'color2': AppColors.primaryDark,
        'icon': Icons.local_offer,
      },
      {
        'title': 'Novidades',
        'subtitle': 'Confira os lançamentos',
        'color1': AppColors.accent,
        'color2': const Color(0xFF319795),
        'icon': Icons.new_releases,
      },
    ];

    return Column(
      children: [
        SizedBox(
          height: 180,
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
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
        // Indicador de página
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
                // ALTERAÇÃO: Cores do indicador de página vêm do tema
                color: _currentPage == index
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /*Widget _buildCategories() {  //categorias não vai mais estar na home
    final Map<String, Map<String, dynamic>> categoryStyles = {
      'Eletrônicos': {'icon': Icons.phone_android, 'color': Colors.blue},
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
                  // ALTERAÇÃO: Cor do texto vinda do tema
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navega para o ecrã de produtos SEM filtro
                  productController.selectedCategories.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductsListScreen(),
                    ),
                  );
                },
                child: Text(
                  'Ver todas',
                  style: GoogleFonts.poppins(
                    // ALTERAÇÃO: Cor do botão vinda do tema
                    color: Theme.of(context).colorScheme.primary,
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
                      // Navega para o ecrã de lista de produtos
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductsListScreen(),
                        ),
                      );
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
                            // ALTERAÇÃO: Cor do texto reage ao tema
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
  }*/

  Widget _buildFeaturedProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Produtos em Destaque',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  // ALTERAÇÃO: Cor do texto vinda do tema
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              // O botão "Ver todos" foi removido na etapa anterior
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
                        builder: (context) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Container(
                    width: 180,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      // ALTERAÇÃO: Cor do card vinda do tema
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.05 : 0.1),
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
                                  return Icon(
                                    Icons.image_not_supported,
                                    size: 60,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                                  );
                                },
                              ),
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
                                      // ALTERAÇÃO: Cor do fundo do botão favorito vinda do tema
                                      color: Theme.of(context).colorScheme.surface,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      product.isFavorite.value
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 20,
                                      // ALTERAÇÃO: Cor do ícone favorito reage ao tema (exceto quando ativo)
                                      color: product.isFavorite.value
                                          ? Colors.redAccent
                                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
                                  // ALTERAÇÃO: Cor do texto vinda do tema
                                  color: Theme.of(context).colorScheme.onSurface,
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
                                      // ALTERAÇÃO: Cor do texto vinda do tema
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
                                      // ALTERAÇÃO: Cor do preço vinda do tema
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  if (product.oldPrice != null) ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      'R\$ ${product.oldPrice!.toStringAsFixed(2)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        // ALTERAÇÃO: Cor do texto vindo do tema
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
        // ALTERAÇÃO: Cor de fundo vinda do tema
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.05 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // ALTERAÇÃO: Cor de fundo vinda do tema
        backgroundColor: Theme.of(context).colorScheme.surface,
        // ALTERAÇÃO: Cor do item selecionado vinda do tema
        selectedItemColor: Theme.of(context).colorScheme.primary,
        // ALTERAÇÃO: Cor do item não selecionado vinda do tema
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
