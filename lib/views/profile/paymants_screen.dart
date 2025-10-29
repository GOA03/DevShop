import 'package:dev_shop/core/constants/colors.dart';
import 'package:dev_shop/widgets/payment/payment.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymantsScreen extends StatelessWidget {
  const PaymantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Meus Pagamentos',
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
              // Ação para adicionar novo método de pagamento
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Payment(
            cardHolder: 'João da Silva',
            cardNumber: '1234567890123456',
            expiryDate: '12/27',
            cardBrand: 'visa',
          ),
          Payment(
            cardHolder: 'João da Silva',
            cardNumber: '6548546565448464',
            expiryDate: '12/27',
            cardBrand: 'mastercard ',
          ),
        ],
      ),
    );
  }
}
