import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  // ALTERAÇÃO 1: Tornar o onPressed anulável (pode receber null)
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed, // Agora aceita null
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 56, // Altura padrão
  });

  @override
  Widget build(BuildContext context) {
    // Lógica para determinar a cor principal
    final buttonColor = backgroundColor ??
        (isOutlined ? Colors.transparent : AppColors.primary);
    final fontColor = textColor ??
        (isOutlined ? AppColors.primary : Colors.white);

    // ALTERAÇÃO 2: Definir se o botão está desabilitado
    // (se onPressed for nulo OU se estiver a carregar)
    final bool isDisabled = onPressed == null || isLoading;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), // Raio de borda consistente
        boxShadow: !isOutlined && !isDisabled // Só aplica sombra se não for outlined e estiver habilitado
            ? [
          BoxShadow(
            // Usa a cor do botão para a sombra
            color: buttonColor.withOpacity(0.3),
            blurRadius: 10, // Sombra mais suave
            offset: const Offset(0, 5),
          ),
        ]
            : null,
      ),
      child: ElevatedButton(
        // ALTERAÇÃO 3: Passar o onPressed (que pode ser null) para o ElevatedButton
        // O ElevatedButton trata 'null' como desabilitado
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          // ALTERAÇÃO 4: Definir a cor de fundo com base no estado habilitado/desabilitado
          backgroundColor: isDisabled ? Colors.grey.shade400 : buttonColor,
          // ALTERAÇÃO 5: Definir a cor do texto/ícone com base no estado
          foregroundColor: isDisabled ? Colors.grey.shade700 : fontColor,
          elevation: 0, // Remove a elevação padrão, controlamos com BoxDecoration
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Raio de borda consistente
            side: isOutlined
                ? BorderSide(
              // Cor da borda também muda se estiver desabilitado
              color: isDisabled ? Colors.grey.shade400 : AppColors.primary,
              width: 2,
            )
                : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            // Cor do indicador também muda se desabilitado
            valueColor: AlwaysStoppedAnimation<Color>(isDisabled ? Colors.grey.shade700 : fontColor),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20), // Tamanho do ícone
              const SizedBox(width: 10), // Espaçamento
            ],
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16, // Tamanho da fonte
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center, // Centraliza o texto
            ),
          ],
        ),
      ),
    );
  }
}