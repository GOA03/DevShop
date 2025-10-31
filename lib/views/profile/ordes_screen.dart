import 'package:dev_shop/core/constants/colors.dart';
import 'package:dev_shop/widgets/orders/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrdesScreen extends StatelessWidget {
  const OrdesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Meus Pedidos',
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
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Ação para atualizar a lista de pedidos
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Order(
            productName: "Relógio Inteligente",
            price: 299.99,
            deliveryEstimate: "1 - 5 de Nov",
            imageUrl:
                "https://images.unsplash.com/photo-1580906855283-18b2e28b8ab8",
          ),
        ],
      ),
    );
  }
}
