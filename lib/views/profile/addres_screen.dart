import 'package:dev_shop/controllers/addres_controller.dart';
import 'package:dev_shop/core/constants/colors.dart';
import 'package:dev_shop/models/addres.dart';
import 'package:dev_shop/views/forms/addres_form.dart';
import 'package:dev_shop/widgets/addres/addres_wiget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddresScreen extends StatefulWidget {
  const AddresScreen({super.key});

  @override
  State<AddresScreen> createState() => _AddresScreenState();
}

class _AddresScreenState extends State<AddresScreen> {
  List<Addres> _addresses = [];
  late final AddresController _addresController = Get.put(AddresController());

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() {
    SharedPreferences.getInstance().then((prefs) {
      _addresController
          .getAll(id: prefs.getInt('userId')!, token: prefs.getString('token')!)
          .then((value) {
            setState(() {
              if (value.isEmpty) return;
              _addresses = value;
            });
          });
    });
  }

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const AddresForm();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: _addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 80,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Sua lista de endereços está vazia',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adicione novos endereços para seguir com as compras',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 90.0),
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                final addr = _addresses[index];
                return AddresWiget(address: addr, onSetDefault: () => (addr));
              },
            ),
    );
  }
}
