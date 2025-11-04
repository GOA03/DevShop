import 'package:dev_shop/core/constants/colors.dart';
import 'package:dev_shop/views/profile/orders_list_sreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Order extends StatefulWidget {
  const Order({
    super.key,
    required this.productName,
    required this.price,
    required this.deliveryEstimate,
    required this.imageUrl,
    this.quantity = 1,
    this.onPressed,
  });

  final String productName;
  final double price;
  final String deliveryEstimate;
  final String imageUrl;
  final int quantity;
  final VoidCallback? onPressed;

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Imagem do produto
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.imageUrl,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 80,
                  width: 80,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // 📦 Informações do produto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Entrega prevista: ${widget.deliveryEstimate}",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Qtd: ${widget.quantity}",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // 💰 Preço e botão
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "R\$ ${widget.price.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsScreen(
                          orderId: "12345",
                          status: "A caminho",
                          deliveryAddress:
                              "Rua das Flores, 123 - São Paulo, SP",
                          totalAmount: 899.90,
                          products: [
                            {
                              'name': 'Relógio Inteligente',
                              'price': 299.99,
                              'oldPrice': 399.99,
                              'quantity': 1,
                              'imageUrl':
                                  'https://images.unsplash.com/photo-1580906855283-18b2e28b8ab8',
                            },
                            {
                              'name': 'Fone Bluetooth',
                              'price': 199.90,
                              'oldPrice': null,
                              'quantity': 2,
                              'imageUrl':
                                  'https://images.unsplash.com/photo-1585386959984-a41552231693',
                            },
                          ],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.receipt_long,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Ver mais",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
