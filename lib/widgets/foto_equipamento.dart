import 'package:flutter/material.dart';

import '../models/equipamento.dart';
import '../theme/app_theme.dart';

/// Foto do equipamento: usa a imagem local do tipo (Image.asset) quando existe
/// e, caso contrário, a foto da API (Image.network) com ícone de reserva.
class FotoEquipamento extends StatelessWidget {
  final Equipamento equipamento;
  const FotoEquipamento({super.key, required this.equipamento});

  @override
  Widget build(BuildContext context) {
    final asset = equipamento.fotoAsset;
    if (asset != null) {
      return ColoredBox(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(AppEspacos.sm),
          child: Image.asset(asset, fit: BoxFit.contain),
        ),
      );
    }
    return Image.network(
      equipamento.fotoUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, erro, pilha) => ColoredBox(
        color: AppCores.primaria.withValues(alpha: 0.10),
        child: const Center(
          child: Icon(Icons.accessible, size: 64, color: AppCores.primaria),
        ),
      ),
      loadingBuilder: (context, child, progresso) => progresso == null
          ? child
          : const ColoredBox(
              color: AppCores.fundo,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
    );
  }
}
