import 'package:get/get.dart';
import '../models/product.dart';

enum SortOption { none, priceAsc, priceDesc }

class ProductController extends GetxController {
  final List<Product> _allProducts = [];
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxList<Product> favoriteProducts = <Product>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<SortOption> sortOption = SortOption.none.obs;
  final RxSet<String> selectedCategories = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProducts();
  }

  void _loadProducts() {
    // No futuro isso pode vir de uma API. Por agora vou usar os dados mockados
    final mockData = mockProducts;
    _allProducts.assignAll(mockData);
    filteredProducts.assignAll(_allProducts);
    favoriteProducts.assignAll(_allProducts.where((p) => p.isFavorite.value));
  }

  void toggleFavorite(Product product) {
    product.isFavorite.toggle();

    if (product.isFavorite.value) {
      favoriteProducts.add(product);
    } else {
      favoriteProducts.removeWhere((p) => p.id == product.id);
    }

    int index = _allProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _allProducts[index] = product;
    }

    // Opcional para talvez no futuro atualizar a lista de produtos favoritos: `update()` força a atualização de widgets `GetBuilder`, se usar update();
  }

  void search(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void setSortOption(SortOption option) {
    sortOption.value = option;
    _applyFilters();
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.clear();
    } else {
      selectedCategories.clear();
      selectedCategories.add(category);
    }
    _applyFilters();
  }

  void _applyFilters() {
    List<Product> tempProducts = List.from(_allProducts);

    if (searchQuery.value.isNotEmpty) {
      tempProducts = tempProducts
          .where(
            (product) => product.name.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ),
          )
          .toList();
    }

    if (selectedCategories.isNotEmpty) {
      tempProducts = tempProducts
          .where((product) => selectedCategories.contains(product.category))
          .toList();
    }

    switch (sortOption.value) {
      case SortOption.priceAsc:
        tempProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        tempProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.none:
        break;
    }

    filteredProducts.assignAll(tempProducts);
  }

  List<String> get availableCategories {
    return _allProducts.map((p) => p.category).toSet().toList();
  }
}
