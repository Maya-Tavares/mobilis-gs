import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/endereco.dart';

/// Erro de regra do CEP (formato inválido ou CEP inexistente), com mensagem pronta para o usuário.
class CepException implements Exception {
  final String mensagem;
  const CepException(this.mensagem);
  @override
  String toString() => mensagem;
}

class CepService {
  final http.Client _client;
  CepService({http.Client? client}) : _client = client ?? http.Client();

  /// Mantém só os dígitos do CEP.
  static String limpar(String cep) => cep.replaceAll(RegExp(r'\D'), '');

  /// Consulta o ViaCEP. Lança [CepException] para CEP inválido ou inexistente; erros de rede propagam.
  Future<Endereco> buscar(String cep) async {
    final limpo = limpar(cep);
    if (limpo.length != 8) throw const CepException('CEP deve ter 8 dígitos.');
    final resposta = await _client
        .get(Uri.parse('https://viacep.com.br/ws/$limpo/json/'))
        .timeout(const Duration(seconds: 10));
    if (resposta.statusCode != 200) {
      throw Exception('Falha ao consultar o CEP (HTTP ${resposta.statusCode}).');
    }
    final json = jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>;
    if (json['erro'] == true || json['erro'] == 'true') {
      throw const CepException('CEP não encontrado. Confira os números e tente novamente.');
    }
    return Endereco.fromJson(json);
  }
}
