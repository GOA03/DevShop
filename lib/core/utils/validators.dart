class Validators {
  // Validação de email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    
    // Regex para validar email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Digite um email válido';
    }
    
    return null;
  }

  // Validação de senha
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    
    if (value.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres';
    }
    
    return null;
  }

  // Validação de nome
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    
    if (value.length < 3) {
      return 'Nome deve ter no mínimo 3 caracteres';
    }
    
    return null;
  }

  // Validação de telefone
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }
    
    // Remove caracteres não numéricos
    final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numbers.length < 10 || numbers.length > 11) {
      return 'Digite um telefone válido';
    }
    
    return null;
  }

  // Validação de campo obrigatório genérico
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }
}