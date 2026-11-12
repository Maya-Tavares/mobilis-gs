import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobilis/models/endereco.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobilis/models/equipamento.dart';
import 'package:mobilis/services/cep_service.dart';

void main() {
  test('Equipamento.fromJson converte o primeiro item de data/equipamentos.json', () {
    final lista = jsonDecode(File('data/equipamentos.json').readAsStringSync()) as List;
    expect(lista.length, 18);
    final e = Equipamento.fromJson(lista.first as Map<String, dynamic>);
    expect(e.id, 1);
    expect(e.tipo, 'Cadeira de rodas');
    expect(e.modalidades, contains('Empréstimo'));
    expect(e.instituicao.latitude, isA<double>());
    expect(e.disponivel, isTrue);
  });

  test('Equipamento.toJson e fromJson são simétricos', () {
    final lista = jsonDecode(File('data/equipamentos.json').readAsStringSync()) as List;
    final e = Equipamento.fromJson(lista[3] as Map<String, dynamic>);
    expect(Equipamento.fromJson(e.toJson()).toJson(), e.toJson());
  });

  test('Endereco.fromJson lê campos do ViaCEP', () {
    final e = Endereco.fromJson({
      'logradouro': 'Avenida Paulista',
      'bairro': 'Bela Vista',
      'localidade': 'São Paulo',
      'uf': 'SP',
    });
    expect(e.localidade, 'São Paulo');
    expect(e.uf, 'SP');
  });

  test('CepService trata "erro": true do ViaCEP como falha amigável', () async {
    final client = MockClient((_) async => http.Response('{"erro": true}', 200));
    expect(CepService(client: client).buscar('00000-000'), throwsA(isA<CepException>()));
  });

  test('CepService devolve Endereco para CEP válido', () async {
    final client = MockClient((_) async => http.Response.bytes(
        utf8.encode('{"logradouro":"Avenida Paulista","bairro":"Bela Vista","localidade":"São Paulo","uf":"SP"}'),
        200));
    final e = await CepService(client: client).buscar('01310-100');
    expect(e.bairro, 'Bela Vista');
  });
}
