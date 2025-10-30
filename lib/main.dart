import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importar Get
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/colors.dart';
import 'views/splash/splash_screen.dart';
import 'controllers/theme_controller.dart'; // Importar o controlador de tema
import 'core/theme/app_theme.dart'; // Importar os temas

void main() {
  Get.put(ThemeController());
  // (Se usar persistência, descomente esta linha)
  // await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Encontra o controlador de tema que acabámos de inicializar
    final ThemeController themeController = Get.find();

    // ALTERAÇÃO: Trocado MaterialApp por GetMaterialApp
    return GetMaterialApp(
      title: 'DevShop',
      debugShowCheckedModeBanner: false,

      // ALTERAÇÃO: Define os temas claro e escuro
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,

      // ALTERAÇÃO: O ThemeMode é controlado pelo GetX
      themeMode: themeController.themeMode,

      home: const SplashScreen(),
    );
  }
}