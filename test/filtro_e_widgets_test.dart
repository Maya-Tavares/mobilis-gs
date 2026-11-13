import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilis/models/equipamento.dart';
import 'package:mobilis/screens/onboarding_screen.dart';
import 'package:mobilis/services/filtro_service.dart';
import 'package:mobilis/widgets/equipamento_card.dart';
import 'package:mobilis/widgets/status_chip.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Equipamento> _carregar() =>
    (jsonDecode(File('data/equipamentos.json').readAsStringSync()) as List)
        .map((e) => Equipamento.fromJson(e as Map<String, dynamic>))
        .toList();

void main() {
  test('Filtro por tipo, modalidade e busca sem acento', () {
    final lista = _carregar();
    final andadores = FiltroEquipamentos.aplicar(lista, tipo: 'Andador');
    expect(andadores.length, 3);
    final doacao = FiltroEquipamentos.aplicar(lista, modalidade: 'Doação');
    expect(doacao.every((e) => e.modalidades.contains('Doação')), isTrue);
    expect(FiltroEquipamentos.aplicar(lista, busca: 'consolacao').isNotEmpty, isTrue);
    expect(FiltroEquipamentos.aplicar(lista, busca: 'zzzz'), isEmpty);
  });

  testWidgets('StatusChip mostra o texto do status', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: StatusChip(status: 'Reservado'))));
    expect(find.text('Reservado'), findsOneWidget);
  });

  testWidgets('Onboarding avança de página', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));
    expect(find.text('Encontre perto de você'), findsOneWidget);
    await tester.tap(find.text('Avançar'));
    await tester.pumpAndSettle();
    expect(find.text('Peça por empréstimo ou doação'), findsOneWidget);
  });

  testWidgets('EquipamentoCard mostra imagem local; tipo sem imagem usa o ícone de reserva', (tester) async {
    final json = jsonDecode(File('data/equipamentos.json').readAsStringSync()) as List;
    final comImagem = Equipamento.fromJson(json.first as Map<String, dynamic>);
    final semImagem = Equipamento.fromJson(
        {...(json.first as Map<String, dynamic>), 'tipo': 'Tipo novo sem foto'});
    expect(comImagem.fotoAsset, isNotNull);
    expect(semImagem.fotoAsset, isNull);
    for (final e in [comImagem, semImagem]) {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 220,
            height: 320,
            child: EquipamentoCard(
                equipamento: e, favorito: false, onTap: () {}, onFavoritar: () {}),
          ),
        ),
      ));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text(e.tipo), findsOneWidget);
    }
    expect(find.byIcon(Icons.accessible), findsOneWidget);
  });
}
