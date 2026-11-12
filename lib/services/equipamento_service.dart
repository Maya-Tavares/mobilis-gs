import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/equipamento.dart';

class EquipamentoService {
  static const String urlRaw =
      'https://raw.githubusercontent.com/Maya-Tavares/mobilis-flutter/main/data/equipamentos.json';

  final http.Client _client;
  EquipamentoService({http.Client? client}) : _client = client ?? http.Client();

  /// Baixa e converte o JSON de equipamentos. Lança [Exception] em caso de falha.
  Future<List<Equipamento>> listar() async {
    final resposta = await _client.get(Uri.parse(urlRaw)).timeout(const Duration(seconds: 15));
    if (resposta.statusCode != 200) {
      throw Exception('Falha ao carregar equipamentos (HTTP ${resposta.statusCode}).');
    }
    final lista = jsonDecode(utf8.decode(resposta.bodyBytes)) as List;
    return lista.map((e) => Equipamento.fromJson(e as Map<String, dynamic>)).toList();
  }
}
