import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart'; // Importa as cores base

class AppThemes {
  // --- TEMA CLARO (LIGHT) ---
  // (Movido do main.dart)
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light, // Define o brilho como claro
    primaryColor: AppColors.primary, // Cor primária
    scaffoldBackgroundColor: AppColors.background, // Fundo do ecrã
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      background: AppColors.background, // Fundo (ex: #F5F5F5)
      surface: AppColors.surface, // Superfície (ex: Cards, #FFFFFF)
      onBackground: AppColors.textPrimary, // Texto sobre o fundo
      onSurface: AppColors.textPrimary, // Texto sobre a superfície
    ),
    useMaterial3: true,
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData(brightness: Brightness.light).textTheme,
    ).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),

    // Tema da AppBar (Claro)
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white, // Ícones e texto na AppBar
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    // Tema dos Botões (Claro)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    // Tema dos Cards (Claro)
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.surface, // Branco
    ),

    // Tema dos Inputs (Claro)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.withAlpha(13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.grey.withAlpha(51),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
      hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary.withAlpha(153)),
      prefixIconColor: AppColors.textSecondary,
    ),
  );


  // --- TEMA ESCURO (DARK) ---
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark, // Define o brilho como escuro
    primaryColor: AppColors.primaryLight, // Usar um azul mais claro no modo escuro
    scaffoldBackgroundColor: const Color(0xFF121212), // Fundo escuro padrão
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      background: const Color(0xFF121212), // Fundo
      surface: const Color(0xFF1E1E1E), // Superfície (Cards)
      onBackground: Colors.white.withOpacity(0.9), // Texto sobre o fundo
      onSurface: Colors.white.withOpacity(0.9), // Texto sobre a superfície
      primary: AppColors.primaryLight, // Cor primária (azul claro)
      secondary: AppColors.secondary, // Cor secundária (vermelho)
    ),
    useMaterial3: true,
    // Define o tema de texto para ser legível no escuro
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ).apply(
      bodyColor: Colors.white.withOpacity(0.9),
      displayColor: Colors.white.withOpacity(0.9),
    ),

    // Tema da AppBar (Escuro)
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E), // Cor de superfície escura
      foregroundColor: Colors.white, // Ícones e texto brancos
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    // Tema dos Botões (Escuro)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight, // Azul claro
        foregroundColor: Colors.black, // Texto escuro para contraste
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    // Tema dos Cards (Escuro)
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFF1E1E1E), // Cor de superfície escura
    ),

    // Tema dos Inputs (Escuro)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade800.withOpacity(0.5), // Fundo do input
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.grey.shade700, // Borda subtil
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: AppColors.primaryLight, // Borda com cor primária clara
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      labelStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
      hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
      prefixIconColor: Colors.grey.shade400, // Cor do ícone prefixo
    ),

    // Define a cor do Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight; // Cor do "polegar" (bolinha) quando ativo
        }
        return Colors.grey.shade400; // Cor quando inativo
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight.withOpacity(0.5); // Cor do "trilho" quando ativo
        }
        return Colors.grey.shade700; // Cor quando inativo
      }),
    ),
  );
}