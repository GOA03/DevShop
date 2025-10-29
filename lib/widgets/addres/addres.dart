import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Addres extends StatefulWidget {
  const Addres({
    super.key,
    required this.nome,
    required this.rua,
    required this.bairro,
    required this.cidade,
    required this.pais,
    this.isDefault = false, // parâmetro opcional para indicar se é padrão
  });

  final String nome;
  final String rua;
  final String bairro;
  final String cidade;
  final String pais;
  final bool isDefault;

  @override
  State<Addres> createState() => _AddresState();
}

class _AddresState extends State<Addres> {
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    _isDefault = widget.isDefault; // inicializa o estado
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

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
                  widget.nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),

                // Endereço
                Text(widget.rua),
                Text(widget.bairro),
                Text(widget.cidade),
                Text(widget.pais),
                const SizedBox(height: 6),

                const SizedBox(height: 16),
                const Divider(),

                // Botões de ação
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  children: [
                    _buildActionButton(
                      label: "Alterar",
                      color: Colors.blue.shade600,
                      onPressed: () {},
                    ),
                    _buildActionButton(
                      label: "Excluir",
                      color: Colors.red.shade400,
                      onPressed: () {},
                    ),
                    _buildActionButton(
                      label: _isDefault ? "Padrão" : "Definir como padrão",
                      color: _isDefault ? Colors.grey : Colors.green.shade600,
                      onPressed: _isDefault
                          ? null
                          : () {
                              setState(() {
                                _isDefault = true;
                              });
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
