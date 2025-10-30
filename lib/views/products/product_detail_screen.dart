import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para HapticFeedback (feedback tátil)
import 'package:get/get.dart'; // Para gestão de estado (favoritos)
import 'package:google_fonts/google_fonts.dart'; // Para fontes personalizadas

import '../../controllers/product_controller.dart'; // Controlador de produtos
import '../../core/constants/colors.dart'; // Cores da aplicação
import '../../models/product_model.dart'; // Modelo do produto
import '../../widgets/custom_button.dart'; // Botão personalizado
import '../cart/cart_screen.dart'; // Ecrã do carrinho (para navegação)

class ProductDetailScreen extends StatefulWidget {
  final Product product; // O produto que este ecrã vai exibir

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin { // Permite múltiplos controladores de animação

  // Controladores de animação
  late AnimationController _animationController; // Controlador principal
  late Animation<double> _fadeAnimation; // Animação de esbatimento (fade-in)
  late Animation<Offset> _slideAnimation; // Animação de deslize (slide-up)
  late Animation<double> _scaleAnimation; // Animação de escala (zoom-in)

  // Controlador de produtos (GetX)
  late final ProductController productController;

  // Variáveis de estado locais do ecrã
  int quantity = 1; // Quantidade inicial do produto a adicionar
  int selectedImageIndex = 0; // Índice da imagem principal mostrada na galeria

  // Lista simulada de imagens do produto (em produção, isto viria do modelo `Product`)
  List<String> get productImages => [
    widget.product.imageUrl,
    // Simulação de mais imagens (repetindo a principal)
    widget.product.imageUrl,
    widget.product.imageUrl,
  ];

  @override
  void initState() {
    super.initState();
    productController = Get.find(); // Encontra a instância global do ProductController
    _initializeAnimations(); // Chama o método para configurar e iniciar as animações
  }

  // Configura os controladores e as curvas de animação
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200), // Duração total
      vsync: this,
    );

    // Animação de Fade (opacidade de 0 a 1)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        // Intervalo: ocorre nos primeiros 60% da duração total
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    // Animação de Slide (deslize de baixo para cima)
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            // Intervalo: ocorre entre 20% e 80% da duração, com efeito "easeOutBack"
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
          ),
        );

    // Animação de Scale (escala da imagem principal)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        // Intervalo: ocorre entre 30% e 100%, com efeito "elasticOut"
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward(); // Inicia as animações
  }

  @override
  void dispose() {
    _animationController.dispose(); // Liberta os recursos do controlador
    super.dispose();
  }

  // Função para alternar o estado de favorito
  void _toggleFavorite() {
    productController.toggleFavorite(widget.product); // Usa o controlador GetX
    HapticFeedback.lightImpact(); // Feedback tátil

    // Mostra SnackBar de confirmação
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.product.isFavorite.value
              ? '${widget.product.name} adicionado aos favoritos!'
              : '${widget.product.name} removido dos favoritos.',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor:
        widget.product.isFavorite.value ? AppColors.success : Colors.orange.shade700, // Cor dinâmica
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Função para mostrar a galeria de imagens num diálogo
  void _showImageGallery() {
    if (productImages.length <= 1) return; // Não abre se só houver 1 imagem
    HapticFeedback.mediumImpact(); // Feedback tátil

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent, // Fundo do diálogo transparente
        insetPadding: const EdgeInsets.all(10), // Padding à volta do PageView
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7, // 70% da altura do ecrã
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                // PageView para deslizar entre as imagens
                child: PageView.builder(
                  itemCount: productImages.length,
                  controller: PageController(initialPage: selectedImageIndex), // Começa na imagem atual
                  onPageChanged: (index) => setState(() => selectedImageIndex = index), // Atualiza o índice ao mudar
                  itemBuilder: (context, index) {
                    // InteractiveViewer permite dar zoom e arrastar a imagem
                    return InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white, // Fundo branco para a imagem
                          image: productImages[index].isNotEmpty
                              ? DecorationImage(
                            image: NetworkImage(productImages[index]),
                            fit: BoxFit.contain, // Mostra a imagem inteira
                          )
                              : null,
                        ),
                        // Ícone de fallback caso a imagem não exista
                        child: productImages[index].isEmpty
                            ? const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 64, color: AppColors.textSecondary,
                          ),
                        )
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Indicador de página (bolinhas)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(productImages.length, (index) {
                  return AnimatedContainer( // Anima a transição da bolinha
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: selectedImageIndex == index ? 12 : 8, // Bolinha ativa é maior
                    height: selectedImageIndex == index ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selectedImageIndex == index
                          ? AppColors.primary // Cor da bolinha ativa
                          : Colors.grey.shade400, // Cor da bolinha inativa
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para adicionar o produto ao carrinho (simulada)
  void _addToCart() {
    HapticFeedback.mediumImpact(); // Feedback tátil mais forte

    // --- LÓGICA REAL DE ADICIONAR AO CARRINHO ---
    // (Ex: Get.find<CartController>().addItem(widget.product, quantity);)

    // Mostra SnackBar de confirmação
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Adicionado ao carrinho!', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  Text(
                    '${widget.product.name} (x$quantity)', // Mostra o nome e a quantidade
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withOpacity(0.9)),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success, // Cor de sucesso
        behavior: SnackBarBehavior.floating, // Estilo flutuante
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
        // Ação para navegar para o carrinho
        action: SnackBarAction(
          label: 'Ver carrinho',
          textColor: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.2),
          onPressed: () {
            // Navega para o CartScreen com animação de baixo para cima
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const CartScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
                        .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
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

  // --- MÉTODOS DE CONSTRUÇÃO DA UI (BUILD) ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Cor de fundo
      body: CustomScrollView( // Permite AppBar "colapsável" e conteúdo rolável
        slivers: [
          _buildSliverAppBar(), // A barra superior
          SliverToBoxAdapter( // Adaptador para widgets normais dentro do CustomScrollView
            child: FadeTransition( // Aplica animação de fade
              opacity: _fadeAnimation,
              child: SlideTransition( // Aplica animação de slide
                position: _slideAnimation,
                child: Column( // Coluna principal para todo o conteúdo abaixo da AppBar
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageGallery(), // Secção da imagem principal
                    _buildProductInfo(), // Secção com nome, preço, stock
                    _buildRatingSection(), // Secção de avaliações
                    _buildDescriptionSection(), // Secção de descrição
                    _buildSpecsSection(), // Secção de especificações
                    _buildRelatedSection(), // Secção de produtos relacionados
                    const SizedBox(height: 100), // Espaço inferior
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(), // A barra inferior fixa
    );
  }

  // Constrói a AppBar (barra superior)
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      floating: true, // Flutua sobre o conteúdo ao rolar para cima
      pinned: true, // Permanece fixa no topo
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white, // Cor dos ícones e texto
      elevation: 2, // Sombra
      title: Text(
        widget.product.name,
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        overflow: TextOverflow.ellipsis, // Evita quebra de linha
      ),
      actions: [ // Botões à direita
        // Botão de Favorito
        Obx( // Widget do GetX que observa o estado 'isFavorite'
              () => IconButton(
            tooltip: widget.product.isFavorite.value ? 'Remover dos Favoritos' : 'Adicionar aos Favoritos',
            onPressed: _toggleFavorite, // Chama a função ao clicar
            icon: AnimatedSwitcher( // Anima a troca de ícones
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
              child: Icon(
                widget.product.isFavorite.value
                    ? Icons.favorite_rounded // Ícone preenchido
                    : Icons.favorite_border_rounded, // Ícone de borda
                key: ValueKey<bool>(widget.product.isFavorite.value), // Chave para o AnimatedSwitcher
                color: widget.product.isFavorite.value ? Colors.redAccent.shade100 : Colors.white,
              ),
            ),
          ),
        ),
        // Botão de Compartilhar
        IconButton(
          tooltip: 'Compartilhar Produto',
          onPressed: () {
            // TODO: Implementar lógica de partilha (ex: usar o pacote 'share_plus')
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Compartilhar ${widget.product.name}... (em breve)')),
            );
          },
          icon: const Icon(Icons.share_outlined),
        ),
      ],
    );
  }

  // Constrói a secção da galeria de imagem principal
  Widget _buildImageGallery() {
    return ScaleTransition( // Aplica animação de escala
      scale: _scaleAnimation,
      child: Container(
        height: 300, // Altura da imagem
        margin: const EdgeInsets.all(16),
        child: Stack( // Stack para sobrepor selos (desconto, stock)
          alignment: Alignment.center,
          children: [
            // Container da Imagem
            GestureDetector(
              onTap: _showImageGallery, // Abre galeria em popup
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                // Hero widget para a animação de transição
                child: Hero(
                  tag: 'product_${widget.product.id}', // Tag deve ser única e igual à da lista
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: widget.product.imageUrl.isNotEmpty
                        ? Image.network(
                      productImages[selectedImageIndex], // Mostra a imagem selecionada
                      fit: BoxFit.contain, // Ajuste da imagem
                      // Indicador de loading
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                          ),
                        );
                      },
                      // Ícone de erro
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.broken_image_outlined, size: 64, color: AppColors.textSecondary));
                      },
                    )
                    // Ícone de fallback se não houver imagem
                        : const Center(child: Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.textSecondary)),
                  ),
                ),
              ),
            ),

            // Selo de Desconto
            if (widget.product.isOnSale && widget.product.discountPercentage > 0)
              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    '-${widget.product.discountPercentage.toStringAsFixed(0)}%',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            // Selo de Stock Baixo
            if (widget.product.stock <= 5 && widget.product.stock > 0)
              Positioned(
                top: 12, right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    'Últimas ${widget.product.stock}!',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            // Indicador de Página (se houver múltiplas imagens)
            if (productImages.length > 1)
              Positioned(
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    '${selectedImageIndex + 1} / ${productImages.length}',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Constrói a secção com Nome, Preço, Categoria e Stock
  Widget _buildProductInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nome do Produto
          Text(
            widget.product.name,
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          // Categoria (Chip)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(
              widget.product.category,
              style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          // Preços
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic,
            children: [
              Text( // Preço atual
                'R\$ ${widget.product.price.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              if (widget.product.oldPrice != null) ...[ // Preço antigo (se existir)
                const SizedBox(width: 12),
                Text(
                  'R\$ ${widget.product.oldPrice!.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    decoration: TextDecoration.lineThrough, // Rasurado
                    color: AppColors.textSecondary.withOpacity(0.6),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          // Indicador de Stock
          Row(
            children: [
              Icon(
                widget.product.stock > 0 ? Icons.check_circle_outline_rounded : Icons.highlight_off_rounded,
                color: widget.product.stock > 0 ? AppColors.success : AppColors.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.product.stock > 0
                    ? 'Em stock (${widget.product.stock} ${widget.product.stock == 1 ? "unidade" : "unidades"})'
                    : 'Fora de stock',
                style: GoogleFonts.poppins(
                  color: widget.product.stock > 0 ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Constrói a secção de Avaliação
  Widget _buildRatingSection() {
    if (widget.product.rating <= 0 && widget.product.reviewCount <= 0) {
      return const SizedBox.shrink(); // Oculta se não houver avaliações
    }
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          // Nota Média
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: AppColors.warning, size: 22),
                const SizedBox(width: 6),
                Text(
                  widget.product.rating.toStringAsFixed(1),
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Estrelas e Contagem
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row( // 5 Estrelas
                  children: List.generate(5, (index) {
                    double rating = widget.product.rating;
                    IconData iconData = Icons.star_border_rounded; // Padrão: vazia
                    if (index < rating.floor()) {
                      iconData = Icons.star_rounded; // Cheia
                    } else if (index < rating && (rating - index) >= 0.5) {
                      iconData = Icons.star_half_rounded; // Meia
                    }
                    return Icon(iconData, color: AppColors.warning, size: 20);
                  }),
                ),
                const SizedBox(height: 4),
                Text( // Contagem
                  '${widget.product.reviewCount} ${widget.product.reviewCount == 1 ? "avaliação" : "avaliações"}',
                  style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 14),
                ),
              ],
            ),
          ),
          // Botão "Ver todas"
          TextButton(
            onPressed: () { /* TODO: Navegar para ecrã de reviews */ },
            child: Text('Ver todas', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  // Constrói a secção de Descrição
  Widget _buildDescriptionSection() {
    if (widget.product.description.isEmpty) {
      return const SizedBox.shrink(); // Oculta se não houver descrição
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Descrição',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Text(
            widget.product.description,
            style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary, height: 1.6), // Espaçamento entre linhas
          ),
        ],
      ),
    );
  }

  // Constrói a secção de Especificações (com dados simulados)
  Widget _buildSpecsSection() {
    List<Map<String, String>> specs = _getProductSpecs(); // Obtém dados simulados
    if (specs.isEmpty) return const SizedBox.shrink(); // Oculta se vazio

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Especificações',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          // Cria uma linha para cada especificação
          ...specs.map(
                (spec) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded( // Rótulo (ex: "Marca")
                    flex: 1,
                    child: Text(
                      spec['label']!,
                      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded( // Valor (ex: "Apple")
                    flex: 2,
                    child: Text(
                      spec['value']!,
                      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ).toList(),
        ],
      ),
    );
  }

  // Constrói a secção de Produtos Relacionados (com dados simulados)
  Widget _buildRelatedSection() {
    // Filtra produtos da mesma categoria, excluindo o atual, e limita a 4
    List<Product> relatedProducts = mockProducts
        .where((p) => p.category == widget.product.category && p.id != widget.product.id)
        .take(4)
        .toList();

    if (relatedProducts.isEmpty) return const SizedBox.shrink(); // Oculta se vazio

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Produtos Relacionados',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          // Lista horizontal
          SizedBox(
            height: 220, // Altura da lista
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // Scroll horizontal
              itemCount: relatedProducts.length,
              itemBuilder: (context, index) {
                final product = relatedProducts[index];
                return Container(
                  width: 150, // Largura de cada cartão
                  margin: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      // Navega para o detalhe do produto relacionado (substituindo o ecrã atual)
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => ProductDetailScreen(product: product),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child); // Transição suave
                          },
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                    child: Card( // Cartão do produto relacionado
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagem
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              color: AppColors.background,
                              child: product.imageUrl.isNotEmpty
                                  ? Image.network(product.imageUrl, fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Center(child: Icon(Icons.broken_image_outlined, color: AppColors.textSecondary)))
                                  : const Center(child: Icon(Icons.shopping_bag_outlined, color: AppColors.textSecondary)),
                            ),
                          ),
                          // Texto (Nome e Preço)
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    product.name,
                                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                                    maxLines: 2, overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'R\$ ${product.price.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
  }

  // Constrói a barra inferior fixa com controlo de quantidade e botão
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface, // Fundo branco
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))], // Sombra
      ),
      child: SafeArea( // Garante que não fica sob controlos do sistema
        child: Row(
          children: [
            // Controlo de Quantidade
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Botão Menos (-)
                  IconButton(
                    onPressed: quantity > 1 ? () => setState(() => quantity--) : null, // Desabilita em 1
                    icon: const Icon(Icons.remove, size: 18),
                    color: quantity > 1 ? AppColors.textPrimary : Colors.grey.shade400,
                    splashRadius: 20,
                    constraints: const BoxConstraints(),
                  ),
                  // Mostrador da Quantidade
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '$quantity',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ),
                  // Botão Mais (+)
                  IconButton(
                    onPressed: quantity < widget.product.stock ? () => setState(() => quantity++) : null, // Desabilita no stock máximo
                    icon: const Icon(Icons.add, size: 18),
                    color: quantity < widget.product.stock ? AppColors.textPrimary : Colors.grey.shade400,
                    splashRadius: 20,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Botão Adicionar ao Carrinho
            Expanded(
              child: CustomButton(
                text: 'Adicionar',
                // Passa a função _addToCart OU null (para desabilitar)
                onPressed: widget.product.stock > 0 ? _addToCart : null,
                icon: Icons.add_shopping_cart_rounded,
                height: 52,
                // O CustomButton (corrigido) agora trata o estilo desabilitado internamente
              ),
            ),
          ],
        ),
      ),
    );
  }


  // Função auxiliar para gerar dados simulados de especificações
  List<Map<String, String>> _getProductSpecs() {
    // Isto deve ser substituído por dados reais vindos do backend/modelo
    switch (widget.product.category.toLowerCase()) {
      case 'eletrônicos':
        return [
          {'label': 'Marca', 'value': 'Marca Exemplo (Simulado)'},
          {'label': 'Modelo', 'value': widget.product.name.split(' ').last},
          {'label': 'Garantia', 'value': '12 meses'},
        ];
      case 'calçados':
        return [
          {'label': 'Marca', 'value': 'Marca Exemplo (Simulado)'},
          {'label': 'Material', 'value': 'Sintético (Simulado)'},
          {'label': 'Indicado para', 'value': 'Corrida / Casual (Simulado)'},
        ];
      case 'games':
        if (widget.product.id == '7') { // Específico para o PS5 (ID 7 no mock)
          return [
            {'label': 'Plataforma', 'value': 'PlayStation 5'},
            {'label': 'Armazenamento', 'value': 'SSD 825GB'},
            {'label': 'CPU', 'value': 'AMD Zen 2 (8x @ 3.5GHz)'},
            {'label': 'GPU', 'value': 'AMD RDNA 2 (10.28 TFLOPs)'},
            {'label': 'Memória RAM', 'value': '16GB GDDR6'},
          ];
        }
        return []; // Vazio para outros jogos sem specs definidas
      default:
        return [
          {'label': 'Disponibilidade', 'value': widget.product.stock > 0 ? 'Em estoque' : 'Fora de estoque'},
          {'label': 'SKU', 'value': 'SKU-${widget.product.id}-XYZ'},
        ];
    }
  }
}