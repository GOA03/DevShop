import 'package:dev_shop/models/addres.dart';
import 'package:flutter/material.dart';

class AddresWiget extends StatefulWidget {
  const AddresWiget({
    super.key,
    required this.address,
    required this.onSetDefault,
  });

  final Addres address;
  final VoidCallback onSetDefault;

  @override
  State<AddresWiget> createState() => _AddresState();
}

class _AddresState extends State<AddresWiget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          margin: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome
                Text(
                  widget.address.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),

                // Endereço
                Text(widget.address.street),
                Text(widget.address.city),
                Text(widget.address.state),
                Text(widget.address.contry),
                Text(widget.address.number),

                const SizedBox(height: 16),
                const Divider(),

                // Botões
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  children: [
                    _buildActionButton(
                      label: "Alterar",
                      color: Colors.blue.shade600,
                      onPressed: () {
                        // ação de editar
                      },
                    ),
                    _buildActionButton(
                      label: "Excluir",
                      color: Colors.red.shade400,
                      onPressed: () {
                        // ação de excluir
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 14)),
    );
  }
}


/* */