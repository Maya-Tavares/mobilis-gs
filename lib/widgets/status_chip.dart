import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Chip colorido para o status de um item ou pedido.
class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip({super.key, required this.status});

  Color get _cor {
    switch (status) {
      case 'Disponível':
        return AppCores.primaria;
      case 'Reservado':
        return AppCores.secundaria;
      case 'Emprestado':
      case 'Doado':
        return Colors.orange.shade800;
      default:
        return AppCores.textoSecundario;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppEspacos.sm + 2, vertical: AppEspacos.xs),
      decoration: BoxDecoration(
        color: _cor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status,
          style: TextStyle(color: _cor, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
