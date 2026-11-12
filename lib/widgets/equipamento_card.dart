import 'package:flutter/material.dart';

import '../models/equipamento.dart';
import '../theme/app_theme.dart';

/// Card do equipamento usado na grade da Home e nos favoritos.
class EquipamentoCard extends StatelessWidget {
  final Equipamento equipamento;
  final bool favorito;
  final VoidCallback onTap;
  final VoidCallback onFavoritar;

  const EquipamentoCard({
    super.key,
    required this.equipamento,
    required this.favorito,
    required this.onTap,
    required this.onFavoritar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    equipamento.fotoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, erro, pilha) => const ColoredBox(
                      color: AppCores.fundo,
                      child: Icon(Icons.image_not_supported, color: AppCores.textoSecundario),
                    ),
                    loadingBuilder: (c, child, p) => p == null
                        ? child
                        : const ColoredBox(
                            color: AppCores.fundo,
                            child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: IconButton(
                      onPressed: onFavoritar,
                      tooltip: favorito ? 'Remover dos favoritos' : 'Favoritar',
                      style: IconButton.styleFrom(backgroundColor: Colors.white70),
                      icon: Icon(favorito ? Icons.favorite : Icons.favorite_border,
                          color: favorito ? AppCores.erro : AppCores.textoSecundario),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppEspacos.sm + 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(equipamento.tipo,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(equipamento.instituicao.nome,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Row(children: [
                    const Icon(Icons.place, size: 14, color: AppCores.textoSecundario),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(equipamento.instituicao.bairro,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ]),
                  const SizedBox(height: AppEspacos.xs),
                  Wrap(
                    spacing: AppEspacos.xs,
                    children: [
                      for (final m in equipamento.modalidades)
                        Chip(
                          label: Text(m, style: const TextStyle(fontSize: 11)),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
