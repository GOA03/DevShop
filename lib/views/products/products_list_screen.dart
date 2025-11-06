import 'package:dev_shop/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/colors.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';
import '../cart/cart_screen.dart';
import 'product_detail_screen.dart';

import 'package:get/get.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen>
    with TickerProviderStateMixin {

  final ProductController productController = Get.find();

  bool _isGridView = true;
  bool _showFilters = false;
  bool _isSearching = false;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late AnimationController _animationController;
  late AnimationController _searchAnimationController;
  late AnimationController _filterAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _searchAnimation;
  late Animation<double> _filterSlideAnimation;
  late Animation<Offset> _slideAnimation;

  late final ProductController productController = Get.put(ProductController());

  final List<String> _categories = [
    'Todos',
    'Eletrônicos',
    'Calçados',
    'Games',
    'Roupas',
    'Acessórios',
  ];

  final Map<SortOption, String> _sortOptionNames = {
    SortOption.none: 'Relevância',
    SortOption.priceAsc: 'Menor Preço',
    SortOption.priceDesc: 'Maior Preço',
  };


  @override
  void initState() {
    super.initState();
    _loadProducts();

    _initAnimations();
    _searchFocusNode.addListener(_onSearchFocusChanged);
    // 👈 Aqui
  }

  Future<void> _loadProducts() async {
    try {
      setState(() => _isLoading = true);

      // Carrega produtos normalmente (da API)
      final products = await productController.getAll();
      productController.filteredProducts.assignAll(products);

      // Agora sincroniza apenas o atributo de favoritos
      productController.favoriteDao
          .findAll((await SharedPreferences.getInstance()).getInt('userId')!)
          .then((favorites) {
            final favoriteIds = favorites.map((f) => f.prodId).toSet();
            for (var product in products) {
              product.isFavorite.value = favoriteIds.contains(product.id);
            }

            setState(() {
              _filteredProducts = products;
              _isLoading = false;
            });
          });
    } catch (e) {
      debugPrint('Erro ao carregar produtos: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro ao carregar produtos';
      });
    }
  }

  // ... (initState, _initAnimations, _onSearchFocusChanged, dispose, _toggleFilters, _toggleViewMode)
  // (Nenhuma alteração de tema necessária nesses métodos)

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    _searchAnimationController.dispose();
    _filterAnimationController.dispose();
    super.dispose();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _searchAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _filterSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _filterAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  void _onSearchFocusChanged() {
    if (_searchFocusNode.hasFocus && !_isSearching) {
      setState(() {
        _isSearching = true;
      });
      _searchAnimationController.forward();
    } else if (!_searchFocusNode.hasFocus &&
        _isSearching &&
        _searchController.text.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      _searchAnimationController.reverse();
    }
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });

    if (_showFilters) {
      _filterAnimationController.forward();
      HapticFeedback.lightImpact();
    } else {
      _filterAnimationController.reverse();
    }
  }

  void _toggleViewMode() {
    setState(() {
      _isGridView = !_isGridView;
    });
    HapticFeedback.selectionClick();
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
            child: Column(
              children: [
                _buildSearchSection(),
                _buildCategoryFilter(),
                if (_showFilters) _buildAdvancedFilters(),
                _buildProductsHeader(),
              ],
            ),
          ),
          Obx(() => _buildProductsSliverList()),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    // Obter cores do tema
    final appBarColor = Theme.of(context).appBarTheme.backgroundColor;
    final iconColor = Theme.of(context).appBarTheme.foregroundColor;
    final iconBgColor = Theme.of(context).brightness == Brightness.light
        ? Colors.white.withAlpha(51)
        : Colors.white.withAlpha(20);

    return SliverAppBar(
      expandedHeight: 80,
      floating: false,
      pinned: true,
      elevation: 0,
      // ALTERAÇÃO: Cor da AppBar vinda do tema
      backgroundColor: appBarColor,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: SlideTransition(
          position: _slideAnimation,
          child: Text(
            'Produtos',
            style: GoogleFonts.poppins(
              // A cor já é definida pelo foregroundColor da AppBarTheme
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            // ALTERAÇÃO: Gradiente apenas no modo claro
            gradient: Theme.of(context).brightness == Brightness.light
                ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
            )
                : null,
            color: appBarColor, // Cor sólida para modo escuro
          ),
        ),
      ),
      actions: [
        // Botão de Mudar Visualização
        ScaleTransition(
          scale: _fadeAnimation,
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              // ALTERAÇÃO: Cor de fundo do ícone reage ao tema
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  _isGridView
                      ? Icons.view_list_rounded
                      : Icons.grid_view_rounded,
                  key: ValueKey(_isGridView),
                  // ALTERAÇÃO: Cor do ícone vinda do tema
                  color: iconColor,
                  size: 22,
                ),
              ),
              onPressed: _toggleViewMode,
            ),
          ),
        ),
        // Botão de Filtros
        ScaleTransition(
          scale: _fadeAnimation,
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              // ALTERAÇÃO: Cor reage ao estado E ao tema
              color: _showFilters
                  ? Theme.of(context).colorScheme.surface // Cor de superfície (branco/cinza)
                  : iconBgColor, // Cor de fundo de ícone normal
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.tune_rounded,
                // ALTERAÇÃO: Cor reage ao estado E ao tema
                color: _showFilters ? Theme.of(context).colorScheme.primary : iconColor,
                size: 22,
              ),
              onPressed: _toggleFilters,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      decoration: BoxDecoration(
        // ALTERAÇÃO: Cor vinda do tema
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            // ALTERAÇÃO: Cor da sombra reage ao tema
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Hero(
        tag: 'search_bar',
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              // ALTERAÇÃO: Cor do campo vinda do tema
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  // ALTERAÇÃO: Sombra reage ao tema
                  color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.1 : 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (query) => productController.search(query),
              // ALTERAÇÃO: Cor do texto vinda do tema
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Buscar produtos incríveis...',
                // ALTERAÇÃO: Cor do hint vinda do tema
                hintStyle: GoogleFonts.poppins(
                  color: Theme.of(context).inputDecorationTheme.hintStyle?.color,
                  fontSize: 14,
                ),
                prefixIcon: ScaleTransition(
                  scale: _searchAnimation,
                  child: Icon(
                    _isSearching ? Icons.search_rounded : Icons.search_outlined,
                    // ALTERAÇÃO: Cor do ícone reage ao foco E ao tema
                    color: _isSearching ? Theme.of(context).colorScheme.primary : Theme.of(context).inputDecorationTheme.prefixIconColor,
                    size: 22,
                  ),
                ),
                suffixIcon: Obx(() => productController.searchQuery.value.isNotEmpty
                    ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    // ALTERAÇÃO: Cor do ícone vinda do tema
                    color: Theme.of(context).inputDecorationTheme.prefixIconColor,
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    productController.search('');
                    FocusScope.of(context).unfocus();
                  },
                )
                    : const SizedBox.shrink()),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        height: 55,
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];

            return Obx(() {
              final isSelected = (category == 'Todos' && productController.selectedCategories.isEmpty) ||
                  productController.selectedCategories.contains(category);

              return GestureDetector(
                onTap: () {
                  if (category == 'Todos') {
                    productController.selectedCategories.clear();
                  } else {
                    productController.toggleCategory(category);
                  }
                  HapticFeedback.selectionClick();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOutBack,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    // Usa gradiente no selecionado (cor de marca)
                    gradient: isSelected
                        ? LinearGradient(
                      colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                    )
                        : null,
                    // ALTERAÇÃO: Cor de fundo não selecionado vinda do tema
                    color: isSelected ? null : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(22),
                    // ALTERAÇÃO: Borda não selecionada vinda do tema
                    border: Border.all(
                      color: isSelected ? Colors.transparent : Theme.of(context).dividerColor.withOpacity(0.5),
                      width: 1.5,
                    ),
                    boxShadow: [ // Sombra
                      BoxShadow(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.25)
                        // ALTERAÇÃO: Sombra não selecionada reage ao tema
                            : Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.04 : 0.1),
                        blurRadius: isSelected ? 12 : 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      category,
                      style: GoogleFonts.poppins(
                        // ALTERAÇÃO: Cor do texto não selecionado vinda do tema
                        color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildAdvancedFilters() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.5),
        end: Offset.zero,
      ).animate(_filterSlideAnimation),
      child: FadeTransition(
        opacity: _filterSlideAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // ALTERAÇÃO: Cor do container vinda do tema
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                // ALTERAÇÃO: Sombra reage ao tema
                color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.06 : 0.2),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.sort_rounded,
                    // ALTERAÇÃO: Cor do ícone vinda do tema
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Ordenar por',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      // ALTERAÇÃO: Cor do texto vinda do tema
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _sortOptions.map((option) {
                  final String optionName = _sortOptionNames[option] ?? 'Relevância';

                  return Obx(() {
                    final isSelected = productController.sortOption.value == option;

                    return GestureDetector(
                      onTap: () {
                        productController.setSortOption(option);
                        HapticFeedback.selectionClick();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient( // Gradiente (cor de marca)
                            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                          )
                              : null,
                          // ALTERAÇÃO: Cor de fundo não selecionado vinda do tema
                          color: isSelected ? null : Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            // ALTERAÇÃO: Cor da borda vinda do tema
                            color: isSelected ? Colors.transparent : Theme.of(context).dividerColor.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          optionName,
                          style: GoogleFonts.poppins(
                            // ALTERAÇÃO: Cor do texto não selecionado vinda do tema
                            color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  });
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              '${productController.filteredProducts.length} produtos encontrados',
              key: ValueKey(productController.filteredProducts.length),
              style: GoogleFonts.poppins(
                // ALTERAÇÃO: Cor do texto vinda do tema
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
          Obx(() {
            bool hasFilters = productController.selectedCategories.isNotEmpty ||
                productController.searchQuery.value.isNotEmpty;

            return hasFilters
                ? TextButton.icon(
              onPressed: () {
                productController.selectedCategories.clear();
                _searchController.clear();
                productController.search('');
                FocusScope.of(context).unfocus();
                HapticFeedback.lightImpact();
              },
              icon: const Icon(Icons.clear_all_rounded, size: 16),
              label: Text(
                'Limpar',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              style: TextButton.styleFrom(
                // ALTERAÇÃO: Cor do botão vinda do tema
                foregroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
              ),
            )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildProductsSliverList() {
    final products = productController.filteredProducts;

    if (products.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    // ALTERAÇÃO: Cor do fundo do ícone vinda do tema
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.05 : 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.search_off_rounded,
                    size: 60,
                    // ALTERAÇÃO: Cor do ícone vinda do tema
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Nenhum produto encontrado',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    // ALTERAÇÃO: Cor do texto vinda do tema
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tente buscar por outro termo ou categoria',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    // ALTERAÇÃO: Cor do texto vinda do tema
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // O ProductCard já foi refatorado, então o SliverGrid/SliverList
    // não precisa de mais alterações de cor.
    return _isGridView
        ? SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final product = products[index];
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Hero(
                tag: 'product_${product.id}',
                child: ProductCard(
                  product: product,
                  onTap: () => _navigateToProductDetail(product),
                  onFavoriteToggle: () => _toggleFavorite(product),
                  onAddToCart: () => _addToCart(product),
                ),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    )
        : SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final product = products[index];
            return Container(
              height: 140,
              margin: const EdgeInsets.only(bottom: 16),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Hero(
                  tag: 'product_${product.id}',
                  child: ProductCard(
                    product: product,
                    onTap: () => _navigateToProductDetail(product),
                    onFavoriteToggle: () => _toggleFavorite(product),
                    onAddToCart: () => _addToCart(product),
                  ),
                ),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  void _navigateToProductDetail(Product product) {
    // ... (Método _navigateToProductDetail permanece igual) ...
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailScreen(product: product),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _toggleFavorite(Product product) {
    productController.toggleFavorite(product);
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // ALTERAÇÃO: Cor da SnackBar vinda do tema
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        content: Row(
          children: [
            Icon(
              product.isFavorite.value ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: product.isFavorite.value ? Colors.pink.shade300 : Theme.of(context).colorScheme.surface, // Cor do ícone
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                product.isFavorite.value
                    ? '${product.name} adicionado aos favoritos'
                    : '${product.name} removido dos favoritos',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  // ALTERAÇÃO: Cor do texto vinda do tema
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addToCart(Product product) {
    HapticFeedback.mediumImpact();
    // A SnackBar de "Sucesso" (verde) pode manter a sua cor fixa
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
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
                      color: Colors.white, // Texto branco no fundo verde
                    ),
                  ),
                  Text(
                    product.name,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success, // Manter cor de status (verde)
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Ver carrinho',
          textColor: Colors.white, // Manter branco no fundo verde
          backgroundColor: Colors.white.withOpacity(0.2),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                const CartScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
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
}
