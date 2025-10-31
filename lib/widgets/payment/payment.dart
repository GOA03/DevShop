import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Payment extends StatefulWidget {
  const Payment({
    super.key,
    required this.cardHolder,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardBrand,
  });

  final String cardHolder;
  final String cardNumber;
  final String expiryDate;
  final String cardBrand;

  @override
  State<Payment> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Payment> {
  String get maskedNumber {
    // Exemplo: "**** **** **** 1234"
    return '**** **** **** ${widget.cardNumber.substring(widget.cardNumber.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bandeira do cartão
          Align(alignment: Alignment.topRight, child: _buildCardBrand()),
          const Spacer(),
          Text(
            maskedNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Titular",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    widget.cardHolder.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Validade",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    widget.expiryDate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardBrand() {
    switch (widget.cardBrand.toLowerCase()) {
      case 'visa':
        return Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/4/41/Visa_Logo.png',
          height: 40,
        );
      case 'mastercard':
        return Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/2/2a/Mastercard-logo.svg',
          height: 40,
        );
      default:
        return Text(
          widget.cardBrand,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        );
    }
  }
}
