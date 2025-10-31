import 'package:flutter/material.dart';
import 'package:get/get.dart';

// (Em produção, você usaria GetStorage para salvar a preferência)
// import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  // final _box = GetStorage(); // Para persistência
  // final _key = 'isDarkMode'; // Chave de armazenamento

  // Inicia com o valor salvo, ou 'false' (claro) se não houver
  // final RxBool _isDarkMode = false.obs;
  // bool get isDarkMode => _isDarkMode.value;

  // -- Versão Simples (sem persistência) --
  final RxBool _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;


  // Getter que retorna o ThemeMode correspondente
  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  // @override
  // void onInit() {
  //   super.onInit();
  //   _isDarkMode.value = _box.read(_key) ?? false; // Carrega o tema salvo
  // }

  // Função para alternar o tema
  void toggleTheme(bool isDark) {
    _isDarkMode.value = isDark;
    Get.changeThemeMode(themeMode); // Muda o tema globalmente no GetX
    // _box.write(_key, isDark); // Salva a preferência
    update(); // Notifica os widgets (embora Obx já faça isso)
  }
}