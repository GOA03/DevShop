import 'package:dev_shop/core/constants/colors.dart';
import 'package:dev_shop/models/addres.dart';
import 'package:dev_shop/widgets/custom_button.dart';
import 'package:dev_shop/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditAddressForm extends StatefulWidget {
  const EditAddressForm({super.key, required this.address});

  final Addres address;

  @override
  State<EditAddressForm> createState() => _EditAddressFormState();
}

class _EditAddressFormState extends State<EditAddressForm> {
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _countryController;
  late TextEditingController _numberController;
  late TextEditingController _complementoController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _streetController = TextEditingController(text: widget.address.street);
    _cityController = TextEditingController(text: widget.address.city);
    _stateController = TextEditingController(text: widget.address.state);
    _countryController = TextEditingController(text: widget.address.contry);
    _numberController = TextEditingController(text: widget.address.number);
    _complementoController = TextEditingController(text: '');
    _nameController = TextEditingController(text: widget.address.name);
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _numberController.dispose();
    _complementoController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    // No logic for now, just pop
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Editar Endereço',
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
            label: "Nome",
            hint: "Nome do endereço",
            prefixIcon: Icons.label,
            controller: _nameController,
          ),
          CustomTextField(
            label: "Rua",
            hint: "Nome da sua rua",
            prefixIcon: Icons.streetview_outlined,
            controller: _streetController,
          ),
          CustomTextField(
            label: "Cidade",
            hint: "Nome da sua cidade",
            prefixIcon: Icons.location_city,
            controller: _cityController,
          ),
          CustomTextField(
            label: "Estado",
            hint: "Nome do seu estado",
            prefixIcon: Icons.location_city,
            controller: _stateController,
          ),
          CustomTextField(
            label: "País",
            hint: "Nome do seu país",
            prefixIcon: Icons.flag_circle_rounded,
            controller: _countryController,
          ),
          CustomTextField(
            label: "Número",
            hint: "Número da residência",
            prefixIcon: Icons.numbers,
            controller: _numberController,
          ),
          CustomTextField(
            label: "Complemento",
            hint: "Informações complementares para o endereço",
            prefixIcon: Icons.text_fields_rounded,
            controller: _complementoController,
          ),
          CustomButton(
            text: 'Salvar alterações',
            onPressed: _saveAddress,
            icon: Icons.save,
            height: 60,
          ),
        ],
      ),
    );
  }
}
