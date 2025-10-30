import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for HapticFeedback
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../models/product_model.dart';
import '../../widgets/product_card.dart';
import '../cart/cart_screen.dart';
import 'product_detail_screen.dart'; // Import the detail screen

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen>
    with TickerProviderStateMixin { // Use TickerProviderStateMixin for multiple controllers
  final List<Product> _products = mockProducts;
  List<Product> _filteredProducts = mockProducts;
  String _selectedCategory = 'Todos';
  String _selectedSort = 'Relevância'; // Added sort option state
  bool _isGridView = true;
  bool _showFilters = false; // Added state for showing filters
  bool _isSearching = false; // Added state for search focus animation

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(); // Added FocusNode
  late AnimationController _animationController; // Main animation controller
  late AnimationController _searchAnimationController; // Controller for search icon animation
  late AnimationController _filterAnimationController; // Controller for filter panel animation
  late Animation<double> _fadeAnimation;
  late Animation<double> _searchAnimation; // Animation for search icon scale
  late Animation<double> _filterSlideAnimation; // Animation for filter panel slide/fade
  late Animation<Offset> _slideAnimation; // Added slide animation for app bar title

  final List<String> _categories = [
    'Todos',
    'Eletrônicos',
    'Calçados',
    'Games',
    'Roupas',
    'Acessórios', // Added more categories as example
  ];

  // Added sort options list
  final List<String> _sortOptions = [
    'Relevância',
    'Menor Preço',
    'Maior Preço',
    'Mais Vendidos',
    'Melhor Avaliação',
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _searchFocusNode.addListener(_onSearchFocusChanged); // Add listener for focus changes
  }

  // Initialize all animation controllers and animations
  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800), // Adjusted duration
      vsync: this,
    );

    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400), // Adjusted duration
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic, // Changed curve
    ));

    _searchAnimation = Tween<double>( // Scale animation for search icon
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.elasticOut, // Changed curve for bouncy effect
    ));

    _filterSlideAnimation = Tween<double>( // Animation for filter panel
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeOutBack, // Changed curve
    ));

    // Slide animation for the AppBar title
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1), // Start from above
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));


    _animationController.forward(); // Start the main animation
  }

  // Handle search bar focus changes for animation
  void _onSearchFocusChanged() {
    if (_searchFocusNode.hasFocus && !_isSearching) {
      setState(() {
        _isSearching = true;
      });
      _searchAnimationController.forward();
    } else if (!_searchFocusNode.hasFocus && _isSearching && _searchController.text.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      _searchAnimationController.reverse();
    }
  }


  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose(); // Dispose focus node
    _animationController.dispose();
    _searchAnimationController.dispose(); // Dispose search animation controller
    _filterAnimationController.dispose(); // Dispose filter animation controller
    super.dispose();
  }

  // Updated filter logic to include sorting
  void _filterProducts() {
    setState(() {
      _filteredProducts = _products.where((product) {
        final matchesSearch = product.name.toLowerCase().contains(
          _searchController.text.toLowerCase(),
        );
        final matchesCategory = _selectedCategory == 'Todos' ||
            product.category == _selectedCategory;

        // Apply both search and category filters
        return matchesSearch && matchesCategory;
      }).toList();

      // Apply sorting based on selected option
      switch (_selectedSort) {
        case 'Menor Preço':
          _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'Maior Preço':
          _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'Melhor Avaliação':
          _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case 'Mais Vendidos':
          _filteredProducts.sort((a, b) => b.reviewCount.compareTo(a.reviewCount)); // Assuming reviewCount indicates sales
          break;
      // Default is 'Relevância', no sorting needed here as it depends on backend or default order
      }
    });
  }

  // Toggle filter panel visibility with animation and haptic feedback
  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });

    if (_showFilters) {
      _filterAnimationController.forward();
      HapticFeedback.lightImpact(); // Add haptic feedback
    } else {
      _filterAnimationController.reverse();
    }
  }

  // Toggle between grid and list view with haptic feedback
  void _toggleViewMode() {
    setState(() {
      _isGridView = !_isGridView;
    });
    HapticFeedback.selectionClick(); // Add haptic feedback
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSearchSection(), // Extracted search section
                _buildCategoryFilter(), // Extracted category filter section
                if (_showFilters) _buildAdvancedFilters(), // Conditionally show advanced filters
                _buildProductsHeader(), // Header showing product count and clear filters button
              ],
            ),
          ),
          _buildProductsSliverList(), // Product list/grid
        ],
      ),
    );
  }

  // Build the SliverAppBar with animations and actions
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 80, // Reduced height
      floating: false, // Keep it visible when scrolling up
      pinned: true,
      elevation: 0, // Remove shadow
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: SlideTransition( // Added slide animation to title
          position: _slideAnimation,
          child: Text(
            'Produtos',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700, // Bolder title
              fontSize: 24, // Larger font size
            ),
          ),
        ),
        background: Container( // Added gradient background
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8), // Slightly transparent end color
              ],
            ),
          ),
        ),
      ),
      actions: [
        // View toggle button with animation
        ScaleTransition(
          scale: _fadeAnimation, // Reuse fade animation for scale effect
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // Semi-transparent background
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: AnimatedSwitcher( // Animate icon change
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
                  key: ValueKey(_isGridView), // Key for animation
                  color: Colors.white,
                  size: 22, // Slightly smaller icon
                ),
              ),
              onPressed: _toggleViewMode,
            ),
          ),
        ),
        // Filter toggle button with animation
        ScaleTransition(
          scale: _fadeAnimation,
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: _showFilters ? Colors.white : Colors.white.withOpacity(0.2), // Change background when active
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.tune_rounded, // Use tune icon
                color: _showFilters ? AppColors.primary : Colors.white, // Change color when active
                size: 22,
              ),
              onPressed: _toggleFilters,
            ),
          ),
        ),
      ],
    );
  }

  // Build the search text field section with Hero animation and improved styling
  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [ // Added shadow
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Hero( // Wrap TextField with Hero for potential transition from home screen
        tag: 'search_bar',
        child: Material( // Material widget needed for Hero transition
          color: Colors.transparent,
          child: AnimatedContainer( // Animate container properties if needed
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20), // More rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode, // Assign focus node
              onChanged: (_) => _filterProducts(),
              style: GoogleFonts.poppins( // Consistent font style
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Buscar produtos incríveis...', // Engaging hint text
                hintStyle: GoogleFonts.poppins(
                  color: AppColors.textSecondary.withOpacity(0.6),
                  fontSize: 14,
                ),
                prefixIcon: ScaleTransition( // Animate search icon scale
                  scale: _searchAnimation, // Use the defined search animation
                  child: Icon(
                    _isSearching ? Icons.search_rounded : Icons.search_outlined, // Change icon based on focus
                    color: _isSearching ? AppColors.primary : AppColors.textSecondary, // Change color based on focus
                    size: 22,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _filterProducts();
                    FocusScope.of(context).unfocus(); // Dismiss keyboard
                  },
                )
                    : null,
                border: InputBorder.none, // Remove default border
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, // Adjust padding
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  // Build the horizontal category filter list with improved styling
  Widget _buildCategoryFilter() {
    return FadeTransition( // Added fade transition
      opacity: _fadeAnimation,
      child: Container(
        height: 55, // Increased height for better touch target
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            final isSelected = _selectedCategory == category;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                  _filterProducts();
                });
                HapticFeedback.selectionClick(); // Haptic feedback on tap
              },
              child: AnimatedContainer( // Animate container properties
                duration: const Duration(milliseconds: 150), // Faster animation
                curve: Curves.easeOutBack, // Animated curve
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected // Use gradient for selected category
                      ? LinearGradient(
                    colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                  )
                      : null,
                  color: isSelected ? null : Colors.white, // White background for unselected
                  borderRadius: BorderRadius.circular(22), // More rounded corners
                  border: Border.all( // Subtle border for unselected
                    color: isSelected ? Colors.transparent : Colors.grey.shade200,
                    width: 1.5,
                  ),
                  boxShadow: [ // Add shadow for depth
                    BoxShadow(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.25)
                          : Colors.black.withOpacity(0.04),
                      blurRadius: isSelected ? 12 : 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    category,
                    style: GoogleFonts.poppins(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, // Adjust weight
                      fontSize: 13, // Slightly smaller font
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  // Build the advanced filter section (sorting options) with slide/fade animation
  Widget _buildAdvancedFilters() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.5), // Slide down from top
        end: Offset.zero,
      ).animate(_filterSlideAnimation),
      child: FadeTransition(
        opacity: _filterSlideAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row( // Title with icon
                children: [
                  Icon(
                    Icons.sort_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Ordenar por',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700, // Bolder title
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap( // Use Wrap for responsive layout of sort options
                spacing: 8,
                runSpacing: 8,
                children: _sortOptions.map((option) {
                  final isSelected = _selectedSort == option;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSort = option;
                        _filterProducts();
                      });
                      HapticFeedback.selectionClick(); // Haptic feedback
                    },
                    child: AnimatedContainer( // Animate selection change
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected // Gradient for selected option
                            ? LinearGradient(
                          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                        )
                            : null,
                        color: isSelected ? null : AppColors.background, // Background color change
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        option,
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // Build the header showing product count and a clear filter button
  Widget _buildProductsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedSwitcher( // Animate text change for product count
            duration: const Duration(milliseconds: 300),
            child: Text(
              '${_filteredProducts.length} produtos encontrados',
              key: ValueKey(_filteredProducts.length), // Key for animation
              style: GoogleFonts.poppins(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Show "Clear" button only if filters are active
          if (_selectedCategory != 'Todos' || _searchController.text.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedCategory = 'Todos';
                  _searchController.clear();
                  _filterProducts(); // Re-apply filters (which effectively clears them)
                });
                FocusScope.of(context).unfocus(); // Dismiss keyboard
                HapticFeedback.lightImpact(); // Haptic feedback
              },
              icon: const Icon(
                Icons.clear_all_rounded, // Use clear_all icon
                size: 16,
              ),
              label: Text(
                'Limpar',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Adjust padding
                minimumSize: Size.zero, // Allow smaller button size
              ),
            ),
        ],
      ),
    );
  }


  // Build the product list/grid with empty state and animations
  Widget _buildProductsSliverList() {
    // Show empty state if no products match filters
    if (_filteredProducts.isEmpty) {
      return SliverFillRemaining( // Use SliverFillRemaining to fill available space
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation, // Fade in the empty state message
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container( // Decorative container for the icon
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.background, // Use background color
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.search_off_rounded, // Use search_off icon
                    size: 60,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Nenhum produto encontrado',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tente buscar por outro termo ou categoria',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Build grid view
    return _isGridView
        ? SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns
          childAspectRatio: 0.65, // Adjust aspect ratio for card size
          crossAxisSpacing: 12, // Spacing between columns
          mainAxisSpacing: 16, // Spacing between rows
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final product = _filteredProducts[index];
            return FadeTransition( // Fade in each product card
              opacity: _fadeAnimation,
              child: Hero( // Wrap ProductCard with Hero
                tag: 'product_${product.id}', // Unique tag for Hero animation
                child: ProductCard(
                  product: product,
                  onTap: () => _navigateToProductDetail(product), // Navigate on tap
                  onFavoriteToggle: () => _toggleFavorite(product), // Handle favorite toggle
                  onAddToCart: () => _addToCart(product), // Handle add to cart
                ),
              ),
            );
          },
          childCount: _filteredProducts.length,
        ),
      ),
    )
    // Build list view
        : SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final product = _filteredProducts[index];
            return Container( // Container to manage height and margin for list items
              height: 140, // Fixed height for list items
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
          childCount: _filteredProducts.length,
        ),
      ),
    );
  }

  // Navigate to Product Detail Screen with custom transition
  void _navigateToProductDetail(Product product) {
    HapticFeedback.lightImpact(); // Haptic feedback on navigation
    Navigator.push(
      context,
      PageRouteBuilder( // Use PageRouteBuilder for custom transition
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailScreen(product: product),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Slide transition from right to left
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic, // Smooth curve
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300), // Faster transition
      ),
    );
  }

  // Show snackbar when toggling favorite
  void _toggleFavorite(Product product) {
    HapticFeedback.lightImpact(); // Haptic feedback
    // TODO: Implement actual favorite logic (e.g., update state management)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row( // Improved content with icon
          children: [
            Icon(
              Icons.favorite_rounded,
              color: Colors.pink.shade300, // Use pink color
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${product.name} adicionado aos favoritos', // Informative message
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.textPrimary, // Use primary text color for background
        behavior: SnackBarBehavior.floating, // Floating snackbar
        shape: RoundedRectangleBorder( // Rounded corners
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(20), // Margin around snackbar
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Show snackbar when adding to cart
  void _addToCart(Product product) {
    HapticFeedback.mediumImpact(); // Stronger haptic feedback
    // TODO: Implement actual add to cart logic (e.g., update state management)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row( // Improved content layout
          children: [
            Container( // Icon container for better visual separation
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
              child: Column( // Column for title and product name
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Take minimum space
                children: [
                  Text(
                    'Produto adicionado!',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    product.name,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    maxLines: 1, // Prevent overflow
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success, // Use success color
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // More rounded corners
        ),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3), // Slightly longer duration
        action: SnackBarAction( // Add action to view cart
          label: 'Ver carrinho',
          textColor: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.2), // Subtle background for action
          onPressed: () {
            // Navigate to CartScreen with custom transition
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                const CartScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  // Slide up transition
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