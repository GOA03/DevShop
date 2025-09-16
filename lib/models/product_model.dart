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
  final bool isFavorite;
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
    this.isFavorite = false,
    this.isOnSale = false,
    this.stock = 0,
  });

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
      isFavorite: isFavorite ?? this.isFavorite,
      isOnSale: isOnSale ?? this.isOnSale,
      stock: stock ?? this.stock,
    );
  }
}

// Dados mockados
final List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'iPhone 15 Pro Max',
    description: 'O iPhone mais avançado com chip A17 Pro, câmera de 48MP e design em titânio.',
    price: 8999.00,
    oldPrice: 10999.00,
    imageUrl: 'https://via.placeholder.com/300x300/007AFF/FFFFFF?text=iPhone+15',
    category: 'Eletrônicos',
    rating: 4.8,
    reviewCount: 2342,
    isOnSale: true,
    stock: 15,
  ),
  Product(
    id: '2',
    name: 'MacBook Pro 14"',
    description: 'MacBook Pro com chip M3, tela Liquid Retina XDR e até 22h de bateria.',
    price: 12499.00,
    oldPrice: 14999.00,
    imageUrl: 'https://via.placeholder.com/300x300/333333/FFFFFF?text=MacBook+Pro',
    category: 'Eletrônicos',
    rating: 4.9,
    reviewCount: 1523,
    isOnSale: true,
    stock: 8,
  ),
  Product(
    id: '3',
    name: 'AirPods Pro 2',
    description: 'Cancelamento de ruído ativo, áudio espacial personalizado e case com alto-falante.',
    price: 1899.00,
    imageUrl: 'https://via.placeholder.com/300x300/F5F5F7/000000?text=AirPods+Pro',
    category: 'Eletrônicos',
    rating: 4.7,
    reviewCount: 5421,
    stock: 32,
  ),
  Product(
    id: '4',
    name: 'Nike Air Max 2024',
    description: 'Tênis esportivo com tecnologia Air Max para máximo conforto e estilo.',
    price: 799.90,
    oldPrice: 999.90,
    imageUrl: 'https://via.placeholder.com/300x300/E53935/FFFFFF?text=Nike+Air+Max',
    category: 'Calçados',
    rating: 4.6,
    reviewCount: 892,
    isOnSale: true,
    stock: 23,
  ),
  Product(
    id: '5',
    name: 'Samsung Galaxy S24 Ultra',
    description: 'Smartphone com S Pen integrada, câmera de 200MP e tela AMOLED 2X.',
    price: 6999.00,
    oldPrice: 8499.00,
    imageUrl: 'https://via.placeholder.com/300x300/1565C0/FFFFFF?text=Galaxy+S24',
    category: 'Eletrônicos',
    rating: 4.7,
    reviewCount: 1832,
    isOnSale: true,
    stock: 19,
  ),
  Product(
    id: '6',
    name: 'iPad Pro 12.9"',
    description: 'iPad mais poderoso com chip M2, tela Liquid Retina XDR e suporte para Apple Pencil.',
    price: 9299.00,
    imageUrl: 'https://via.placeholder.com/300x300/757575/FFFFFF?text=iPad+Pro',
    category: 'Eletrônicos',
    rating: 4.8,
    reviewCount: 743,
    stock: 11,
  ),
  Product(
    id: '7',
    name: 'Sony PlayStation 5',
    description: 'Console de última geração com SSD ultra-rápido e gráficos 4K.',
    price: 3899.00,
    oldPrice: 4499.00,
    imageUrl: 'https://via.placeholder.com/300x300/003791/FFFFFF?text=PS5',
    category: 'Games',
    rating: 4.9,
    reviewCount: 3892,
    isOnSale: true,
    stock: 5,
  ),
  Product(
    id: '8',
    name: 'Adidas Ultraboost 23',
    description: 'Tênis de corrida com tecnologia Boost para retorno de energia.',
    price: 899.90,
    imageUrl: 'https://via.placeholder.com/300x300/000000/FFFFFF?text=Adidas+Ultraboost',
    category: 'Calçados',
    rating: 4.5,
    reviewCount: 621,
    stock: 28,
  ),
];