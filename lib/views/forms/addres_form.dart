import 'package:dev_shop/core/constants/colors.dart';
import 'package:dev_shop/widgets/custom_button.dart';
import 'package:dev_shop/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddresForm extends StatefulWidget {
  const AddresForm({super.key});

  @override
  State<AddresForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddresForm> {
  final _formKey = GlobalKey<FormState>();

  // Controladores individuais para cada campo
  final ruaController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final paisController = TextEditingController();
  final numeroController = TextEditingController();
  final complementoController = TextEditingController();

  @override
  void dispose() {
    // Importante para evitar memory leaks
    ruaController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    paisController.dispose();
    numeroController.dispose();
    complementoController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aqui você pode enviar os dados para API, banco, etc.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Endereço adicionado com sucesso!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.poppins(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Novo Endereço', style: textStyle),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            CustomTextField(
              label: "Identificação",
              hint: "Nome para identificar o endereço Ex: casa",
              prefixIcon: Icons.location_city,
              controller: cidadeController,
              validator: (value) => value!.isEmpty ? "Informe o nome" : null,
            ),
            CustomTextField(
              label: "Rua",
              hint: "Nome da sua rua",
              prefixIcon: Icons.streetview_outlined,
              controller: ruaController,
              validator: (value) =>
                  value!.isEmpty ? "Informe o nome da rua" : null,
            ),
            CustomTextField(
              label: "Cidade",
              hint: "Nome da sua cidade",
              prefixIcon: Icons.location_city,
              controller: cidadeController,
              validator: (value) =>
                  value!.isEmpty ? "Informe o nome da cidade" : null,
            ),
            CustomTextField(
              label: "Estado",
              hint: "Nome do seu estado",
              prefixIcon: Icons.map_outlined,
              controller: estadoController,
              validator: (value) => value!.isEmpty ? "Informe o estado" : null,
            ),
            CustomTextField(
              label: "País",
              hint: "Nome do seu país",
              prefixIcon: Icons.flag_circle_rounded,
              controller: paisController,
              validator: (value) => value!.isEmpty ? "Informe o país" : null,
            ),
            CustomTextField(
              label: "Número",
              hint: "Número da residência",
              prefixIcon: Icons.numbers,
              controller: numeroController,
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? "Informe o número" : null,
            ),
            CustomTextField(
              label: "Complemento",
              hint: "Informações complementares (opcional)",
              prefixIcon: Icons.text_fields_rounded,
              controller: complementoController,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Adicionar Endereço',
              onPressed: _submitForm,
              icon: Icons.add_location_alt_rounded,
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
