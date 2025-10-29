import 'package:dev_shop/core/constants/colors.dart';
import 'package:dev_shop/widgets/addres/addres.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddresScreen extends StatelessWidget {
  const AddresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Meus Endereços',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Ação para adicionar novo endereço
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 90.0),
        children: [
          Addres(
            nome: "nome",
            rua: "rua",
            bairro: "bairro",
            cidade: "cidade",
            pais: "pais",
            isDefault: false,
          ),
          Addres(
            nome: "nome",
            rua: "rua",
            bairro: "bairro",
            cidade: "cidade",
            pais: "pais",
            isDefault: false,
          ),
        ],
      ),
    );
  }
}
