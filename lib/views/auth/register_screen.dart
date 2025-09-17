import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/validators.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _acceptTerms = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // Animação para os campos do formulário
  late AnimationController _formAnimationController;
  late List<Animation<Offset>> _fieldAnimations;

  @override
  void initState() {
    super.initState();
    
    // Animação principal
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));
    
    Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
    ));
    
    // Animação dos campos
    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fieldAnimations = List.generate(
      5,
      (index) => Tween<Offset>(
        begin: const Offset(0.5, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _formAnimationController,
          curve: Interval(
            index * 0.1,
            0.5 + index * 0.1,
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );
    
    _animationController.forward();
    _formAnimationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    _formAnimationController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirme sua senha';
    }
    
    if (value != _passwordController.text) {
      return 'As senhas não coincidem';
    }
    
    return null;
  }

  void _handleRegister() async {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Você precisa aceitar os termos de uso',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simula processo de cadastro
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Mostra mensagem de sucesso
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                'Cadastro realizado com sucesso!',
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

      // Navegar para home
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 40),
                _buildRegisterForm(),
                const SizedBox(height: 30),
                _buildLoginLink(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(76),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_add,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Criar Conta',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Preencha os dados para começar',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Nome
          SlideTransition(
            position: _fieldAnimations[0],
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: CustomTextField(
                label: 'Nome Completo',
                hint: 'Digite seu nome',
                prefixIcon: Icons.person_outline,
                controller: _nameController,
                keyboardType: TextInputType.name,
                validator: Validators.validateName,
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Email
          SlideTransition(
            position: _fieldAnimations[1],
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: CustomTextField(
                label: 'Email',
                hint: 'Digite seu email',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Telefone
          SlideTransition(
            position: _fieldAnimations[2],
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: CustomTextField(
                label: 'Telefone',
                hint: '(00) 00000-0000',
                prefixIcon: Icons.phone_outlined,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Senha
          SlideTransition(
            position: _fieldAnimations[3],
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: CustomTextField(
                label: 'Senha',
                hint: 'Mínimo 6 caracteres',
                prefixIcon: Icons.lock_outline,
                controller: _passwordController,
                isPassword: true,
                validator: Validators.validatePassword,
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Confirmar Senha
          SlideTransition(
            position: _fieldAnimations[4],
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: CustomTextField(
                label: 'Confirmar Senha',
                hint: 'Digite a senha novamente',
                prefixIcon: Icons.lock_outline,
                controller: _confirmPasswordController,
                isPassword: true,
                validator: _validateConfirmPassword,
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Termos de uso
          FadeTransition(
            opacity: _fadeAnimation,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _acceptTerms ? AppColors.primary : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: 'Li e concordo com os '),
                        TextSpan(
                          text: 'Termos de Uso',
                          style: GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(text: ' e '),
                        TextSpan(
                          text: 'Política de Privacidade',
                          style: GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          // Botão de cadastro
          FadeTransition(
            opacity: _fadeAnimation,
            child: CustomButton(
              text: 'Criar Conta',
              onPressed: _handleRegister,
              isLoading: _isLoading,
              icon: Icons.person_add,
              height: 60,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Divider
          FadeTransition(
            opacity: _fadeAnimation,
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey.withAlpha(76),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Ou cadastre-se com',
                    style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey.withAlpha(76),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Social buttons
          FadeTransition(
            opacity: _fadeAnimation,
            child: Row(
              children: [
                Expanded(
                  child: _buildSocialButton(
                    icon: Icons.g_mobiledata,
                    text: 'Google',
                    color: const Color(0xFFDB4437),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cadastro com Google em breve!')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSocialButton(
                    icon: Icons.facebook,
                    text: 'Facebook',
                    color: const Color(0xFF1877F2),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cadastro com Facebook em breve!')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.withAlpha(51),
            width: 1,
          ),
                    boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Já tem uma conta?',
            style: GoogleFonts.poppins(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: Text(
              'Faça login',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}