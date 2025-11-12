import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../widgets/custom_button.dart';

class CheckoutOptionsScreen extends StatefulWidget {
  final double totalAmount;
  final double totalSavings;
  final VoidCallback onConfirmation;

  const CheckoutOptionsScreen({
    super.key,
    required this.totalAmount,
    required this.totalSavings,
    required this.onConfirmation,
  });

  @override
  State<CheckoutOptionsScreen> createState() => _CheckoutOptionsScreenState();
}

class _CheckoutOptionsScreenState extends State<CheckoutOptionsScreen> {
  String? selectedAddress;
  String? selectedPayment;
  String? selectedCard;

  final List<String> addresses = [
    'Rua das Flores, 123 - São Paulo',
    'Av. Paulista, 999 - São Paulo',
  ];

  final List<String> paymentMethods = [
    'Cartão de Crédito',
    'Pix',
    'Boleto Bancário',
  ];

  final List<String> cards = ['MasterCard •••• 1234', 'Visa •••• 5678'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Finalizar Compra',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Endereço de entrega'),
            _buildSelectableList(
              items: addresses,
              selectedItem: selectedAddress,
              onSelected: (value) => setState(() => selectedAddress = value),
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Forma de pagamento'),
            _buildSelectableList(
              items: paymentMethods,
              selectedItem: selectedPayment,
              onSelected: (value) => setState(() => selectedPayment = value),
            ),
            const SizedBox(height: 20),

            if (selectedPayment == 'Cartão de Crédito') ...[
              _buildSectionTitle('Cartão selecionado'),
              _buildSelectableList(
                items: cards,
                selectedItem: selectedCard,
                onSelected: (value) => setState(() => selectedCard = value),
              ),
              const SizedBox(height: 20),
            ],

            _buildOrderSummary(),
            const SizedBox(height: 24),

            CustomButton(
              text: 'Confirmar Pedido',
              icon: Icons.check_circle_outline,
              onPressed: _confirmOrder,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSelectableList({
    required List<String> items,
    required String? selectedItem,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      children: items.map((item) {
        final isSelected = item == selectedItem;
        return GestureDetector(
          onTap: () => onSelected(item),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withAlpha(40)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumo do Pedido',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:', style: TextStyle(fontSize: 16)),
              Text(
                'R\$ ${widget.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          if (widget.totalSavings > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Você economizou:'),
                Text(
                  'R\$ ${widget.totalSavings.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _confirmOrder() {
    if (selectedAddress == null || selectedPayment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um endereço e forma de pagamento.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    widget.onConfirmation();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pedido confirmado com sucesso!'),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context, true);
  }
}
