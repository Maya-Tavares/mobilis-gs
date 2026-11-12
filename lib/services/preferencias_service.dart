import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/pedido.dart';
import '../models/perfil.dart';

/// Persistência local: onboarding, favoritos, pedidos e perfil.
class PreferenciasService {
  static const _kOnboarding = 'onboarding_visto';
  static const _kFavoritos = 'favoritos';
  static const _kPedidos = 'pedidos';
  static const _kPerfil = 'perfil';

  Future<bool> onboardingVisto() async =>
      (await SharedPreferences.getInstance()).getBool(_kOnboarding) ?? false;

  Future<void> salvarOnboardingVisto(bool visto) async =>
      (await SharedPreferences.getInstance()).setBool(_kOnboarding, visto);

  Future<Set<int>> favoritos() async {
    final lista = (await SharedPreferences.getInstance()).getStringList(_kFavoritos) ?? [];
    return lista.map(int.parse).toSet();
  }

  /// Alterna o favorito e devolve o novo conjunto.
  Future<Set<int>> alternarFavorito(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final atual = await favoritos();
    atual.contains(id) ? atual.remove(id) : atual.add(id);
    await prefs.setStringList(_kFavoritos, atual.map((e) => e.toString()).toList());
    return atual;
  }

  Future<List<Pedido>> pedidos() async {
    final lista = (await SharedPreferences.getInstance()).getStringList(_kPedidos) ?? [];
    return lista.map((s) => Pedido.fromJson(jsonDecode(s) as Map<String, dynamic>)).toList();
  }

  Future<void> _gravarPedidos(List<Pedido> pedidos) async =>
      (await SharedPreferences.getInstance())
          .setStringList(_kPedidos, pedidos.map((p) => jsonEncode(p.toJson())).toList());

  /// Já existe pedido ativo para o equipamento?
  Future<bool> temPedido(int equipamentoId) async =>
      (await pedidos()).any((p) => p.equipamentoId == equipamentoId);

  Future<void> adicionarPedido(Pedido pedido) async {
    final lista = await pedidos();
    lista.add(pedido);
    await _gravarPedidos(lista);
  }

  Future<List<Pedido>> cancelarPedido(int equipamentoId) async {
    final lista = (await pedidos())..removeWhere((p) => p.equipamentoId == equipamentoId);
    await _gravarPedidos(lista);
    return lista;
  }

  Future<Perfil> perfil() async {
    final s = (await SharedPreferences.getInstance()).getString(_kPerfil);
    return s == null ? const Perfil() : Perfil.fromJson(jsonDecode(s) as Map<String, dynamic>);
  }

  Future<void> salvarPerfil(Perfil perfil) async =>
      (await SharedPreferences.getInstance()).setString(_kPerfil, jsonEncode(perfil.toJson()));
}
