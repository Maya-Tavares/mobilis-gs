import 'package:flutter/material.dart';

import '../models/endereco.dart';
import '../models/equipamento.dart';
import '../models/estado_requisicao.dart';
import '../models/perfil.dart';
import '../services/cep_service.dart';
import '../services/preferencias_service.dart';
import '../theme/app_theme.dart';
import '../widgets/botao_primario.dart';
import '../widgets/equipamento_card.dart';
import '../widgets/estado_carregamento.dart';
import '../widgets/tela_base.dart';

class PerfilScreen extends StatefulWidget {
  final List<Equipamento> favoritos;
  final Set<int> favoritosIds;
  final void Function(int id) onFavoritar;
  final void Function(Equipamento e) onAbrirDetalhe;

  const PerfilScreen({
    super.key,
    required this.favoritos,
    required this.favoritosIds,
    required this.onFavoritar,
    required this.onAbrirDetalhe,
  });

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _prefs = PreferenciasService();
  final _cepService = CepService();
  final _nome = TextEditingController();
  final _cep = TextEditingController();
  final _logradouro = TextEditingController();
  final _bairro = TextEditingController();
  final _cidade = TextEditingController();

  EstadoRequisicao _estadoCep = EstadoRequisicao.inicial;
  String? _erroCep;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final p = await _prefs.perfil();
    if (!mounted) return;
    setState(() {
      _nome.text = p.nome;
      _cep.text = p.cep;
      _logradouro.text = p.logradouro;
      _bairro.text = p.bairro;
      _cidade.text = p.cidade;
      if (p.logradouro.isNotEmpty) _estadoCep = EstadoRequisicao.sucesso;
    });
  }

  Future<void> _buscarCep() async {
    setState(() => _estadoCep = EstadoRequisicao.carregando);
    try {
      final Endereco e = await _cepService.buscar(_cep.text);
      if (!mounted) return;
      setState(() {
        _logradouro.text = e.logradouro;
        _bairro.text = e.bairro;
        _cidade.text = '${e.localidade} - ${e.uf}';
        _estadoCep = EstadoRequisicao.sucesso;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erroCep = e is CepException
            ? e.mensagem
            : 'Não foi possível consultar o CEP. Verifique sua conexão e tente novamente.';
        _estadoCep = EstadoRequisicao.erro;
      });
    }
  }

  void _aoDigitarCep(String valor) {
    if (CepService.limpar(valor).length == 8) {
      _buscarCep();
    } else if (_estadoCep != EstadoRequisicao.inicial) {
      setState(() => _estadoCep = EstadoRequisicao.inicial);
    }
  }

  Future<void> _salvar() async {
    await _prefs.salvarPerfil(Perfil(
      nome: _nome.text.trim(),
      cep: _cep.text.trim(),
      logradouro: _logradouro.text.trim(),
      bairro: _bairro.text.trim(),
      cidade: _cidade.text.trim(),
    ));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil salvo!')));
  }

  @override
  void dispose() {
    for (final c in [_nome, _cep, _logradouro, _bairro, _cidade]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;
    return TelaBase(
      titulo: 'Perfil',
      mostrarVoltar: false,
      corpo: ListView(
        padding: const EdgeInsets.all(AppEspacos.md),
        children: [
          Text('Meus dados', style: tema.headlineSmall),
          const SizedBox(height: AppEspacos.md),
          TextField(
            controller: _nome,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Nome', prefixIcon: Icon(Icons.person_outline)),
          ),
          const SizedBox(height: AppEspacos.md),
          TextField(
            controller: _cep,
            keyboardType: TextInputType.number,
            maxLength: 9,
            onChanged: _aoDigitarCep,
            decoration: const InputDecoration(
                labelText: 'CEP', hintText: '01310-100', prefixIcon: Icon(Icons.location_on_outlined)),
          ),
          if (_estadoCep != EstadoRequisicao.inicial)
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 150),
              child: EstadoCarregamento(
                estado: _estadoCep,
                mensagemErro: _erroCep,
                onTentarNovamente: _buscarCep,
                construirSucesso: (context) => Column(children: [
                  TextField(
                      controller: _logradouro,
                      decoration: const InputDecoration(labelText: 'Logradouro')),
                  const SizedBox(height: AppEspacos.md),
                  TextField(
                      controller: _bairro, decoration: const InputDecoration(labelText: 'Bairro')),
                  const SizedBox(height: AppEspacos.md),
                  TextField(
                      controller: _cidade, decoration: const InputDecoration(labelText: 'Cidade')),
                ]),
              ),
            ),
          const SizedBox(height: AppEspacos.md),
          BotaoPrimario(texto: 'Salvar perfil', icone: Icons.save, onPressed: _salvar),
          const SizedBox(height: AppEspacos.xl),
          Text('Favoritos', style: tema.headlineSmall),
          const SizedBox(height: AppEspacos.md),
          if (widget.favoritos.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppEspacos.md),
                child: Text('Você ainda não favoritou nenhum equipamento. Toque no coração de um item na tela inicial.'),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 260,
                childAspectRatio: 0.68,
                crossAxisSpacing: AppEspacos.md,
                mainAxisSpacing: AppEspacos.md,
              ),
              itemCount: widget.favoritos.length,
              itemBuilder: (context, i) {
                final e = widget.favoritos[i];
                return EquipamentoCard(
                  equipamento: e,
                  favorito: widget.favoritosIds.contains(e.id),
                  onTap: () => widget.onAbrirDetalhe(e),
                  onFavoritar: () => widget.onFavoritar(e.id),
                );
              },
            ),
          const SizedBox(height: AppEspacos.xl),
          Text('Sobre o Mobilis', style: tema.headlineSmall),
          const SizedBox(height: AppEspacos.md),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppEspacos.md),
              child: Text(
                  'O Mobilis conecta quem precisa de equipamentos de apoio à saúde a ONGs, igrejas e hospitais '
                  'que os cedem sem custo, por empréstimo ou doação. Projeto da Global Solution 2026.2 (CitizenTech).'),
            ),
          ),
        ],
      ),
    );
  }
}
