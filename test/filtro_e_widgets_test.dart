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

  testWidgets('EquipamentoCard usa a imagem local do tipo e o ícone de reserva na cadeira de rodas',
      (tester) async {
    final lista = _carregar();
    final andador = lista.firstWhere((e) => e.tipo == 'Andador');
    final cadeira = lista.firstWhere((e) => e.tipo == 'Cadeira de rodas');
    for (final e in [andador, cadeira]) {
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
      await tester.pump();
      expect(find.text(e.tipo), findsOneWidget);
    }
    // Cadeira de rodas: sem asset, a foto da API falha no teste e mostra o ícone de reserva.
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byIcon(Icons.accessible), findsOneWidget);
  });
}
