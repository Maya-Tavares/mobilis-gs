import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/endereco.dart';

class CepService {
  final http.Client _client;
  CepService({http.Client? client}) : _client = client ?? http.Client();

  /// Mantém só os dígitos do CEP.
  static String limpar(String cep) => cep.replaceAll(RegExp(r'\D'), '');

  /// Consulta o ViaCEP. Lança [Exception] para CEP inválido, inexistente ou erro de rede.
  Future<Endereco> buscar(String cep) async {
    final limpo = limpar(cep);
    if (limpo.length != 8) throw Exception('CEP deve ter 8 dígitos.');
    final resposta = await _client
        .get(Uri.parse('https://viacep.com.br/ws/$limpo/json/'))
        .timeout(const Duration(seconds: 10));
    if (resposta.statusCode != 200) {
      throw Exception('Falha ao consultar o CEP (HTTP ${resposta.statusCode}).');
    }
    final json = jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>;
    if (json['erro'] == true || json['erro'] == 'true') {
      throw Exception('CEP não encontrado.');
    }
    return Endereco.fromJson(json);
  }
}
