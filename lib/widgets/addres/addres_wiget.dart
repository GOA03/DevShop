import 'package:dev_shop/core/constants/colors.dart';
import 'package:dev_shop/models/addres.dart';
import 'package:dev_shop/views/forms/edit_address_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddresWiget extends StatefulWidget {
  const AddresWiget({
    super.key,
    required this.address,
    required this.onSetDefault,
    this.isDefault = false,
  });

  final Addres address;
  final VoidCallback onSetDefault;
  final bool isDefault;

  @override
  State<AddresWiget> createState() => _AddresState();
}

class _AddresState extends State<AddresWiget> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.warning_rounded, color: Colors.red.shade400, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'Confirmar Exclusão',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(
          'Tem certeza que deseja excluir este endereço?',
          style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Ação de excluir
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: Text(
              'Excluir',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTapDown: (_) => _scaleController.forward(),
          onTapUp: (_) => _scaleController.reverse(),
          onTapCancel: () => _scaleController.reverse(),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isDefault 
                    ? AppColors.primary.withOpacity(0.3)
                    : Colors.grey.shade200,
                width: widget.isDefault ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.isDefault
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: _isHovered ? 15 : 10,
                  offset: Offset(0, _isHovered ? 6 : 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Gradiente decorativo
                  if (widget.isDefault)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header com nome e badge
                        Row(
                          children: [
                            // Ícone
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: widget.isDefault
                                    ? AppColors.primary.withOpacity(0.1)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.location_on_rounded,
                                color: widget.isDefault
                                    ? AppColors.primary
                                    : Colors.grey.shade600,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Nome
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.address.name,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  if (widget.isDefault)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Padrão',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Informações do endereço
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAddressInfo(
                                Icons.signpost_rounded,
                                '${widget.address.street}, ${widget.address.number}',
                              ),
                              const SizedBox(height: 8),
                              _buildAddressInfo(
                                Icons.location_city_rounded,
                                '${widget.address.city} - ${widget.address.state}',
                              ),
                              const SizedBox(height: 8),
                              _buildAddressInfo(
                                Icons.public_rounded,
                                widget.address.contry,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Botões de ação
                        Row(
                          children: [
                            // Botão Editar
                            Expanded(
                              child: _buildActionButton(
                                label: "Editar",
                                icon: Icons.edit_rounded,
                                color: AppColors.primary,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditAddressForm(address: widget.address),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Botão Excluir
                            Expanded(
                              child: _buildActionButton(
                                label: "Excluir",
                                icon: Icons.delete_rounded,
                                color: Colors.red.shade400,
                                onPressed: _showDeleteDialog,
                              ),
                            ),
                          ],
                        ),

                        // Botão definir como padrão (se não for padrão)
                        if (!widget.isDefault) ...[
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: widget.onSetDefault,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: BorderSide(
                                  color: AppColors.primary.withOpacity(0.3),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                              label: Text(
                                'Definir como padrão',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressInfo(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}