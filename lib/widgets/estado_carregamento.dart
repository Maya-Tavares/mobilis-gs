import 'package:flutter/material.dart';

import '../models/estado_requisicao.dart';
import '../theme/app_theme.dart';

/// Mostra carregando / erro com "Tentar novamente"; no sucesso exibe [construirSucesso].
class EstadoCarregamento extends StatelessWidget {
  final EstadoRequisicao estado;
  final String? mensagemErro;
  final VoidCallback? onTentarNovamente;
  final WidgetBuilder construirSucesso;

  const EstadoCarregamento({
    super.key,
    required this.estado,
    required this.construirSucesso,
    this.mensagemErro,
    this.onTentarNovamente,
  });

  @override
  Widget build(BuildContext context) {
    switch (estado) {
      case EstadoRequisicao.sucesso:
        return construirSucesso(context);
      case EstadoRequisicao.erro:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppEspacos.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, size: 56, color: AppCores.textoSecundario),
                const SizedBox(height: AppEspacos.md),
                Text(
                  mensagemErro ?? 'Não foi possível carregar. Verifique sua conexão.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppEspacos.md),
                OutlinedButton.icon(
                  onPressed: onTentarNovamente,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        );
      case EstadoRequisicao.carregando:
        return const Center(child: CircularProgressIndicator());
      case EstadoRequisicao.inicial:
        return const SizedBox.shrink();
    }
  }
}
