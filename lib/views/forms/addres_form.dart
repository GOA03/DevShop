import 'package:dev_shop/core/constants/colors.dart';
import 'package:dev_shop/widgets/custom_button.dart';
import 'package:dev_shop/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddresForm extends StatefulWidget {
  const AddresForm({super.key});

  @override
  State<AddresForm> createState() => _AddresFormState();
}

class _AddresFormState extends State<AddresForm> {
  final _textXontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Novo Endereço',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          CustomTextField(
            label: "Rua",
            hint: "Nome da sua rua",
            prefixIcon: Icons.streetview_outlined,
            controller: _textXontroller,
          ),
          CustomTextField(
            label: "Cidade",
            hint: "Nome da sua cidade",
            prefixIcon: Icons.location_city,
            controller: _textXontroller,
          ),
          CustomTextField(
            label: "Estado",
            hint: "Nome do seu estado",
            prefixIcon: Icons.location_city,
            controller: _textXontroller,
          ),
          CustomTextField(
            label: "Pais",
            hint: "Nome do seu pais",
            prefixIcon: Icons.flag_circle_rounded,
            controller: _textXontroller,
          ),
          CustomTextField(
            label: "Numero",
            hint: "Numero da residencia",
            prefixIcon: Icons.numbers,
            controller: _textXontroller,
          ),
          CustomTextField(
            label: "Complemento",
            hint: "Informações complemetares para o endereço",
            prefixIcon: Icons.text_fields_rounded,
            controller: _textXontroller,
          ),
          CustomButton(
            text: 'Adicionar endereço',
            onPressed: () {},
            icon: Icons.add_location_alt_rounded,
            height: 60,
          ),
        ],
      ),
    );
  }
}
