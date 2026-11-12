import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/equipamento.dart';
import '../models/pedido.dart';
import '../services/preferencias_service.dart';
import '../theme/app_theme.dart';
import '../widgets/botao_primario.dart';
import '../widgets/status_chip.dart';
import '../widgets/tela_base.dart';

class DetalheEquipamentoScreen extends StatefulWidget {
  final Equipamento equipamento;
  final bool favoritoInicial;
  final VoidCallback onFavoritar;

  const DetalheEquipamentoScreen({
    super.key,
    required this.equipamento,
    required this.favoritoInicial,
    required this.onFavoritar,
  });

  @override
  State<DetalheEquipamentoScreen> createState() => _DetalheEquipamentoScreenState();
}

class _DetalheEquipamentoScreenState extends State<DetalheEquipamentoScreen> {
  final _prefs = PreferenciasService();
  late bool _favorito = widget.favoritoInicial;
  late String _modalidade = widget.equipamento.modalidades.first;
  bool _salvando = false;

  Equipamento get _e => widget.equipamento;

  Future<void> _abrir(Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Não foi possível abrir o link.')));
    }
  }

  Future<void> _solicitar() async {
    setState(() => _salvando = true);
    final jaPediu = await _prefs.temPedido(_e.id);
    if (jaPediu) {
      if (!mounted) return;
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Você já tem um pedido para este equipamento.')));
      return;
    }
    await _prefs.adicionarPedido(Pedido(
      equipamentoId: _e.id,
      tipo: _e.tipo,
      instituicao: _e.instituicao.nome,
      modalidade: _modalidade,
      data: DateTime.now(),
    ));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Pedido de ${_e.tipo} ($_modalidade) registrado! Retire em ${_e.instituicao.nome}.')));
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final inst = _e.instituicao;
    final tema = Theme.of(context).textTheme;
    return TelaBase(
      titulo: _e.tipo,
      acoes: [
        IconButton(
          tooltip: _favorito ? 'Remover dos favoritos' : 'Favoritar',
          icon: Icon(_favorito ? Icons.favorite : Icons.favorite_border),
          onPressed: () {
            widget.onFavoritar();
            setState(() => _favorito = !_favorito);
          },
        ),
      ],
      corpo: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.network(
              _e.fotoUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, erro, pilha) => const ColoredBox(
                color: AppCores.fundo,
                child: Icon(Icons.image_not_supported, size: 48),
              ),
              loadingBuilder: (c, child, p) => p == null
                  ? child
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppEspacos.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Text(_e.tipo, style: tema.headlineSmall)),
                  StatusChip(status: _e.status),
                ]),
                const SizedBox(height: AppEspacos.sm),
                Text(_e.descricao),
                const SizedBox(height: AppEspacos.md),
                Card(
                  child: Column(children: [
                    ListTile(
                        leading: const Icon(Icons.build_circle_outlined),
                        title: const Text('Estado de conservação'),
                        subtitle: Text(_e.estadoConservacao)),
                    ListTile(
                        leading: const Icon(Icons.schedule),
                        title: const Text('Prazo do empréstimo'),
                        subtitle: Text('${_e.prazoDiasEmprestimo} dias')),
                  ]),
                ),
                const SizedBox(height: AppEspacos.md),
                Text('Instituição', style: tema.titleMedium),
                const SizedBox(height: AppEspacos.sm),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppEspacos.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${inst.nome} (${inst.tipo})', style: tema.titleMedium),
                        const SizedBox(height: AppEspacos.xs),
                        Text('${inst.endereco} - ${inst.bairro}, CEP ${inst.cep}'),
                        const SizedBox(height: AppEspacos.xs),
                        Row(children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: AppEspacos.xs),
                          Expanded(child: Text('Retirada: ${inst.horarioRetirada}')),
                        ]),
                        const SizedBox(height: AppEspacos.md),
                        Row(children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.directions),
                              label: const Text('Como chegar'),
                              onPressed: () => _abrir(Uri.parse(
                                  'https://www.google.com/maps/search/?api=1&query=${inst.latitude},${inst.longitude}')),
                            ),
                          ),
                          const SizedBox(width: AppEspacos.sm),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.call),
                              label: const Text('Ligar'),
                              onPressed: () => _abrir(
                                  Uri(scheme: 'tel', path: inst.telefone.replaceAll(RegExp(r'[^\d+]'), ''))),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppEspacos.md),
                Text('Modalidade', style: tema.titleMedium),
                const SizedBox(height: AppEspacos.sm),
                Wrap(
                  spacing: AppEspacos.sm,
                  children: [
                    for (final m in _e.modalidades)
                      ChoiceChip(
                        label: Text(m),
                        selected: _modalidade == m,
                        onSelected: (_) => setState(() => _modalidade = m),
                      ),
                  ],
                ),
                const SizedBox(height: AppEspacos.lg),
                BotaoPrimario(
                  texto: 'Solicitar',
                  icone: Icons.volunteer_activism,
                  onPressed: _e.disponivel && !_salvando ? _solicitar : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
