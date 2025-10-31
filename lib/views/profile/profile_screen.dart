import 'package:dev_shop/views/favorites/favorites_screen.dart';
import 'package:dev_shop/views/profile/addres_screen.dart';
import 'package:dev_shop/views/profile/ordes_screen.dart';
import 'package:dev_shop/views/profile/paymants_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart'; // Ainda usamos para cores de ícones (accent)
import '../auth/login_screen.dart';
import '../favorites/favorites_screen.dart';
import 'package:get/get.dart';
import '../../controllers/theme_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Dados mockados do usuário
  final String userName = 'João Silva';
  final String userEmail = 'joao.silva@email.com';
  final String userPhone = '(11) 98765-4321';
  final String memberSince = 'Membro desde 2023';
  final int ordersCount = 12;
  final int favoriteCount = 28;
  final int addressCount = 2;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // A cor de fundo agora vem do tema
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context), // Passar o context para ler o tema
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildProfileHeader(context), // Passar o context
                  _buildStatsSection(context), // Passar o context
                  _buildMenuSection(context), // Passar o context
                  _buildSettingsSection(context), // Passar o context
                  _buildLogoutButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A AppBar precisa do BuildContext para aceder ao tema
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 80,
      pinned: true,
      // ALTERAÇÃO: Cor da AppBar agora usa o tema escuro
      // (AppColors.primary no claro, cor de superfície escura no escuro)
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor, // Cor do texto e ícones
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          'Meu Perfil',
          style: GoogleFonts.poppins(
            // A cor do título é definida por 'foregroundColor' ou 'titleTextStyle' no tema
            fontWeight: FontWeight.w600,
          ),
        ),
        background: Container(
          // Mantém o gradiente para o tema claro, mas usa cor sólida no escuro
          decoration: BoxDecoration(
            gradient: Theme.of(context).brightness == Brightness.light
                ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
            )
                : null, // Sem gradiente no modo escuro
            color: Theme.of(context).appBarTheme.backgroundColor, // Cor de fundo sólida
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // Cor de fundo do ícone também reage ao tema
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white.withAlpha(51)
                  : Colors.white.withAlpha(20), // Mais subtil no escuro
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.edit_outlined,
                color: Theme.of(context).appBarTheme.foregroundColor, size: 20),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Editar perfil em breve!')),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // O Cabeçalho precisa do context para o tema
  Widget _buildProfileHeader(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  // ALTERAÇÃO: Borda usa a cor de superfície (branco ou cinza escuro)
                  color: Theme.of(context).colorScheme.surface,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(51),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipOval(
                child: Container(
                  // Usa a cor primária do tema (azul claro ou escuro)
                  color: Theme.of(context).colorScheme.primary,
                  child: Center(
                    child: Text(
                      userName.split(' ').map((e) => e[0]).take(2).join(),
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        // Cor do texto que contrasta com a cor primária
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              userName,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                // ALTERAÇÃO: Cor do texto vinda do tema
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userEmail,
              style: GoogleFonts.poppins(
                fontSize: 14,
                // ALTERAÇÃO: Cor do texto vinda do tema
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                // ALTERAÇÃO: Cor de fundo vinda do tema
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                memberSince,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  // ALTERAÇÃO: Cor do texto vinda do tema
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A Secção de Stats precisa do context para o tema
  Widget _buildStatsSection(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // ALTERAÇÃO: Cor do card vinda do tema
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              // ALTERAÇÃO: Cor da sombra mais subtil no modo escuro
              color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.05 : 0.2),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              context, // Passa o context
              icon: Icons.shopping_bag,
              value: ordersCount.toString(),
              label: 'Pedidos',
              color: AppColors.primary, // Mantém cores de destaque
            ),
            Container(height: 40, width: 1, color: Colors.grey.withAlpha(77)),
            _buildStatItem(
              context, // Passa o context
              icon: Icons.favorite,
              value: favoriteCount.toString(),
              label: 'Favoritos',
              color: AppColors.secondary, // Mantém cores de destaque
            ),
            Container(height: 40, width: 1, color: Colors.grey.withAlpha(76)),
            _buildStatItem(
              context, // Passa o context
              icon: Icons.location_on,
              value: addressCount.toString(),
              label: 'Endereços',
              color: AppColors.accent, // Mantém cores de destaque
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, { // Recebe o context
        required IconData icon,
        required String value,
        required String label,
        required Color color,
      }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withAlpha(25), // Mantém o fundo colorido subtil
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            // ALTERAÇÃO: Cor do texto vinda do tema
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            // ALTERAÇÃO: Cor do texto vinda do tema
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  // A Secção de Menu precisa do context para o tema
  Widget _buildMenuSection(BuildContext context) {
    final menuItems = [
      // ... (lista de menuItems permanece igual) ...
      {
        'icon': Icons.shopping_bag_outlined,
        'title': 'Meus Pedidos',
        'subtitle': 'Acompanhe seus pedidos',
        'color': AppColors.primary,
        'badge': '2',
        'trailing': const OrdesScreen(),
      },
      {
        'icon': Icons.favorite_outline,
        'title': 'Favoritos',
        'subtitle': 'Produtos salvos',
        'color': AppColors.secondary,
        'trailing': const FavoritesScreen(),
      },
      {
        'icon': Icons.location_on_outlined,
        'title': 'Endereços',
        'subtitle': 'Gerenciar endereços de entrega',
        'color': AppColors.accent,
        'trailing': const AddresScreen(),
      },
      {
        'icon': Icons.credit_card_outlined,
        'title': 'Pagamento',
        'subtitle': 'Formas de pagamento',
        'color': Colors.purple,
        'trailing': const PaymantsScreen(),
      },
      {
        'icon': Icons.notifications_outlined,
        'title': 'Notificações',
        'subtitle': 'Central de notificações',
        'color': Colors.orange,
        'badge': '5',
      },
      {
        'icon': Icons.help_outline,
        'title': 'Ajuda e Suporte',
        'subtitle': 'FAQ e contato',
        'color': Colors.teal,
      },
    ];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          // ALTERAÇÃO: Cor do card vinda do tema
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.05 : 0.2),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Menu',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  // ALTERAÇÃO: Cor do texto vinda do tema
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            ...menuItems.map(
              (item) => _buildMenuItem(
                icon: item['icon'] as IconData,
                title: item['title'] as String,
                subtitle: item['subtitle'] as String,
                color: item['color'] as Color,
                badge: item['badge'] as String?,
                isLast: item == menuItems.last,
                trailing: item['trailing'] as Widget?,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    String? badge,
    bool isLast = false,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Navegando para $title...')));
        if (trailing != null) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => trailing),
            );
          });
          return;
        }
      },
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(20))
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
            bottom: BorderSide(
              // ALTERAÇÃO: Cor da borda vinda do tema
              color: Theme.of(context).colorScheme.background.withOpacity(0.5),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withAlpha(25), // Mantém o fundo colorido subtil
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      // ALTERAÇÃO: Cor do texto vinda do tema
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      // ALTERAÇÃO: Cor do texto vinda do tema
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary, // Mantém cor de destaque
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (badge == null)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                // ALTERAÇÃO: Cor do ícone vinda do tema
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }

  // A Secção de Configurações precisa do context para o tema
  Widget _buildSettingsSection(BuildContext context) {
    final ThemeController themeController = Get.find();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // ALTERAÇÃO: Cor do card vinda do tema
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.05 : 0.2),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configurações',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                // ALTERAÇÃO: Cor do texto vinda do tema
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              context, // Passa o context
              title: 'Notificações Push',
              icon: Icons.notifications_active_outlined,
              isSwitch: true,
              value: true, // Valor mockado
              onChanged: (newValue) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Notificações ${newValue ? 'ativadas' : 'desativadas'}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),

            // Switch do Modo Escuro (envolvido em Obx para reatividade)
            Obx(() => _buildSettingItem(
              context, // Passa o context
              title: 'Modo Escuro',
              icon: themeController.isDarkMode
                  ? Icons.dark_mode // Ícone preenchido
                  : Icons.dark_mode_outlined, // Ícone de borda
              isSwitch: true,
              value: themeController.isDarkMode, // Valor reativo
              onChanged: (newValue) {
                themeController.toggleTheme(newValue); // Ação de clique
              },
            )),

            _buildSettingItem(
              context, // Passa o context
              title: 'Idioma',
              icon: Icons.language_outlined,
              trailing: 'Português',
            ),
            _buildSettingItem(
              context, // Passa o context
              title: 'Moeda',
              icon: Icons.attach_money_outlined,
              trailing: 'BRL (R\$)',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context, { // Recebe o context
        required String title,
        required IconData icon,
        bool isSwitch = false,
        bool? value,
        String? trailing,
        bool isLast = false,
        final Function(bool)? onChanged,
      }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
          bottom: BorderSide(
            // ALTERAÇÃO: Cor da borda vinda do tema
            color: Theme.of(context).colorScheme.background.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            // ALTERAÇÃO: Cor do ícone vinda do tema
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                // ALTERAÇÃO: Cor do texto vinda do tema
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          if (isSwitch)
            Switch(
              value: value!,
              onChanged: onChanged,
              // As cores vêm do SwitchThemeData no app_theme.dart
            ),
          if (trailing != null)
            Row(
              children: [
                Text(
                  trailing,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    // ALTERAÇÃO: Cor do texto vinda do tema
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  // ALTERAÇÃO: Cor do ícone vinda do tema
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    // ... (Este widget não precisa de cores do tema, pois usa cores de "erro" fixas) ...
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: ElevatedButton.icon(
          onPressed: () {
            _showLogoutDialog();
          },
          icon: const Icon(Icons.logout),
          label: Text(
            'Sair da Conta',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade600, // Mantém vermelho para "perigo"
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // ALTERAÇÃO: Cores do diálogo vêm do tema
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Sair da Conta',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Tem certeza que deseja sair da sua conta?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(
                // Cor de texto secundário do tema
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        'Logout realizado com sucesso!',
                        style: GoogleFonts.poppins(),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              _navigateToLogin();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600, // Mantém vermelho
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Sair', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
