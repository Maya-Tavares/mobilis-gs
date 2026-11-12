import 'package:flutter/material.dart';

import '../models/equipamento.dart';
import '../models/estado_requisicao.dart';
import '../models/pedido.dart';
import '../services/equipamento_service.dart';
import '../services/preferencias_service.dart';
import 'detalhe_equipamento_screen.dart';
import 'home_screen.dart';
import 'meus_pedidos_screen.dart';
import 'perfil_screen.dart';

/// Casca do app: BottomNavigationBar entre Home, Meus pedidos e Perfil.
/// Concentra os dados compartilhados (equipamentos, favoritos e pedidos).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _equipamentoService = EquipamentoService();
  final _prefs = PreferenciasService();

  int _aba = 0;
  EstadoRequisicao _estado = EstadoRequisicao.inicial;
  String? _erro;
  List<Equipamento> _equipamentos = [];
  Set<int> _favoritos = {};
  List<Pedido> _pedidos = [];

  @override
  void initState() {
    super.initState();
    _carregarLocal();
    _carregar();
  }

  Future<void> _carregarLocal() async {
    final fav = await _prefs.favoritos();
    final ped = await _prefs.pedidos();
    if (!mounted) return;
    setState(() {
      _favoritos = fav;
      _pedidos = ped;
    });
  }

  /// [silencioso] = pull-to-refresh: mantém a lista na tela enquanto atualiza.
  Future<void> _carregar({bool silencioso = false}) async {
    if (!silencioso) setState(() => _estado = EstadoRequisicao.carregando);
    try {
      final lista = await _equipamentoService.listar();
      if (!mounted) return;
      setState(() {
        _equipamentos = lista;
        _estado = EstadoRequisicao.sucesso;
      });
    } catch (e) {
      if (!mounted) return;
      if (silencioso && _equipamentos.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Não foi possível atualizar. Verifique sua conexão.')));
        return;
      }
      setState(() {
        _erro = 'Não foi possível carregar os equipamentos. Verifique sua conexão e tente novamente.';
        _estado = EstadoRequisicao.erro;
      });
    }
  }

  Future<void> _alternarFavorito(int id) async {
    final novo = await _prefs.alternarFavorito(id);
    if (!mounted) return;
    setState(() => _favoritos = novo);
  }

  Future<void> _cancelarPedido(int equipamentoId) async {
    final lista = await _prefs.cancelarPedido(equipamentoId);
    if (!mounted) return;
    setState(() => _pedidos = lista);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pedido cancelado.')));
  }

  Future<void> _abrirDetalhe(Equipamento e) async {
    final solicitou = await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (_) => DetalheEquipamentoScreen(
        equipamento: e,
        favoritoInicial: _favoritos.contains(e.id),
        onFavoritar: () => _alternarFavorito(e.id),
      ),
    ));
    if (solicitou == true) await _carregarLocal();
  }

  @override
  Widget build(BuildContext context) {
    final favoritosLista = _equipamentos.where((e) => _favoritos.contains(e.id)).toList();
    return Scaffold(
      body: IndexedStack(
        index: _aba,
        children: [
          HomeScreen(
            estado: _estado,
            erro: _erro,
            equipamentos: _equipamentos,
            favoritos: _favoritos,
            onTentarNovamente: _carregar,
            onRefresh: () => _carregar(silencioso: true),
            onFavoritar: _alternarFavorito,
            onAbrirDetalhe: _abrirDetalhe,
          ),
          MeusPedidosScreen(pedidos: _pedidos, onCancelar: _cancelarPedido),
          PerfilScreen(
            favoritos: favoritosLista,
            favoritosIds: _favoritos,
            onFavoritar: _alternarFavorito,
            onAbrirDetalhe: _abrirDetalhe,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _aba,
        onTap: (i) => setState(() => _aba = i),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
            icon: Badge(
                isLabelVisible: _pedidos.isNotEmpty,
                label: Text('${_pedidos.length}'),
                child: const Icon(Icons.receipt_long)),
            label: 'Meus pedidos',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
