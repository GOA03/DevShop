import 'dart:convert';
import 'package:dev_shop/controllers/api/api_controller.dart';
import 'package:dev_shop/data/favorite/favorite_dao.dart';
import 'package:dev_shop/data/favorite/favorite_model.dart';
import 'package:dev_shop/service/http_interceptor.dart';
import 'package:get/get.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;

enum SortOption { none, priceAsc, priceDesc }

class ProductController extends GetxController {
  final List<Product> _allProducts = [];
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxList<Product> favoriteProducts = <Product>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<SortOption> sortOption = SortOption.none.obs;
  final RxSet<String> selectedCategories = <String>{}.obs;
  final RxList<Product> featuredProducts = <Product>[].obs;
  late SharedPreferences _pref;

  // Cliente HTTP
  static final String url = ApiController().getUrl(Endpoint.products);
  http.Client client = ApiController().client;

  // 🟢 DAO de favoritos
  final FavoriteDao favoriteDao = FavoriteDao();

  // 🧍 Usuário logado (em produção, vem de AuthController)
  late int _currentUserId;

  @override
  Future<void> onInit() async {
    _pref = await SharedPreferences.getInstance();
    _currentUserId = _pref.getInt('userId')!;
    super.onInit();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await getAll();
    _allProducts.assignAll(products);

    // Carrega favoritos do usuário logado
    await _syncFavoritesFromDb();

    filteredProducts.assignAll(_allProducts);
    featuredProducts.assignAll(_allProducts.where((p) => p.isFeatured));
  }

  Future<void> _syncFavoritesFromDb() async {
    final favoritesFromDb = await favoriteDao.findAll(_currentUserId);
    final favoriteIds = favoritesFromDb.map((f) => f.prodId).toSet();

    for (var product in _allProducts) {
      product.isFavorite.value = favoriteIds.contains(product.id);
    }

    // ✅ Atualiza lista de favoritos com base no banco
    favoriteProducts.assignAll(
      _allProducts.where((p) => p.isFavorite.value).toList(),
    );
  }

  /// 🟢 Alterna favorito e persiste no banco
  Future<void> toggleFavorite(Product product) async {
    product.isFavorite.toggle();

    if (product.isFavorite.value) {
      await favoriteDao.save(FavoriteModel(_currentUserId, product.id));
    } else {
      await favoriteDao.delete(_currentUserId, product.id);
    }

    // Recarrega favoritos do banco para garantir consistência
    await _syncFavoritesFromDb();

    // Atualiza produto na lista principal
    final index = _allProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _allProducts[index] = product;
    }
  }

  Future<void> loadFavoritesOnly() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    final favoritesFromDb = await favoriteDao.findAll(userId);
    final favoriteIds = favoritesFromDb.map((f) => f.prodId).toSet();

    // Atualiza apenas o atributo de favorito dos produtos carregados
    for (var product in _allProducts) {
      product.isFavorite.value = favoriteIds.contains(product.id);
    }

    // Atualiza as listas reativas
    favoriteProducts.assignAll(_allProducts.where((p) => p.isFavorite.value));
  }

  // Métodos HTTP originais
  Future<bool> register(Product product) async {
    final response = await client.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );
    return response.statusCode == 201;
  }

  Future<List<Product>> getAll() async {
    final response = await client.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception("Erro ao buscar produtos");
    }

    List<dynamic> listDynamic = json.decode(response.body);
    return listDynamic
        .where((item) => item['stock'] > 0)
        .map<Product>((item) => Product.fromJson(item))
        .toList();
  }

  // Filtros e busca
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
      selectedCategories
        ..clear()
        ..add(category);
    }
    _applyFilters();
  }

  void _applyFilters() {
    List<Product> tempProducts = List.from(_allProducts);

    if (searchQuery.value.isNotEmpty) {
      tempProducts = tempProducts
          .where(
            (p) =>
                p.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
          )
          .toList();
    }

    if (selectedCategories.isNotEmpty) {
      tempProducts = tempProducts
          .where((p) => selectedCategories.contains(p.category))
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

  List<String> get availableCategories =>
      _allProducts.map((p) => p.category).toSet().toList();

  List<String> get featuredCategories =>
      featuredProducts.map((p) => p.category).toSet().toList();
}
