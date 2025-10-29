import 'package:get/get.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  RxBool isFavorite;
  final bool isOnSale;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
    bool isFavorite = false,
    this.isOnSale = false,
    this.stock = 0,
  }) : this.isFavorite = isFavorite.obs;

  double get discountPercentage {
    if (oldPrice != null && oldPrice! > price) {
      return ((oldPrice! - price) / oldPrice! * 100);
    }
    return 0;
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? oldPrice,
    String? imageUrl,
    String? category,
    double? rating,
    int? reviewCount,
    bool? isFavorite,
    bool? isOnSale,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite.value,
      isOnSale: isOnSale ?? this.isOnSale,
      stock: stock ?? this.stock,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'oldPrice': oldPrice,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFavorite': isFavorite.value,
      'isOnSale': isOnSale,
      'stock': stock,
    };
  }

  Product.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      description = json['description'],
      price = json['price'].toDouble(),
      oldPrice = json['oldPrice']?.toDouble(),
      imageUrl = json['imageUrl'],
      category = json['category'],
      rating = json['rating'] != null ? json['rating'].toDouble() : 0.0,
      reviewCount = json['reviewCount'] ?? 0,
      isFavorite = (json['isFavorite'] is bool)
          ? (json['isFavorite'] as bool).obs
          : false.obs,

      isOnSale = json['isOnSale'] ?? false,
      stock = json['stock'] ?? 0;
}

// Dados mockados
final List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'iPhone 15 Pro Max',
    description:
        'O iPhone mais avançado com chip A17 Pro, câmera de 48MP e design em titânio.',
    price: 8999.00,
    oldPrice: 10999.00,
    imageUrl:
        'https://carrefourbr.vtexassets.com/arquivos/ids/198489753/image-0.jpg?v=638911758973000000',
    category: 'Eletrônicos',
    rating: 4.8,
    reviewCount: 2342,
    isOnSale: true,
    stock: 15,
  ),
  Product(
    id: '2',
    name: 'MacBook Pro 14"',
    description:
        'MacBook Pro com chip M3, tela Liquid Retina XDR e até 22h de bateria.',
    price: 12499.00,
    oldPrice: 14999.00,
    imageUrl:
        'https://cdsassets.apple.com/live/7WUAS350/images/tech-specs/mbp14-silver2.png',
    category: 'Eletrônicos',
    rating: 4.9,
    reviewCount: 1523,
    isOnSale: true,
    stock: 8,
  ),
  Product(
    id: '3',
    name: 'AirPods Pro 2',
    description:
        'Cancelamento de ruído ativo, áudio espacial personalizado e case com alto-falante.',
    price: 1899.00,
    imageUrl:
        'https://m.media-amazon.com/images/I/41YmidweMtL._AC_SX342_SY445_QL70_ML2_.jpg',
    category: 'Eletrônicos',
    rating: 4.7,
    reviewCount: 5421,
    stock: 32,
  ),
  Product(
    id: '4',
    name: 'Nike Air Max 2024',
    description:
        'Tênis esportivo com tecnologia Air Max para máximo conforto e estilo.',
    price: 799.90,
    oldPrice: 999.90,
    imageUrl:
        'https://espacotenis.vteximg.com.br/arquivos/ids/174739-442-442/WhatsApp-Image-2024-02-06-at-11.24.11.jpg?v=638428267197800000',
    category: 'Calçados',
    rating: 4.6,
    reviewCount: 892,
    isOnSale: true,
    stock: 23,
  ),
  Product(
    id: '5',
    name: 'Samsung Galaxy S24 Ultra',
    description:
        'Smartphone com S Pen integrada, câmera de 200MP e tela AMOLED 2X.',
    price: 6999.00,
    oldPrice: 8499.00,
    imageUrl:
        'https://http2.mlstatic.com/D_NQ_NP_673427-MLA87115634147_072025-O.webp',
    category: 'Eletrônicos',
    rating: 4.7,
    reviewCount: 1832,
    isOnSale: true,
    stock: 19,
  ),
  Product(
    id: '6',
    name: 'iPad Pro 12.9',
    description:
        'iPad mais poderoso com chip M2, tela Liquid Retina XDR e suporte para Apple Pencil.',
    price: 9299.00,
    imageUrl: 'https://m.media-amazon.com/images/I/61sEJ2+OAbL._AC_SX679_.jpg',
    category: 'Eletrônicos',
    rating: 4.8,
    reviewCount: 743,
    stock: 11,
  ),
  Product(
    id: '7',
    name: 'Sony PlayStation 5',
    description:
        'Console de última geração com SSD ultra-rápido e gráficos 4K.',
    price: 3899.00,
    oldPrice: 4499.00,
    imageUrl: 'https://m.media-amazon.com/images/I/51dfg52K-cL._AC_SL1500_.jpg',
    category: 'Games',
    rating: 4.9,
    reviewCount: 3892,
    isOnSale: true,
    stock: 5,
  ),
  Product(
    id: '8',
    name: 'Adidas Ultraboost 23',
    description:
        'Tênis de corrida com tecnologia Boost para retorno de energia.',
    price: 899.90,
    imageUrl:
        'https://static.clube.netshoes.com.br/produtos/tenis-adidas-ultraboost-23-feminino/26/FB8-4374-026/FB8-4374-026_zoom1.jpg?ts=1704276437&ims=1088x',
    category: 'Calçados',
    rating: 4.5,
    reviewCount: 621,
    stock: 28,
  ),
];
