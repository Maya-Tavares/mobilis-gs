import 'package:flutter/material.dart';

import '../models/equipamento.dart';
import '../models/estado_requisicao.dart';
import '../services/filtro_service.dart';
import '../theme/app_theme.dart';
import '../widgets/equipamento_card.dart';
import '../widgets/estado_carregamento.dart';
import '../widgets/tela_base.dart';

class HomeScreen extends StatefulWidget {
  final EstadoRequisicao estado;
  final String? erro;
  final List<Equipamento> equipamentos;
  final Set<int> favoritos;
  final VoidCallback onTentarNovamente;
  final Future<void> Function() onRefresh;
  final void Function(int id) onFavoritar;
  final void Function(Equipamento e) onAbrirDetalhe;

  const HomeScreen({
    super.key,
    required this.estado,
    required this.erro,
    required this.equipamentos,
    required this.favoritos,
    required this.onTentarNovamente,
    required this.onRefresh,
    required this.onFavoritar,
    required this.onAbrirDetalhe,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _busca = '';
  String _tipo = FiltroEquipamentos.todos;
  String _modalidade = FiltroEquipamentos.todos;

  @override
  Widget build(BuildContext context) {
    return TelaBase(
      titulo: 'Mobilis',
      mostrarVoltar: false,
      tituloWidget: Row(children: [
        Image.asset('assets/images/logo.png', width: 32, height: 32),
        const SizedBox(width: AppEspacos.sm),
        const Text('Mobilis'),
      ]),
      corpo: EstadoCarregamento(
        estado: widget.estado,
        mensagemErro: widget.erro,
        onTentarNovamente: widget.onTentarNovamente,
        construirSucesso: _conteudo,
      ),
    );
  }

  Widget _conteudo(BuildContext context) {
    final filtrados = FiltroEquipamentos.aplicar(widget.equipamentos,
        busca: _busca, tipo: _tipo, modalidade: _modalidade);
    final tipos = FiltroEquipamentos.tipos(widget.equipamentos);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppEspacos.md, AppEspacos.md, AppEspacos.md, AppEspacos.sm),
          child: TextField(
            onChanged: (v) => setState(() => _busca = v),
            decoration: const InputDecoration(
              hintText: 'Buscar equipamento, instituição ou bairro',
              prefixIcon: Icon(Icons.search),
              isDense: true,
            ),
          ),
        ),
        _linhaChips(tipos, _tipo, (v) => setState(() => _tipo = v)),
        _linhaChips(
            const [FiltroEquipamentos.todos, 'Empréstimo', 'Doação'], _modalidade,
            (v) => setState(() => _modalidade = v)),
        Expanded(
          child: RefreshIndicator(
            onRefresh: widget.onRefresh,
            child: filtrados.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 80),
                      Icon(Icons.search_off, size: 56, color: AppCores.textoSecundario),
                      SizedBox(height: AppEspacos.md),
                      Center(child: Text('Nenhum equipamento encontrado para esse filtro.')),
                    ],
                  )
                : GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppEspacos.md),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 260,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: AppEspacos.md,
                      mainAxisSpacing: AppEspacos.md,
                    ),
                    itemCount: filtrados.length,
                    itemBuilder: (context, i) {
                      final e = filtrados[i];
                      return EquipamentoCard(
                        equipamento: e,
                        favorito: widget.favoritos.contains(e.id),
                        onTap: () => widget.onAbrirDetalhe(e),
                        onFavoritar: () => widget.onFavoritar(e.id),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _linhaChips(List<String> opcoes, String atual, ValueChanged<String> aoSelecionar) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppEspacos.md),
        children: [
          for (final o in opcoes)
            Padding(
              padding: const EdgeInsets.only(right: AppEspacos.sm),
              child: ChoiceChip(
                label: Text(o),
                selected: atual == o,
                onSelected: (_) => aoSelecionar(o),
              ),
            ),
        ],
      ),
    );
  }
}
