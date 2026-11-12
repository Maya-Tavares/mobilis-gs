import 'package:flutter/material.dart';

import '../models/pedido.dart';
import '../theme/app_theme.dart';
import '../widgets/status_chip.dart';
import '../widgets/tela_base.dart';

class MeusPedidosScreen extends StatelessWidget {
  final List<Pedido> pedidos;
  final void Function(int equipamentoId) onCancelar;

  const MeusPedidosScreen({super.key, required this.pedidos, required this.onCancelar});

  @override
  Widget build(BuildContext context) {
    return TelaBase(
      titulo: 'Meus pedidos',
      mostrarVoltar: false,
      corpo: pedidos.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(AppEspacos.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox_outlined, size: 96, color: AppCores.textoSecundario),
                    SizedBox(height: AppEspacos.md),
                    Text('Você ainda não fez nenhum pedido.',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: AppEspacos.xs),
                    Text('Encontre um equipamento na tela inicial e toque em "Solicitar".',
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppEspacos.md),
              itemCount: pedidos.length,
              separatorBuilder: (context, i) => const SizedBox(height: AppEspacos.md),
              itemBuilder: (context, i) {
                final p = pedidos[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppEspacos.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                              child: Text(p.tipo, style: Theme.of(context).textTheme.titleMedium)),
                          StatusChip(status: p.status),
                        ]),
                        const SizedBox(height: AppEspacos.xs),
                        Text(p.instituicao, style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: AppEspacos.sm),
                        Row(children: [
                          const Icon(Icons.swap_horiz, size: 16),
                          const SizedBox(width: AppEspacos.xs),
                          Text(p.modalidade),
                          const SizedBox(width: AppEspacos.md),
                          const Icon(Icons.event, size: 16),
                          const SizedBox(width: AppEspacos.xs),
                          Text(p.dataFormatada),
                        ]),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => onCancelar(p.equipamentoId),
                            icon: const Icon(Icons.cancel_outlined),
                            label: const Text('Cancelar pedido'),
                            style: TextButton.styleFrom(foregroundColor: AppCores.erro),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
