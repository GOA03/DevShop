import 'package:get/get.dart';
import '../models/product_model.dart';

enum SortOption { none, priceAsc, priceDesc }

class ProductController extends GetxController {

  final List<Product> _allProducts = [];

  final RxList<Product> filteredProducts = <Product>[].obs;

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
    _allProducts.assignAll(mockProducts);
    filteredProducts.assignAll(_allProducts);
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
      tempProducts = tempProducts.where((product) =>
          product.name.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }

    if (selectedCategories.isNotEmpty) {
      tempProducts = tempProducts.where((product) =>
          selectedCategories.contains(product.category)
      ).toList();
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

  Product? getProductById(String id) {
    return _allProducts.firstWhereOrNull((p) => p.id == id);
  }
}